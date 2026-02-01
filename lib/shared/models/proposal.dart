import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

part 'proposal.freezed.dart';
part 'proposal.g.dart';

// TODO: Set to false for production - disables auto-expiration of past proposals
const bool kDisableAutoExpire = false;

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

  /// Check if proposal should be marked as expired (past due AND no scores)
  bool get shouldExpire {
    if (kDisableAutoExpire) return false; // Testing toggle
    if (!isPastDue) return false;
    if (scores != null) return false; // Has scores = not expired, it's completed
    // Expire only if past due AND no scores recorded
    return (status == ProposalStatus.open || status == ProposalStatus.accepted);
  }

  /// Check if proposal should be marked as completed (has scores)
  bool get shouldComplete {
    return scores != null && status != ProposalStatus.completed;
  }

  /// Check if accepted proposal should auto-complete (past due, no scores entered)
  /// These matches are marked completed but don't count towards rankings
  bool get shouldAutoComplete {
    if (kDisableAutoExpire) return false;
    if (!isPastDue) return false;
    if (scores != null) return false; // Already has scores
    return status == ProposalStatus.accepted;
  }

  /// Check if proposal should be deleted (expired proposals are deleted immediately)
  /// Completed proposals are kept for match history
  bool get shouldDelete {
    return status == ProposalStatus.expired;
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
  const Proposal._();

  const factory Proposal({
    required String proposalId,
    required String creatorId,
    required String creatorName,
    @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToJson)
    required SkillLevel skillLevel,
    /// Bracket for filtering - derived from skillLevel but stored for efficient queries
    @JsonKey(fromJson: _skillBracketFromJson, toJson: _skillBracketToJson)
    required SkillBracket skillBracket,
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

  factory Proposal.fromJson(Map<String, dynamic> json) =>
      _$ProposalFromJson(_migrateProposalJson(json));
}

/// Migrate old proposal JSON format to new format
Map<String, dynamic> _migrateProposalJson(Map<String, dynamic> json) {
  final modifiedJson = Map<String, dynamic>.from(json);

  // Handle migration from old skillLevels array to new skillLevel single value
  if (json.containsKey('skillLevels') && !json.containsKey('skillLevel')) {
    final skillLevels = json['skillLevels'] as List<dynamic>;
    if (skillLevels.isNotEmpty) {
      modifiedJson['skillLevel'] = skillLevels.first;
    }
  }

  // Ensure skillBracket exists (derive from skillLevel if missing)
  if (!json.containsKey('skillBracket') && modifiedJson.containsKey('skillLevel')) {
    final skillLevel = _skillLevelFromJson(modifiedJson['skillLevel']);
    modifiedJson['skillBracket'] = skillLevel.bracket.jsonValue;
  }

  return modifiedJson;
}

/// Map of old bracket names to new specific levels (for migration)
const _oldBracketToLevel = {
  'Beginner': SkillLevel.level2_0,
  'Novice': SkillLevel.level2_5,
  'Intermediate': SkillLevel.level3_5,
  'Advanced': SkillLevel.level4_5,
  'Expert': SkillLevel.level5_0Plus,
  'Advanced+': SkillLevel.level4_5, // Old format
};

// Custom converter for SkillLevel that handles both old and new formats
SkillLevel _skillLevelFromJson(dynamic value) {
  if (value is String) {
    // First try to match new format (1.0, 1.5, etc.)
    for (final level in SkillLevel.values) {
      if (level.jsonValue == value || level.displayName == value) {
        return level;
      }
    }
    // Fall back to old bracket format
    if (_oldBracketToLevel.containsKey(value)) {
      return _oldBracketToLevel[value]!;
    }
  }
  if (value is List && value.isNotEmpty) {
    // Handle old array format
    return _skillLevelFromJson(value.first);
  }
  return SkillLevel.level3_5; // Default to 3.5 (middle of intermediate)
}

String _skillLevelToJson(SkillLevel skillLevel) {
  return skillLevel.jsonValue;
}

// Custom converter for SkillBracket
SkillBracket _skillBracketFromJson(dynamic value) {
  if (value is String) {
    for (final bracket in SkillBracket.values) {
      if (bracket.jsonValue == value || bracket.name == value) {
        return bracket;
      }
    }
    // Handle old "Advanced+" format
    if (value == 'Advanced+') {
      return SkillBracket.advanced;
    }
  }
  return SkillBracket.intermediate; // Default
}

String _skillBracketToJson(SkillBracket bracket) {
  return bracket.jsonValue;
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