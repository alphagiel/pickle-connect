import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/proposal.dart';
import '../models/user.dart';

final proposalsRepositoryProvider = Provider<ProposalsRepository>((ref) {
  return ProposalsRepository();
});

class ProposalsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'proposals';
  final Set<String> _pendingExpirations = {};

  // Get singles proposals filtered by skill bracket and zone
  // Users see all proposals in their bracket (e.g., 3.0 and 3.5 players see each other)
  // Filters out doubles proposals
  Stream<List<Proposal>> getProposalsForBracketAndZone(SkillBracket bracket, String zone) {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'open')
        .where('skillBracket', isEqualTo: bracket.jsonValue)
        .where('zone', isEqualTo: zone)
        .snapshots()
        .map((snapshot) {
          final proposals = <Proposal>[];
          for (final doc in snapshot.docs) {
            try {
              final data = Map<String, dynamic>.from(doc.data());
              data['proposalId'] = doc.id;

              final proposal = Proposal.fromJson(data);

              // Skip doubles proposals in singles view
              if (proposal.matchType == MatchType.doubles) continue;

              // Check if proposal should be expired and mark it locally
              if (proposal.shouldExpire && proposal.status != ProposalStatus.expired) {
                _scheduleExpireProposal(proposal.proposalId);
                proposals.add(proposal.copyWith(status: ProposalStatus.expired));
              } else {
                proposals.add(proposal);
              }
            } catch (e) {
              print('Error parsing proposal: $e');
              print('Document data: ${doc.data()}');
            }
          }
          proposals.sort(_sortProposals);
          return proposals;
        });
  }

  // Legacy method - redirects to bracket+zone filtering
  Stream<List<Proposal>> getProposalsForSkillLevel(SkillLevel skillLevel, String zone) {
    return getProposalsForBracketAndZone(skillLevel.bracket, zone);
  }

  // Get all open proposals (only status = 'open')
  Stream<List<Proposal>> getOpenProposals() {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'open')
        .orderBy('dateTime')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              try {
                // Extract data and ensure we use the actual Firestore document ID
                final data = Map<String, dynamic>.from(doc.data());
                data['proposalId'] = doc.id; // Always use the real Firestore ID

                final proposal = Proposal.fromJson(data);

                // Check if proposal should be expired and mark it locally
                if (proposal != null && proposal.shouldExpire && proposal.status != ProposalStatus.expired) {
                  _scheduleExpireProposal(proposal.proposalId);
                  return proposal.copyWith(status: ProposalStatus.expired);
                }

                return proposal;
              } catch (e) {
                print('Error parsing proposal: $e');
                print('Document data: ${doc.data()}');
                return null;
              }
            })
            .where((proposal) => proposal != null)
            .cast<Proposal>()
            .toList()
            ..sort(_sortProposals));
  }

  // Get user's proposals (created)
  Stream<List<Proposal>> getUserProposals(String userId) {
    return _firestore
        .collection(_collection)
        .where('creatorId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              try {
                // Extract data and ensure we use the actual Firestore document ID
                final data = Map<String, dynamic>.from(doc.data());
                data['proposalId'] = doc.id; // Always use the real Firestore ID

                final proposal = Proposal.fromJson(data);

                // Check if proposal should be expired and mark it locally
                if (proposal != null && proposal.shouldExpire && proposal.status != ProposalStatus.expired) {
                  _scheduleExpireProposal(proposal.proposalId);
                  return proposal.copyWith(status: ProposalStatus.expired);
                }

                return proposal;
              } catch (e) {
                print('Error parsing proposal: $e');
                print('Document data: ${doc.data()}');
                return null;
              }
            })
            .where((proposal) => proposal != null)
            .cast<Proposal>()
            .toList()
            ..sort(_sortProposals));
  }

  // Get proposals user accepted
  Stream<List<Proposal>> getAcceptedProposals(String userId) {
    // Note: No orderBy to avoid needing composite index on acceptedBy.userId + createdAt
    return _firestore
        .collection(_collection)
        .where('acceptedBy.userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final proposals = <Proposal>[];
          for (final doc in snapshot.docs) {
            try {
              final data = Map<String, dynamic>.from(doc.data());
              data['proposalId'] = doc.id;

              final proposal = Proposal.fromJson(data);

              // Check if proposal should be expired and mark it locally
              if (proposal.shouldExpire && proposal.status != ProposalStatus.expired) {
                _scheduleExpireProposal(proposal.proposalId);
                proposals.add(proposal.copyWith(status: ProposalStatus.expired));
              } else {
                proposals.add(proposal);
              }
            } catch (e) {
              print('Error parsing proposal: $e');
              print('Document data: ${doc.data()}');
            }
          }
          // Sort client-side by createdAt descending
          proposals.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return proposals;
        });
  }

  // Get completed proposals where user is creator or acceptor
  // Uses two separate queries to comply with Firestore security rules
  Stream<List<Proposal>> getCompletedProposals(String userId) {
    // Query 1: Completed proposals where user is creator
    final createdStream = _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'completed')
        .where('creatorId', isEqualTo: userId)
        .snapshots();

    // Query 2: Completed proposals where user is acceptor
    final acceptedStream = _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'completed')
        .where('acceptedBy.userId', isEqualTo: userId)
        .snapshots();

    // Combine both streams
    return createdStream.asyncExpand((createdSnapshot) {
      return acceptedStream.map((acceptedSnapshot) {
        final proposalsMap = <String, Proposal>{};

        // Add created proposals
        for (final doc in createdSnapshot.docs) {
          try {
            final data = Map<String, dynamic>.from(doc.data());
            data['proposalId'] = doc.id;
            final proposal = Proposal.fromJson(data);
            proposalsMap[doc.id] = proposal;
          } catch (e) {
            print('Error parsing completed proposal: $e');
          }
        }

        // Add accepted proposals (deduplicates if user created and accepted somehow)
        for (final doc in acceptedSnapshot.docs) {
          try {
            final data = Map<String, dynamic>.from(doc.data());
            data['proposalId'] = doc.id;
            final proposal = Proposal.fromJson(data);
            proposalsMap[doc.id] = proposal;
          } catch (e) {
            print('Error parsing completed proposal: $e');
          }
        }

        final proposals = proposalsMap.values.toList();
        proposals.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        return proposals;
      });
    });
  }

  // Get completed proposals by skill bracket and zone (for standings page)
  Stream<List<Proposal>> getCompletedProposalsByBracketAndZone(SkillBracket bracket, String zone) {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'completed')
        .where('skillBracket', isEqualTo: bracket.jsonValue)
        .where('zone', isEqualTo: zone)
        .snapshots()
        .map((snapshot) {
          final proposals = <Proposal>[];
          for (final doc in snapshot.docs) {
            try {
              final data = Map<String, dynamic>.from(doc.data());
              data['proposalId'] = doc.id;
              final proposal = Proposal.fromJson(data);
              // Only include matches that have scores
              if (proposal.scores != null) {
                proposals.add(proposal);
              }
            } catch (e) {
              print('Error parsing completed proposal: $e');
            }
          }
          // Sort by date, most recent first
          proposals.sort((a, b) => b.dateTime.compareTo(a.dateTime));
          return proposals;
        });
  }

  // Legacy method - redirects to bracket+zone filtering
  Stream<List<Proposal>> getCompletedProposalsBySkillLevel(SkillLevel skillLevel, String zone) {
    return getCompletedProposalsByBracketAndZone(skillLevel.bracket, zone);
  }

  // Get expired proposals where user is creator or acceptor
  // Uses two separate queries to comply with Firestore security rules
  Stream<List<Proposal>> getExpiredProposals(String userId) {
    // Query 1: Expired proposals where user is creator
    final createdStream = _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'expired')
        .where('creatorId', isEqualTo: userId)
        .snapshots();

    // Query 2: Expired proposals where user is acceptor
    final acceptedStream = _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'expired')
        .where('acceptedBy.userId', isEqualTo: userId)
        .snapshots();

    // Combine both streams
    return createdStream.asyncExpand((createdSnapshot) {
      return acceptedStream.map((acceptedSnapshot) {
        final proposalsMap = <String, Proposal>{};

        // Add created proposals
        for (final doc in createdSnapshot.docs) {
          try {
            final data = Map<String, dynamic>.from(doc.data());
            data['proposalId'] = doc.id;
            final proposal = Proposal.fromJson(data);
            proposalsMap[doc.id] = proposal;
          } catch (e) {
            print('Error parsing expired proposal: $e');
          }
        }

        // Add accepted proposals
        for (final doc in acceptedSnapshot.docs) {
          try {
            final data = Map<String, dynamic>.from(doc.data());
            data['proposalId'] = doc.id;
            final proposal = Proposal.fromJson(data);
            proposalsMap[doc.id] = proposal;
          } catch (e) {
            print('Error parsing expired proposal: $e');
          }
        }

        final proposals = proposalsMap.values.toList();
        proposals.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        return proposals;
      });
    });
  }

  // Get a single proposal by ID
  Future<Proposal?> getProposalById(String proposalId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(proposalId).get();
      if (!doc.exists) {
        return null;
      }
      final data = Map<String, dynamic>.from(doc.data()!);
      data['proposalId'] = doc.id;
      return Proposal.fromJson(data);
    } catch (e) {
      print('Error fetching proposal $proposalId: $e');
      return null;
    }
  }

  // Create new proposal
  Future<void> createProposal(Proposal proposal) async {
    final proposalData = proposal.toJson();

    // Remove null values for Firestore compatibility
    proposalData.removeWhere((key, value) => value == null);

    // Convert special list types to regular List for Firestore compatibility
    if (proposalData.containsKey('scoreConfirmedBy')) {
      proposalData['scoreConfirmedBy'] = List<String>.from(proposalData['scoreConfirmedBy']);
    }

    await _firestore.collection(_collection).add(proposalData).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw Exception('Firestore write operation timed out after 10 seconds');
      },
    );
  }

  // Accept proposal
  Future<void> acceptProposal(String proposalId, String userId, String displayName) async {
    await _firestore.collection(_collection).doc(proposalId).update({
      'status': 'accepted',
      'acceptedBy': {
        'userId': userId,
        'displayName': displayName,
      },
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Unaccept proposal
  Future<void> unacceptProposal(String proposalId) async {
    await _firestore.collection(_collection).doc(proposalId).update({
      'status': 'open',
      'acceptedBy': null,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Update scores with per-game results (best of 3) and mark as completed
  Future<void> updateScores(String proposalId, List<Map<String, int>> games) async {
    await _firestore.collection(_collection).doc(proposalId).update({
      'scores': {
        'games': games,
      },
      'status': 'completed', // Auto-complete when scores are recorded
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Confirm scores
  Future<void> confirmScores(String proposalId, String userId) async {
    await _firestore.collection(_collection).doc(proposalId).update({
      'scoreConfirmedBy': FieldValue.arrayUnion([userId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Clear scores (when rejected)
  Future<void> clearScores(String proposalId) async {
    await _firestore.collection(_collection).doc(proposalId).update({
      'scores': FieldValue.delete(),
      'scoreConfirmedBy': [],
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Complete match (when both confirm scores)
  Future<void> completeMatch(String proposalId) async {
    await _firestore.collection(_collection).doc(proposalId).update({
      'status': 'completed',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Cancel proposal
  Future<void> cancelProposal(String proposalId) async {
    await _firestore.collection(_collection).doc(proposalId).update({
      'status': 'canceled',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Delete proposal
  Future<void> deleteProposal(String proposalId) async {
    await _firestore.collection(_collection).doc(proposalId).delete();
  }


  // Update proposal
  Future<void> updateProposal(
    String proposalId, {
    SkillLevel? skillLevel,
    String? location,
    DateTime? dateTime,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (skillLevel != null) {
      updates['skillLevel'] = skillLevel.jsonValue;
    }

    if (location != null) {
      updates['location'] = location;
    }

    if (dateTime != null) {
      updates['dateTime'] = dateTime.toIso8601String();
    }

    await _firestore.collection(_collection).doc(proposalId).update(updates);
  }

  // Update user's display name in all their proposals
  Future<void> updateUserNameInProposals(String userId, String newDisplayName) async {
    // Update proposals where user is the creator
    final createdProposals = await _firestore
        .collection(_collection)
        .where('creatorId', isEqualTo: userId)
        .get();

    for (final doc in createdProposals.docs) {
      await doc.reference.update({
        'creatorName': newDisplayName,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    // Update proposals where user is the acceptor
    final acceptedProposals = await _firestore
        .collection(_collection)
        .where('acceptedBy.userId', isEqualTo: userId)
        .get();

    for (final doc in acceptedProposals.docs) {
      await doc.reference.update({
        'acceptedBy.displayName': newDisplayName,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Cancel all open proposals for a user being deleted
  Future<void> cancelAllOpenProposalsForUser(String userId) async {
    // 1. Cancel open/accepted singles proposals where user is creator
    final createdProposals = await _firestore
        .collection(_collection)
        .where('creatorId', isEqualTo: userId)
        .where('status', whereIn: ['open', 'accepted'])
        .get();

    for (final doc in createdProposals.docs) {
      await doc.reference.update({
        'status': 'canceled',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    // 2. Revert accepted proposals where user is acceptor back to open
    final acceptedAsOpponent = await _firestore
        .collection(_collection)
        .where('acceptedBy.userId', isEqualTo: userId)
        .where('status', isEqualTo: 'accepted')
        .get();

    for (final doc in acceptedAsOpponent.docs) {
      await doc.reference.update({
        'status': 'open',
        'acceptedBy': null,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    // 3. Cancel doubles proposals where user is creator
    final doublesCreated = await _firestore
        .collection(_collection)
        .where('matchType', isEqualTo: 'doubles')
        .where('creatorId', isEqualTo: userId)
        .where('status', whereIn: ['open', 'accepted'])
        .get();

    for (final doc in doublesCreated.docs) {
      await doc.reference.update({
        'status': 'canceled',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    // 4. Remove user from doubles proposals where user is a participant (not creator)
    final doublesParticipant = await _firestore
        .collection(_collection)
        .where('matchType', isEqualTo: 'doubles')
        .where('playerIds', arrayContains: userId)
        .where('status', whereIn: ['open', 'accepted'])
        .get();

    for (final doc in doublesParticipant.docs) {
      final data = doc.data();
      if (data['creatorId'] == userId) continue; // Already handled above

      final players = (data['doublesPlayers'] as List<dynamic>?)
          ?.map((p) => Map<String, dynamic>.from(p as Map))
          .toList() ?? [];

      final updatedPlayers = players.where((p) => p['userId'] != userId).toList();
      final openSlots = (data['openSlots'] as int? ?? 0) + 1;

      await doc.reference.update({
        'doublesPlayers': updatedPlayers,
        'playerIds': FieldValue.arrayRemove([userId]),
        'openSlots': openSlots,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Anonymize a deleted user in completed/historical proposals
  Future<void> anonymizeUserInProposals(String userId) async {
    await updateUserNameInProposals(userId, 'Former Player');
  }

  // Mark proposal as expired
  Future<void> expireProposal(String proposalId) async {
    await _firestore.collection(_collection).doc(proposalId).update({
      'status': 'expired',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Auto-complete expired proposal
  Future<void> autoCompleteProposal(String proposalId) async {
    await _firestore.collection(_collection).doc(proposalId).update({
      'status': 'completed',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get proposals that need lifecycle updates
  Future<List<Proposal>> getProposalsForCleanup() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('status', whereIn: ['open', 'accepted', 'expired', 'completed'])
          .get();

      final proposals = <Proposal>[];

      for (final doc in snapshot.docs) {
        try {
          final data = doc.data();
          if (data.isEmpty) {
            print('Skipping empty document ${doc.id}');
            continue;
          }

          // Check for required fields before attempting to parse
          // Accept either skillLevel (new) or skillLevels (old) - migration will fix it
          final hasSkillField = data.containsKey('skillLevel') || data.containsKey('skillLevels');
          final requiredFields = ['creatorName', 'dateTime', 'createdAt', 'updatedAt'];
          if (!hasSkillField) {
            print('Skipping proposal ${doc.id} - missing skill level field');
            continue;
          }
          final missingFields = requiredFields.where((field) => !data.containsKey(field) || data[field] == null).toList();

          if (missingFields.isNotEmpty) {
            print('Skipping invalid proposal ${doc.id} - missing required fields: $missingFields');
            continue;
          }

          final proposal = Proposal.fromJson({
            ...data,
            'proposalId': doc.id, // Must come LAST to use actual Firestore doc ID
          });
          proposals.add(proposal);
        } catch (e) {
          // Check if this is the specific test-proposal with missing required fields
          if (doc.id == 'test-proposal') {
            print('Skipping test-proposal with incomplete data');
            continue;
          }
          print('Error parsing proposal ${doc.id} for cleanup: $e');
          print('Document data: ${doc.data()}');
          // Skip invalid proposals
          continue;
        }
      }

      return proposals;
    } catch (e) {
      print('Error fetching proposals for cleanup: $e');
      return [];
    }
  }

  // Run cleanup operations
  Future<void> runCleanup() async {
    final proposals = await getProposalsForCleanup();
    if (proposals.isEmpty) return;

    for (final proposal in proposals) {
      try {
        final doc = await _firestore.collection(_collection).doc(proposal.proposalId).get();
        if (!doc.exists) continue;

        if (proposal.shouldDelete) {
          await deleteProposal(proposal.proposalId);
        } else if (proposal.shouldAutoComplete) {
          await autoCompleteProposal(proposal.proposalId);
        } else if (proposal.shouldExpire) {
          await expireProposal(proposal.proposalId);
        }
      } catch (_) {
        // Non-critical — cleanup is best-effort
      }
    }
  }

  // Schedule a proposal to be marked as expired in the database (deduplicated)
  void _scheduleExpireProposal(String proposalId) {
    if (_pendingExpirations.contains(proposalId)) return;
    _pendingExpirations.add(proposalId);

    Future(() async {
      try {
        final doc = await _firestore.collection(_collection).doc(proposalId).get();
        if (!doc.exists) return;
        await expireProposal(proposalId);
      } catch (_) {
        // Non-critical — expiration is best-effort
      } finally {
        _pendingExpirations.remove(proposalId);
      }
    });
  }

  // Migrate old proposals from skillLevels array to skillLevel single value
  Future<void> migrateSkillLevels() async {
    print('Starting skillLevel migration...');

    try {
      // Get all proposals that have skillLevels but not skillLevel
      final snapshot = await _firestore.collection(_collection).get();

      int migrated = 0;
      for (final doc in snapshot.docs) {
        final data = doc.data();

        // Check if needs migration (has skillLevels array but no skillLevel)
        if (data.containsKey('skillLevels') && !data.containsKey('skillLevel')) {
          final skillLevels = data['skillLevels'] as List<dynamic>;
          if (skillLevels.isNotEmpty) {
            final firstSkillLevel = skillLevels.first as String;

            await doc.reference.update({
              'skillLevel': firstSkillLevel,
            });

            print('Migrated proposal ${doc.id}: skillLevels=$skillLevels -> skillLevel=$firstSkillLevel');
            migrated++;
          }
        }
      }

      print('Migration complete. Migrated $migrated proposals.');
    } catch (e) {
      print('Error during migration: $e');
    }
  }

  // ============================
  // Doubles-specific methods
  // ============================

  /// Get open doubles proposals for a skill bracket and zone
  Stream<List<Proposal>> getDoublesProposalsForBracketAndZone(SkillBracket bracket, String zone) {
    return _firestore
        .collection(_collection)
        .where('matchType', isEqualTo: 'doubles')
        .where('status', isEqualTo: 'open')
        .where('skillBracket', isEqualTo: bracket.jsonValue)
        .where('zone', isEqualTo: zone)
        .snapshots()
        .map((snapshot) {
          final proposals = <Proposal>[];
          for (final doc in snapshot.docs) {
            try {
              final data = Map<String, dynamic>.from(doc.data());
              data['proposalId'] = doc.id;
              final proposal = Proposal.fromJson(data);

              if (proposal.shouldExpire && proposal.status != ProposalStatus.expired) {
                _scheduleExpireProposal(proposal.proposalId);
                proposals.add(proposal.copyWith(status: ProposalStatus.expired));
              } else {
                proposals.add(proposal);
              }
            } catch (e) {
              print('Error parsing doubles proposal: $e');
            }
          }
          proposals.sort(_sortProposals);
          return proposals;
        });
  }

  /// Get doubles proposals where user is a player (any status)
  Stream<List<Proposal>> getUserDoublesProposals(String userId) {
    return _firestore
        .collection(_collection)
        .where('matchType', isEqualTo: 'doubles')
        .where('playerIds', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
          final proposals = <Proposal>[];
          for (final doc in snapshot.docs) {
            try {
              final data = Map<String, dynamic>.from(doc.data());
              data['proposalId'] = doc.id;
              final proposal = Proposal.fromJson(data);
              proposals.add(proposal);
            } catch (e) {
              print('Error parsing user doubles proposal: $e');
            }
          }
          proposals.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return proposals;
        });
  }

  /// Get completed doubles proposals for a user
  Stream<List<Proposal>> getCompletedDoublesProposals(String userId) {
    return _firestore
        .collection(_collection)
        .where('matchType', isEqualTo: 'doubles')
        .where('status', isEqualTo: 'completed')
        .where('playerIds', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
          final proposals = <Proposal>[];
          for (final doc in snapshot.docs) {
            try {
              final data = Map<String, dynamic>.from(doc.data());
              data['proposalId'] = doc.id;
              final proposal = Proposal.fromJson(data);
              proposals.add(proposal);
            } catch (e) {
              print('Error parsing completed doubles proposal: $e');
            }
          }
          proposals.sort((a, b) => b.dateTime.compareTo(a.dateTime));
          return proposals;
        });
  }

  /// Request to join a doubles proposal
  Future<void> requestJoinDoubles(String proposalId, DoublesPlayer player) async {
    await _firestore.collection(_collection).doc(proposalId).update({
      'doublesPlayers': FieldValue.arrayUnion([player.toJson()]),
      'playerIds': FieldValue.arrayUnion([player.userId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Approve a doubles player, assign team and confirm
  Future<void> approveDoublesPlayer(String proposalId, String userId, int team) async {
    final doc = await _firestore.collection(_collection).doc(proposalId).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final players = (data['doublesPlayers'] as List<dynamic>?)
        ?.map((p) => Map<String, dynamic>.from(p as Map))
        .toList() ?? [];

    final updatedPlayers = players.map((p) {
      if (p['userId'] == userId) {
        return {
          ...p,
          'status': 'confirmed',
          'team': team,
        };
      }
      return p;
    }).toList();

    final openSlots = (data['openSlots'] as int? ?? 0) - 1;

    await _firestore.collection(_collection).doc(proposalId).update({
      'doublesPlayers': updatedPlayers,
      'openSlots': openSlots < 0 ? 0 : openSlots,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Decline a doubles player join request
  Future<void> declineDoublesPlayer(String proposalId, String userId) async {
    final doc = await _firestore.collection(_collection).doc(proposalId).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final players = (data['doublesPlayers'] as List<dynamic>?)
        ?.map((p) => Map<String, dynamic>.from(p as Map))
        .toList() ?? [];

    final updatedPlayers = players.where((p) => p['userId'] != userId).toList();

    await _firestore.collection(_collection).doc(proposalId).update({
      'doublesPlayers': updatedPlayers,
      'playerIds': FieldValue.arrayRemove([userId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Leave a doubles proposal (for confirmed players)
  Future<void> leaveDoublesProposal(String proposalId, String userId) async {
    final doc = await _firestore.collection(_collection).doc(proposalId).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final players = (data['doublesPlayers'] as List<dynamic>?)
        ?.map((p) => Map<String, dynamic>.from(p as Map))
        .toList() ?? [];

    final updatedPlayers = players.where((p) => p['userId'] != userId).toList();
    final openSlots = (data['openSlots'] as int? ?? 0) + 1;

    await _firestore.collection(_collection).doc(proposalId).update({
      'doublesPlayers': updatedPlayers,
      'playerIds': FieldValue.arrayRemove([userId]),
      'openSlots': openSlots,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Confirm a partner invite (invited player accepts the invitation)
  Future<void> confirmPartnerInvite(String proposalId, String userId) async {
    final doc = await _firestore.collection(_collection).doc(proposalId).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final players = (data['doublesPlayers'] as List<dynamic>?)
        ?.map((p) => Map<String, dynamic>.from(p as Map))
        .toList() ?? [];

    final updatedPlayers = players.map((p) {
      if (p['userId'] == userId) {
        return {...p, 'status': 'confirmed'};
      }
      return p;
    }).toList();

    await _firestore.collection(_collection).doc(proposalId).update({
      'doublesPlayers': updatedPlayers,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Sort proposals: Active first (by date), then expired (by date)
  int _sortProposals(Proposal a, Proposal b) {
    // Active proposals (open/accepted) come first
    final aIsActive = a.status == ProposalStatus.open || a.status == ProposalStatus.accepted;
    final bIsActive = b.status == ProposalStatus.open || b.status == ProposalStatus.accepted;

    if (aIsActive && !bIsActive) return -1; // a comes first
    if (!aIsActive && bIsActive) return 1;  // b comes first

    // If both have same active status, sort by date
    if (aIsActive && bIsActive) {
      // Active proposals: upcoming first
      return a.dateTime.compareTo(b.dateTime);
    } else {
      // Expired proposals: most recent first
      return b.dateTime.compareTo(a.dateTime);
    }
  }
}