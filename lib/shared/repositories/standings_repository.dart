import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/standing.dart';
import '../models/user.dart';

final standingsRepositoryProvider = Provider<StandingsRepository>((ref) {
  return StandingsRepository();
});

class StandingsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'standings';

  // Get standings for specific skill bracket
  Stream<List<Standing>> getStandingsForBracket(SkillBracket bracket) {
    print('[StandingsRepo] Querying standings/${bracket.jsonValue}/players');
    return _firestore
        .collection(_collection)
        .doc(bracket.jsonValue)
        .collection('players')
        .orderBy('winRate', descending: true)
        .orderBy('matchesWon', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
          print('[StandingsRepo] Got ${snapshot.docs.length} docs for ${bracket.jsonValue}');
          return snapshot.docs
              .map((doc) {
                print('[StandingsRepo] Doc: ${doc.id} -> ${doc.data()}');
                return Standing.fromJson({
                  ...doc.data(),
                });
              })
              .toList();
        });
  }

  // Legacy method - redirects to bracket-based
  Stream<List<Standing>> getStandingsForSkillLevel(SkillLevel skillLevel) {
    return getStandingsForBracket(skillLevel.bracket);
  }

  // Get all standings across skill brackets
  Future<Map<SkillBracket, List<Standing>>> getAllStandings() async {
    final results = await Future.wait([
      getStandingsForBracket(SkillBracket.beginner).first,
      getStandingsForBracket(SkillBracket.novice).first,
      getStandingsForBracket(SkillBracket.intermediate).first,
      getStandingsForBracket(SkillBracket.advanced).first,
      getStandingsForBracket(SkillBracket.expert).first,
    ]);

    return {
      SkillBracket.beginner: results[0],
      SkillBracket.novice: results[1],
      SkillBracket.intermediate: results[2],
      SkillBracket.advanced: results[3],
      SkillBracket.expert: results[4],
    };
  }

  // Get user's standing in their skill bracket
  Future<Standing?> getUserStanding(String userId, SkillBracket bracket) async {
    final doc = await _firestore
        .collection(_collection)
        .doc(bracket.jsonValue)
        .collection('players')
        .doc(userId)
        .get();

    if (doc.exists) {
      return Standing.fromJson(doc.data()!);
    }
    return null;
  }

  // Update or create standing (used by Cloud Functions)
  Future<void> updateStanding(Standing standing) async {
    await _firestore
        .collection(_collection)
        .doc(standing.skillLevel.jsonValue)
        .collection('players')
        .doc(standing.userId)
        .set(standing.toJson(), SetOptions(merge: true));
  }

  // Remove user from standings (when skill bracket changes)
  Future<void> removeUserFromStandings(String userId, SkillBracket oldBracket) async {
    await _firestore
        .collection(_collection)
        .doc(oldBracket.jsonValue)
        .collection('players')
        .doc(userId)
        .delete();
  }

  // Get user's rank in their skill bracket
  Future<int> getUserRank(String userId, SkillBracket bracket) async {
    final standings = await getStandingsForBracket(bracket).first;
    final userIndex = standings.indexWhere((standing) => standing.userId == userId);
    return userIndex == -1 ? 0 : userIndex + 1;
  }
}