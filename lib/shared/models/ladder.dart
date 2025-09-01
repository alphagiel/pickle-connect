import 'package:freezed_annotation/freezed_annotation.dart';

part 'ladder.freezed.dart';
part 'ladder.g.dart';

@freezed
class LadderEntry with _$LadderEntry {
  const factory LadderEntry({
    required String id,
    required String userId,
    required String seasonId,
    required int rank,
    required double rating,
    required int wins,
    required int losses,
    int? previousRank,
    DateTime? lastUpdated,
  }) = _LadderEntry;

  factory LadderEntry.fromJson(Map<String, dynamic> json) => _$LadderEntryFromJson(json);
}

@freezed
class Season with _$Season {
  const factory Season({
    required String id,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    @Default(SeasonStatus.upcoming) SeasonStatus status,
    String? description,
  }) = _Season;

  factory Season.fromJson(Map<String, dynamic> json) => _$SeasonFromJson(json);
}

@JsonEnum()
enum SeasonStatus {
  @JsonValue('upcoming')
  upcoming,
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
}

@freezed
class Match with _$Match {
  const factory Match({
    required String id,
    required String player1Id,
    required String player2Id,
    required DateTime scheduledAt,
    MatchResult? result,
    String? notes,
    @Default(MatchStatus.scheduled) MatchStatus status,
    DateTime? createdAt,
  }) = _Match;

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
}

@freezed
class MatchResult with _$MatchResult {
  const factory MatchResult({
    required String winnerId,
    required String loserId,
    required List<Set> sets,
    DateTime? completedAt,
  }) = _MatchResult;

  factory MatchResult.fromJson(Map<String, dynamic> json) => _$MatchResultFromJson(json);
}

@freezed
class Set with _$Set {
  const factory Set({
    required int player1Score,
    required int player2Score,
  }) = _Set;

  factory Set.fromJson(Map<String, dynamic> json) => _$SetFromJson(json);
}

@JsonEnum()
enum MatchStatus {
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}