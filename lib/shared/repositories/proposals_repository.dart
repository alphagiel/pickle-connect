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

  // Get proposals filtered by skill level
  Stream<List<Proposal>> getProposalsForSkillLevel(SkillLevel skillLevel) {
    // Use the JsonValue instead of displayName
    String skillLevelValue;
    switch (skillLevel) {
      case SkillLevel.beginner:
        skillLevelValue = 'Beginner';
        break;
      case SkillLevel.intermediate:
        skillLevelValue = 'Intermediate';
        break;
      case SkillLevel.advancedPlus:
        skillLevelValue = 'Advanced+';
        break;
    }

    return _firestore
        .collection(_collection)
        .where('skillLevels', arrayContains: skillLevelValue)
        .where('status', whereIn: ['open', 'accepted', 'expired'])
        .orderBy('dateTime')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              try {
                final proposal = Proposal.fromJson({
                  'proposalId': doc.id,
                  ...doc.data(),
                });

                // Check if proposal should be expired and mark it locally
                if (proposal != null && proposal.shouldExpire && proposal.status != ProposalStatus.expired) {
                  // Schedule background update to mark as expired in database
                  _scheduleExpireProposal(proposal.proposalId);

                  // Return expired version for immediate UI update
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

  // Get all open proposals
  Stream<List<Proposal>> getOpenProposals() {
    return _firestore
        .collection(_collection)
        .where('status', whereIn: ['open', 'accepted', 'expired'])
        .orderBy('dateTime')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              try {
                final proposal = Proposal.fromJson({
                  'proposalId': doc.id,
                  ...doc.data(),
                });

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
                final proposal = Proposal.fromJson({
                  'proposalId': doc.id,
                  ...doc.data(),
                });

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
    return _firestore
        .collection(_collection)
        .where('acceptedBy.userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              try {
                final proposal = Proposal.fromJson({
                  'proposalId': doc.id,
                  ...doc.data(),
                });

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

  // Create new proposal
  Future<void> createProposal(Proposal proposal) async {
    print('=== Creating proposal ===');
    print('Original proposal: $proposal');
    
    final proposalData = proposal.toJson();
    print('Proposal toJson result: $proposalData');
    
    // Check for null values
    final nullKeys = proposalData.entries.where((entry) => entry.value == null).map((e) => e.key).toList();
    if (nullKeys.isNotEmpty) {
      print('WARNING: Found null values for keys: $nullKeys');
    }
    
    // Check each field individually
    proposalData.forEach((key, value) {
      print('Field $key: $value (type: ${value.runtimeType})');
    });
    
    // Convert any null values to appropriate defaults for Firestore
    proposalData.removeWhere((key, value) => value == null);
    
    // Convert any special list types to regular List for Firestore compatibility
    if (proposalData.containsKey('scoreConfirmedBy')) {
      print('Converting scoreConfirmedBy from type: ${proposalData['scoreConfirmedBy'].runtimeType}');
      final newList = List<String>.from(proposalData['scoreConfirmedBy']);
      proposalData['scoreConfirmedBy'] = newList;
      print('Converted scoreConfirmedBy to type: ${proposalData['scoreConfirmedBy'].runtimeType}');
    }
    
    print('Final data to send: $proposalData');
    
    try {
      print('Attempting to write to Firestore collection: $_collection');
      
      // Add timeout to prevent hanging
      final result = await _firestore.collection(_collection).add(proposalData).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Firestore write operation timed out after 10 seconds');
        },
      );
      
      print('=== Proposal created successfully ===');
      print('Document ID: ${result.id}');
    } catch (e) {
      print('ERROR: Failed to create proposal: $e');
      print('Error type: ${e.runtimeType}');
      
      if (e.toString().contains('permission')) {
        print('FIRESTORE PERMISSION ERROR - Check Firebase security rules');
      } else if (e.toString().contains('network')) {
        print('FIRESTORE NETWORK ERROR - Check internet connection');
      } else if (e.toString().contains('timeout')) {
        print('FIRESTORE TIMEOUT ERROR - Operation took too long');
      }
      
      rethrow;
    }
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

  // Update scores
  Future<void> updateScores(String proposalId, int creatorScore, int opponentScore) async {
    await _firestore.collection(_collection).doc(proposalId).update({
      'scores': {
        'creatorScore': creatorScore,
        'opponentScore': opponentScore,
      },
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
    final snapshot = await _firestore
        .collection(_collection)
        .where('status', whereIn: ['open', 'accepted', 'expired', 'completed'])
        .get();

    return snapshot.docs
        .map((doc) {
          try {
            return Proposal.fromJson({
              'proposalId': doc.id,
              ...doc.data(),
            });
          } catch (e) {
            print('Error parsing proposal for cleanup: $e');
            return null;
          }
        })
        .where((proposal) => proposal != null)
        .cast<Proposal>()
        .toList();
  }

  // Run cleanup operations
  Future<void> runCleanup() async {
    print('Starting proposal cleanup...');

    final proposals = await getProposalsForCleanup();

    for (final proposal in proposals) {
      try {
        if (proposal.shouldDelete) {
          print('Deleting proposal ${proposal.proposalId} (${proposal.daysPastDue} days past due)');
          await deleteProposal(proposal.proposalId);
        } else if (proposal.shouldAutoComplete) {
          print('Auto-completing proposal ${proposal.proposalId} (${proposal.daysPastDue} days past due)');
          await autoCompleteProposal(proposal.proposalId);
        } else if (proposal.shouldExpire) {
          print('Expiring proposal ${proposal.proposalId} (${proposal.daysPastDue} days past due)');
          await expireProposal(proposal.proposalId);
        }
      } catch (e) {
        print('Error processing proposal ${proposal.proposalId}: $e');
      }
    }

    print('Proposal cleanup completed');
  }

  // Schedule a proposal to be marked as expired in the database
  void _scheduleExpireProposal(String proposalId) {
    // Run async operation without blocking the stream
    Future(() async {
      try {
        await expireProposal(proposalId);
        print('Marked proposal $proposalId as expired');
      } catch (e) {
        print('Error marking proposal $proposalId as expired: $e');
      }
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