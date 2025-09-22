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

  // Get standings for specific skill level
  Stream<List<Standing>> getStandingsForSkillLevel(SkillLevel skillLevel) {
    return _firestore
        .collection(_collection)
        .doc(skillLevel.displayName)
        .collection('players')
        .orderBy('winRate', descending: true)
        .orderBy('matchesWon', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Standing.fromJson({
                  ...doc.data(),
                }))
            .toList());
  }

  // Get all standings across skill levels
  Future<Map<SkillLevel, List<Standing>>> getAllStandings() async {
    final results = await Future.wait([
      getStandingsForSkillLevel(SkillLevel.beginner).first,
      getStandingsForSkillLevel(SkillLevel.intermediate).first,
      getStandingsForSkillLevel(SkillLevel.advancedPlus).first,
    ]);
    
    return {
      SkillLevel.beginner: results[0],
      SkillLevel.intermediate: results[1],
      SkillLevel.advancedPlus: results[2],
    };
  }

  // Get user's standing in their skill level
  Future<Standing?> getUserStanding(String userId, SkillLevel skillLevel) async {
    final doc = await _firestore
        .collection(_collection)
        .doc(skillLevel.displayName)
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
        .doc(standing.skillLevel.displayName)
        .collection('players')
        .doc(standing.userId)
        .set(standing.toJson(), SetOptions(merge: true));
  }

  // Remove user from standings (when skill level changes)
  Future<void> removeUserFromStandings(String userId, SkillLevel oldSkillLevel) async {
    await _firestore
        .collection(_collection)
        .doc(oldSkillLevel.displayName)
        .collection('players')
        .doc(userId)
        .delete();
  }

  // Get user's rank in their skill level
  Future<int> getUserRank(String userId, SkillLevel skillLevel) async {
    final standings = await getStandingsForSkillLevel(skillLevel).first;
    final userIndex = standings.indexWhere((standing) => standing.userId == userId);
    return userIndex == -1 ? 0 : userIndex + 1;
  }
}