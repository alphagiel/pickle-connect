import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/standing.dart';
import '../models/user.dart';

final doublesStandingsRepositoryProvider = Provider<DoublesStandingsRepository>((ref) {
  return DoublesStandingsRepository();
});

class DoublesStandingsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'doubles_standings';

  /// Build the document ID for zone-scoped doubles standings
  String _docId(String zone, SkillBracket bracket) => '${zone}_${bracket.jsonValue}';

  /// Get doubles standings for a specific skill bracket and zone
  Stream<List<Standing>> getStandingsForBracket(SkillBracket bracket, {required String zone}) {
    final docId = _docId(zone, bracket);
    return _firestore
        .collection(_collection)
        .doc(docId)
        .collection('players')
        .orderBy('winRate', descending: true)
        .orderBy('matchesWon', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Standing.fromJson(doc.data());
          }).toList();
        });
  }

  /// Get a user's doubles standing in their skill bracket and zone
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

  /// Anonymize a deleted user's name in doubles standings (preserves ladder history)
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

  /// Get a user's rank in doubles standings for their bracket and zone
  Future<int> getUserRank(String userId, SkillBracket bracket, {required String zone}) async {
    final standings = await getStandingsForBracket(bracket, zone: zone).first;
    final userIndex = standings.indexWhere((standing) => standing.userId == userId);
    return userIndex == -1 ? 0 : userIndex + 1;
  }
}
