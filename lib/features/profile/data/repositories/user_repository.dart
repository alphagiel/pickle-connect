import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/user.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(FirebaseFirestore.instance);
});

class UserRepository {
  final FirebaseFirestore _firestore;
  static const String _collection = 'users';

  UserRepository(this._firestore);

  Future<void> createUser(User user) async {
    try {
      await _firestore.collection(_collection).doc(user.id).set(user.toJson());
    } catch (e) {
      throw UserRepositoryException('Failed to create user: $e');
    }
  }

  Future<User?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(userId).get();
      if (doc.exists) {
        return User.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw UserRepositoryException('Failed to get user: $e');
    }
  }

  Stream<User?> getUserStream(String userId) {
    return _firestore
        .collection(_collection)
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? User.fromJson(doc.data()!) : null);
  }

  Future<void> updateUser(User user) async {
    try {
      await _firestore.collection(_collection).doc(user.id).update(user.toJson());
    } catch (e) {
      throw UserRepositoryException('Failed to update user: $e');
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => User.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw UserRepositoryException('Failed to get all users: $e');
    }
  }

  Stream<List<User>> getUsersBySkillDivision(SkillDivision skillDivision) {
    return _firestore
        .collection(_collection)
        .where('skillDivision', isEqualTo: skillDivision.name)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => User.fromJson(doc.data()))
            .toList());
  }

  Stream<List<User>> getAllActiveUsersStream() {
    return _firestore
        .collection(_collection)
        .where('isActive', isEqualTo: true)
        .orderBy('fullName')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => User.fromJson(doc.data()))
            .toList());
  }

  Future<List<User>> searchUsers({
    String? nameQuery,
    SkillDivision? skillDivision,
    String? ustaRating,
  }) async {
    try {
      Query query = _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true);

      if (skillDivision != null) {
        query = query.where('skillDivision', isEqualTo: skillDivision.name);
      }

      if (ustaRating != null) {
        query = query.where('ustaRating', isEqualTo: ustaRating);
      }

      final querySnapshot = await query.get();
      List<User> users = querySnapshot.docs
          .map((doc) => User.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      if (nameQuery != null && nameQuery.isNotEmpty) {
        users = users
            .where((user) => user.fullName
                .toLowerCase()
                .contains(nameQuery.toLowerCase()))
            .toList();
      }

      return users;
    } catch (e) {
      throw UserRepositoryException('Failed to search users: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(_collection).doc(userId).delete();
    } catch (e) {
      throw UserRepositoryException('Failed to delete user: $e');
    }
  }

  Future<void> deactivateUser(String userId) async {
    try {
      await _firestore.collection(_collection).doc(userId).update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw UserRepositoryException('Failed to deactivate user: $e');
    }
  }
}

class UserRepositoryException implements Exception {
  final String message;
  UserRepositoryException(this.message);
  
  @override
  String toString() => 'UserRepositoryException: $message';
}