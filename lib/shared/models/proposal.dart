import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

part 'proposal.freezed.dart';
part 'proposal.g.dart';

// TODO: Set to false for production - disables auto-expiration of past proposals
const bool kDisableAutoExpire = true;

enum ProposalStatus {
  @JsonValue('open')
  open,
  @JsonValue('accepted')
  accepted,
  @JsonValue('expired')
  expired,
  @JsonValue('completed')
  completed,
  @JsonValue('canceled')
  canceled,
}

extension ProposalStatusExtension on ProposalStatus {
  String get displayName {
    switch (this) {
      case ProposalStatus.open:
        return 'Open';
      case ProposalStatus.accepted:
        return 'Accepted';
      case ProposalStatus.expired:
        return 'Expired';
      case ProposalStatus.completed:
        return 'Completed';
      case ProposalStatus.canceled:
        return 'Canceled';
    }
  }
}

extension ProposalLifecycle on Proposal {
  /// Check if proposal is past its scheduled date/time
  bool get isPastDue {
    return DateTime.now().isAfter(dateTime);
  }

  /// Check if proposal should be marked as expired (past due immediately)
  bool get shouldExpire {
    if (kDisableAutoExpire) return false; // Testing toggle
    if (!isPastDue) return false;
    // Expire immediately when past due (not after 1 day)
    return (status == ProposalStatus.open || status == ProposalStatus.accepted);
  }

  /// Check if proposal should be auto-completed (2 days past due)
  bool get shouldAutoComplete {
    if (!isPastDue) return false;
    final daysPastDue = DateTime.now().difference(dateTime).inDays;
    return daysPastDue >= 2 && status == ProposalStatus.expired;
  }

  /// Check if proposal should be deleted (7 days past due)
  bool get shouldDelete {
    if (!isPastDue) return false;
    final daysPastDue = DateTime.now().difference(dateTime).inDays;
    return daysPastDue >= 7 && status == ProposalStatus.completed;
  }

  /// Get the number of days past the scheduled date
  int get daysPastDue {
    if (!isPastDue) return 0;
    return DateTime.now().difference(dateTime).inDays;
  }
}

@freezed
class AcceptedBy with _$AcceptedBy {
  const factory AcceptedBy({
    required String userId,
    required String displayName,
  }) = _AcceptedBy;

  factory AcceptedBy.fromJson(Map<String, dynamic> json) => _$AcceptedByFromJson(json);
}

/// Represents a single game score in a pickleball match
@freezed
class GameScore with _$GameScore {
  const factory GameScore({
    required int creatorScore,
    required int opponentScore,
  }) = _GameScore;

  factory GameScore.fromJson(Map<String, dynamic> json) => _$GameScoreFromJson(json);
}

/// Represents the full match scores (best of 3 games)
@freezed
class Scores with _$Scores {
  const Scores._();

  const factory Scores({
    required List<GameScore> games, // List of game scores (typically 2-3 games)
  }) = _Scores;

  factory Scores.fromJson(Map<String, dynamic> json) => _$ScoresFromJson(json);

  /// Get total games won by creator
  int get creatorGamesWon => games.where((g) => g.creatorScore > g.opponentScore).length;

  /// Get total games won by opponent
  int get opponentGamesWon => games.where((g) => g.opponentScore > g.creatorScore).length;

  /// Check if match is complete (someone won 2 games in best of 3)
  bool get isMatchComplete => creatorGamesWon >= 2 || opponentGamesWon >= 2;

  /// Get the match winner: 'creator', 'opponent', or null if not complete
  String? get winner {
    if (creatorGamesWon >= 2) return 'creator';
    if (opponentGamesWon >= 2) return 'opponent';
    return null;
  }

  /// Display string like "2-1" for games won
  String get matchScore => '$creatorGamesWon-$opponentGamesWon';
}

@freezed
class Proposal with _$Proposal {
  const factory Proposal({
    required String proposalId,
    required String creatorId,
    required String creatorName,
    required List<SkillLevel> skillLevels,
    required String location,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime dateTime,
    required ProposalStatus status,
    AcceptedBy? acceptedBy,
    Scores? scores,
    @Default([]) List<String> scoreConfirmedBy,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime updatedAt,
  }) = _Proposal;

  factory Proposal.fromJson(Map<String, dynamic> json) => _$ProposalFromJson(json);
}

DateTime _timestampFromJson(dynamic timestamp) {
  if (timestamp is Timestamp) {
    return timestamp.toDate();
  }
  if (timestamp is String) {
    return DateTime.parse(timestamp);
  }
  return DateTime.now();
}

dynamic _timestampToJson(DateTime dateTime) {
  return dateTime.toIso8601String();
}