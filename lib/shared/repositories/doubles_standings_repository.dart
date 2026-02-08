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

  /// Get doubles standings for a specific skill bracket
  Stream<List<Standing>> getStandingsForBracket(SkillBracket bracket) {
    return _firestore
        .collection(_collection)
        .doc(bracket.jsonValue)
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

  /// Get a user's doubles standing in their skill bracket
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

  /// Get a user's rank in doubles standings for their bracket
  Future<int> getUserRank(String userId, SkillBracket bracket) async {
    final standings = await getStandingsForBracket(bracket).first;
    final userIndex = standings.indexWhere((standing) => standing.userId == userId);
    return userIndex == -1 ? 0 : userIndex + 1;
  }
}
