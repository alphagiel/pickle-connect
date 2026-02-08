import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepository();
});

class UsersRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';

  // Get user by ID
  Future<User?> getUserById(String userId) async {
    final doc = await _firestore.collection(_collection).doc(userId).get();
    if (doc.exists) {
      return User.fromJson({
        'userId': doc.id,
        ...doc.data()!,
      });
    }
    return null;
  }

  // Get user stream
  Stream<User?> getUserStream(String userId) {
    return _firestore
        .collection(_collection)
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return User.fromJson({
          'userId': doc.id,
          ...doc.data()!,
        });
      }
      return null;
    });
  }

  // Create or update user
  Future<void> saveUser(User user) async {
    await _firestore
        .collection(_collection)
        .doc(user.userId)
        .set(user.toJson(), SetOptions(merge: true));
  }

  // Update user profile
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _firestore.collection(_collection).doc(userId).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Update user stats (used by Cloud Functions)
  Future<void> updateUserStats({
    required String userId,
    required int matchesPlayed,
    required int matchesWon,
    required int matchesLost,
    required double winRate,
  }) async {
    await _firestore.collection(_collection).doc(userId).update({
      'matchesPlayed': matchesPlayed,
      'matchesWon': matchesWon,
      'matchesLost': matchesLost,
      'winRate': winRate,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get users by skill level
  Stream<List<User>> getUsersBySkillLevel(SkillLevel skillLevel) {
    return _firestore
        .collection(_collection)
        .where('skillLevel', isEqualTo: skillLevel.jsonValue)
        .orderBy('displayName')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => User.fromJson({
                  'userId': doc.id,
                  ...doc.data(),
                }))
            .toList());
  }

  // Search users by name (case-insensitive prefix search)
  Stream<List<User>> searchUsers(String query) {
    if (query.isEmpty) return Stream.value([]);
    // Capitalize first letter to match typical display name casing
    final normalizedQuery = query[0].toUpperCase() + query.substring(1).toLowerCase();
    return _firestore
        .collection(_collection)
        .where('displayName', isGreaterThanOrEqualTo: normalizedQuery)
        .where('displayName', isLessThan: '$normalizedQuery\uf8ff')
        .limit(20)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => User.fromJson({
                  'userId': doc.id,
                  ...doc.data(),
                }))
            .toList());
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    await _firestore.collection(_collection).doc(userId).delete();
  }
}