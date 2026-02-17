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

  /// Build the document ID for zone-scoped standings
  String _docId(String zone, SkillBracket bracket) => '${zone}_${bracket.jsonValue}';

  // Get standings for specific skill bracket and zone
  Stream<List<Standing>> getStandingsForBracket(SkillBracket bracket, {required String zone}) {
    final docId = _docId(zone, bracket);
    print('[StandingsRepo] Querying standings/$docId/players');
    return _firestore
        .collection(_collection)
        .doc(docId)
        .collection('players')
        .orderBy('winRate', descending: true)
        .orderBy('matchesWon', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
          print('[StandingsRepo] Got ${snapshot.docs.length} docs for $docId');
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

  // Get all standings across skill brackets for a zone
  Future<Map<SkillBracket, List<Standing>>> getAllStandings({required String zone}) async {
    final results = await Future.wait([
      getStandingsForBracket(SkillBracket.beginner, zone: zone).first,
      getStandingsForBracket(SkillBracket.novice, zone: zone).first,
      getStandingsForBracket(SkillBracket.intermediate, zone: zone).first,
      getStandingsForBracket(SkillBracket.advanced, zone: zone).first,
      getStandingsForBracket(SkillBracket.expert, zone: zone).first,
    ]);

    return {
      SkillBracket.beginner: results[0],
      SkillBracket.novice: results[1],
      SkillBracket.intermediate: results[2],
      SkillBracket.advanced: results[3],
      SkillBracket.expert: results[4],
    };
  }

  // Get user's standing in their skill bracket and zone
  Future<Standing?> getUserStanding(String userId, SkillBracket bracket, {required String zone}) async {
    final docId = _docId(zone, bracket);
    final doc = await _firestore
        .collection(_collection)
        .doc(docId)
        .collection('players')
        .doc(userId)
        .get();

    if (doc.exists) {
      return Standing.fromJson(doc.data()!);
    }
    return null;
  }

  // Remove user from standings (when zone or skill bracket changes)
  Future<void> removeUserFromStandings(String userId, SkillBracket oldBracket, {required String zone}) async {
    final docId = _docId(zone, oldBracket);
    await _firestore
        .collection(_collection)
        .doc(docId)
        .collection('players')
        .doc(userId)
        .delete();
  }

  // Anonymize a deleted user's name in standings (preserves ladder history)
  Future<void> anonymizeUserInStandings(String userId, SkillBracket bracket, {required String zone}) async {
    final docId = _docId(zone, bracket);
    final doc = _firestore
        .collection(_collection)
        .doc(docId)
        .collection('players')
        .doc(userId);

    final snapshot = await doc.get();
    if (snapshot.exists) {
      await doc.update({'displayName': 'Former Player'});
    }
  }

  // Get user's rank in their skill bracket and zone
  Future<int> getUserRank(String userId, SkillBracket bracket, {required String zone}) async {
    final standings = await getStandingsForBracket(bracket, zone: zone).first;
    final userIndex = standings.indexWhere((standing) => standing.userId == userId);
    return userIndex == -1 ? 0 : userIndex + 1;
  }
}