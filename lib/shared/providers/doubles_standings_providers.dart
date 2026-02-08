import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/standing.dart';
import '../models/user.dart';
import '../repositories/doubles_standings_repository.dart';
import '../providers/standings_providers.dart';
import '../../core/utils/stream_retry.dart';

/// Doubles standings for a skill bracket
final doublesStandingsProvider = StreamProvider.family<List<Standing>, SkillBracket>((ref, bracket) {
  final repository = ref.watch(doublesStandingsRepositoryProvider);
  return retryStream(() => repository.getStandingsForBracket(bracket));
});

/// User's doubles standing in their bracket
final doublesUserStandingProvider = FutureProvider.family<Standing?, UserStandingParams>((ref, params) {
  final repository = ref.watch(doublesStandingsRepositoryProvider);
  return repository.getUserStanding(params.userId, params.bracket);
});

/// User's doubles rank in their bracket
final doublesUserRankProvider = FutureProvider.family<int, UserStandingParams>((ref, params) {
  final repository = ref.watch(doublesStandingsRepositoryProvider);
  return repository.getUserRank(params.userId, params.bracket);
});
