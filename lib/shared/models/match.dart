import 'package:freezed_annotation/freezed_annotation.dart';

part 'match.freezed.dart';
part 'match.g.dart';

@freezed
class Match with _$Match {
  const factory Match({
    required String id,
    required String player1Id,
    required String player2Id,
    required DateTime scheduledAt,
    @Default(MatchStatus.proposed) MatchStatus status,
    String? player1Name,
    String? player2Name,
    String? courtId,
    String? seasonId,
    String? notes,
    MatchResult? result,
    DateTime? completedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<String> participants,
  }) = _Match;

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
}

@freezed
class MatchResult with _$MatchResult {
  const factory MatchResult({
    required String winnerId,
    required String loserId,
    required List<Set> sets,
    @Default(0) int player1Games,
    @Default(0) int player2Games,
    String? notes,
    @Default(MatchFormat.bestOfThree) MatchFormat format,
  }) = _MatchResult;

  factory MatchResult.fromJson(Map<String, dynamic> json) => _$MatchResultFromJson(json);
}

@freezed
class Set with _$Set {
  const factory Set({
    @Default(0) int player1Games,
    @Default(0) int player2Games,
    Tiebreak? tiebreak,
    @Default(false) bool isCompleted,
  }) = _Set;

  factory Set.fromJson(Map<String, dynamic> json) => _$SetFromJson(json);
}

@freezed
class Tiebreak with _$Tiebreak {
  const factory Tiebreak({
    @Default(0) int player1Points,
    @Default(0) int player2Points,
  }) = _Tiebreak;

  factory Tiebreak.fromJson(Map<String, dynamic> json) => _$TiebreakFromJson(json);
}

@JsonEnum()
enum MatchStatus {
  @JsonValue('proposed')
  proposed,
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

@JsonEnum()
enum MatchFormat {
  @JsonValue('best_of_three')
  bestOfThree,
  @JsonValue('best_of_five')
  bestOfFive,
  @JsonValue('pro_set')
  proSet,
  @JsonValue('single_set')
  singleSet,
}