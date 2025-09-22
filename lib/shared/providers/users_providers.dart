import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../repositories/users_repository.dart';

// Provider for user by ID
final userProvider = StreamProvider.family<User?, String>((ref, userId) {
  final repository = ref.watch(usersRepositoryProvider);
  return repository.getUserStream(userId);
});

// Provider for users by skill level
final usersBySkillLevelProvider = StreamProvider.family<List<User>, SkillLevel>((ref, skillLevel) {
  final repository = ref.watch(usersRepositoryProvider);
  return repository.getUsersBySkillLevel(skillLevel);
});

// Provider for searching users
final searchUsersProvider = StreamProvider.family<List<User>, String>((ref, query) {
  if (query.isEmpty) {
    return Stream.value(<User>[]);
  }
  final repository = ref.watch(usersRepositoryProvider);
  return repository.searchUsers(query);
});

// Notifier for user actions
final userActionsProvider = Provider<UserActions>((ref) {
  return UserActions(ref.read(usersRepositoryProvider));
});

class UserActions {
  final UsersRepository _repository;

  UserActions(this._repository);

  Future<User?> getUserById(String userId) async {
    return await _repository.getUserById(userId);
  }

  Future<void> saveUser(User user) async {
    await _repository.saveUser(user);
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _repository.updateUser(userId, data);
  }

  Future<void> updateUserStats({
    required String userId,
    required int matchesPlayed,
    required int matchesWon,
    required int matchesLost,
    required double winRate,
  }) async {
    await _repository.updateUserStats(
      userId: userId,
      matchesPlayed: matchesPlayed,
      matchesWon: matchesWon,
      matchesLost: matchesLost,
      winRate: winRate,
    );
  }

  Future<void> deleteUser(String userId) async {
    await _repository.deleteUser(userId);
  }
}