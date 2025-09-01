import 'package:freezed_annotation/freezed_annotation.dart';

part 'tournament.freezed.dart';
part 'tournament.g.dart';

@freezed
class Tournament with _$Tournament {
  const factory Tournament({
    required String id,
    required String name,
    required String description,
    required TournamentFormat format,
    required DateTime registrationStart,
    required DateTime registrationEnd,
    required DateTime startDate,
    required DateTime endDate,
    required int maxParticipants,
    @Default(0) int currentParticipants,
    @Default(TournamentStatus.upcoming) TournamentStatus status,
    List<String>? eligibleDivisions,
    double? entryFee,
    String? prizeDescription,
    DateTime? createdAt,
  }) = _Tournament;

  factory Tournament.fromJson(Map<String, dynamic> json) => _$TournamentFromJson(json);
}

@JsonEnum()
enum TournamentFormat {
  @JsonValue('single_elimination')
  singleElimination,
  @JsonValue('double_elimination')
  doubleElimination,
  @JsonValue('round_robin')
  roundRobin,
  @JsonValue('top_eight_elimination')
  topEightElimination,
}

@JsonEnum()
enum TournamentStatus {
  @JsonValue('upcoming')
  upcoming,
  @JsonValue('registration_open')
  registrationOpen,
  @JsonValue('registration_closed')
  registrationClosed,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

@freezed
class TournamentParticipant with _$TournamentParticipant {
  const factory TournamentParticipant({
    required String id,
    required String tournamentId,
    required String userId,
    required DateTime registeredAt,
    @Default(ParticipantStatus.registered) ParticipantStatus status,
    int? seed,
  }) = _TournamentParticipant;

  factory TournamentParticipant.fromJson(Map<String, dynamic> json) => _$TournamentParticipantFromJson(json);
}

@JsonEnum()
enum ParticipantStatus {
  @JsonValue('registered')
  registered,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('eliminated')
  eliminated,
  @JsonValue('withdrawn')
  withdrawn,
}

@freezed
class TournamentMatch with _$TournamentMatch {
  const factory TournamentMatch({
    required String id,
    required String tournamentId,
    required String participant1Id,
    required String participant2Id,
    required int round,
    DateTime? scheduledAt,
    String? courtId,
    TournamentMatchResult? result,
    @Default(TournamentMatchStatus.pending) TournamentMatchStatus status,
  }) = _TournamentMatch;

  factory TournamentMatch.fromJson(Map<String, dynamic> json) => _$TournamentMatchFromJson(json);
}

@freezed
class TournamentMatchResult with _$TournamentMatchResult {
  const factory TournamentMatchResult({
    required String winnerId,
    required String loserId,
    required List<Set> sets,
    DateTime? completedAt,
  }) = _TournamentMatchResult;

  factory TournamentMatchResult.fromJson(Map<String, dynamic> json) => _$TournamentMatchResultFromJson(json);
}

@JsonEnum()
enum TournamentMatchStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}