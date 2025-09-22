import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/standing.dart';
import '../models/user.dart';
import '../repositories/standings_repository.dart';

// Provider for standings filtered by skill level
final standingsProvider = StreamProvider.family<List<Standing>, SkillLevel>((ref, skillLevel) {
  final repository = ref.watch(standingsRepositoryProvider);
  return repository.getStandingsForSkillLevel(skillLevel);
});

// Provider for all standings across skill levels
final allStandingsProvider = FutureProvider<Map<SkillLevel, List<Standing>>>((ref) {
  final repository = ref.watch(standingsRepositoryProvider);
  return repository.getAllStandings();
});

// Provider for user's standing
final userStandingProvider = FutureProvider.family<Standing?, UserStandingParams>((ref, params) {
  final repository = ref.watch(standingsRepositoryProvider);
  return repository.getUserStanding(params.userId, params.skillLevel);
});

// Provider for user's rank
final userRankProvider = FutureProvider.family<int, UserStandingParams>((ref, params) {
  final repository = ref.watch(standingsRepositoryProvider);
  return repository.getUserRank(params.userId, params.skillLevel);
});

// Helper class for user standing parameters
class UserStandingParams {
  final String userId;
  final SkillLevel skillLevel;

  UserStandingParams({required this.userId, required this.skillLevel});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStandingParams &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          skillLevel == other.skillLevel;

  @override
  int get hashCode => userId.hashCode ^ skillLevel.hashCode;
}