import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/standing.dart';
import '../models/user.dart';
import '../repositories/doubles_standings_repository.dart';
import '../providers/standings_providers.dart';
import '../../core/utils/stream_retry.dart';

/// Doubles standings for a skill bracket and zone
final doublesStandingsProvider = StreamProvider.family<List<Standing>, StandingsFilterParams>((ref, params) {
  final repository = ref.watch(doublesStandingsRepositoryProvider);
  return retryStream(() => repository.getStandingsForBracket(params.bracket, zone: params.zone));
});

/// User's doubles standing in their bracket and zone
final doublesUserStandingProvider = FutureProvider.family<Standing?, UserStandingParams>((ref, params) {
  final repository = ref.watch(doublesStandingsRepositoryProvider);
  return repository.getUserStanding(params.userId, params.bracket, zone: params.zone);
});

/// User's doubles rank in their bracket and zone
final doublesUserRankProvider = FutureProvider.family<int, UserStandingParams>((ref, params) {
  final repository = ref.watch(doublesStandingsRepositoryProvider);
  return repository.getUserRank(params.userId, params.bracket, zone: params.zone);
});
