import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/standing.dart';
import '../models/ladder.dart';
import '../models/user.dart';
import '../repositories/standings_repository.dart';
import '../../core/utils/stream_retry.dart';

// Provider for the current active season
final activeSeasonProvider = StreamProvider<Season?>((ref) {
  return retryStream(
    () => FirebaseFirestore.instance
        .collection('seasons')
        .where('status', isEqualTo: 'active')
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return Season.fromJson(snapshot.docs.first.data());
        }),
  );
});

/// Parameters for filtering standings by bracket and zone
class StandingsFilterParams {
  final SkillBracket bracket;
  final String zone;

  StandingsFilterParams({required this.bracket, required this.zone});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StandingsFilterParams &&
          runtimeType == other.runtimeType &&
          bracket == other.bracket &&
          zone == other.zone;

  @override
  int get hashCode => bracket.hashCode ^ zone.hashCode;
}

// Provider for standings filtered by skill bracket and zone (with retry for transient auth errors)
final standingsProvider = StreamProvider.family<List<Standing>, StandingsFilterParams>((ref, params) {
  final repository = ref.watch(standingsRepositoryProvider);
  return retryStream(() => repository.getStandingsForBracket(params.bracket, zone: params.zone));
});

// Provider for user's standing
final userStandingProvider = FutureProvider.family<Standing?, UserStandingParams>((ref, params) {
  final repository = ref.watch(standingsRepositoryProvider);
  return repository.getUserStanding(params.userId, params.bracket, zone: params.zone);
});

// Provider for user's rank
final userRankProvider = FutureProvider.family<int, UserStandingParams>((ref, params) {
  final repository = ref.watch(standingsRepositoryProvider);
  return repository.getUserRank(params.userId, params.bracket, zone: params.zone);
});

// Helper class for user standing parameters
class UserStandingParams {
  final String userId;
  final SkillBracket bracket;
  final String zone;

  UserStandingParams({required this.userId, required this.bracket, required this.zone});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStandingParams &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          bracket == other.bracket &&
          zone == other.zone;

  @override
  int get hashCode => userId.hashCode ^ bracket.hashCode ^ zone.hashCode;
}
