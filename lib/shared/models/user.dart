import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Email notification preferences for users
@freezed
class EmailNotificationPreferences with _$EmailNotificationPreferences {
  const factory EmailNotificationPreferences({
    @Default(true) bool welcome,
    @Default(true) bool newProposals,
    @Default(true) bool proposalAccepted,
    @Default(true) bool proposalUnaccepted,
    @Default(true) bool matchResults,
  }) = _EmailNotificationPreferences;

  factory EmailNotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$EmailNotificationPreferencesFromJson(json);
}

/// Skill brackets for grouping/filtering (interactibility)
enum SkillBracket {
  @JsonValue('Beginner')
  beginner, // 1.0-2.0
  @JsonValue('Novice')
  novice, // 2.5
  @JsonValue('Intermediate')
  intermediate, // 3.0-3.5
  @JsonValue('Advanced')
  advanced, // 4.0-4.5
  @JsonValue('Expert')
  expert, // 5.0+
}

extension SkillBracketExtension on SkillBracket {
  String get displayName {
    switch (this) {
      case SkillBracket.beginner:
        return 'Beginner (1.0-2.0)';
      case SkillBracket.novice:
        return 'Novice (2.5)';
      case SkillBracket.intermediate:
        return 'Intermediate (3.0-3.5)';
      case SkillBracket.advanced:
        return 'Advanced (4.0-4.5)';
      case SkillBracket.expert:
        return 'Expert (5.0+)';
    }
  }

  String get jsonValue {
    switch (this) {
      case SkillBracket.beginner:
        return 'Beginner';
      case SkillBracket.novice:
        return 'Novice';
      case SkillBracket.intermediate:
        return 'Intermediate';
      case SkillBracket.advanced:
        return 'Advanced';
      case SkillBracket.expert:
        return 'Expert';
    }
  }
}

/// Specific skill ratings (what users select)
enum SkillLevel {
  @JsonValue('1.0')
  level1_0,
  @JsonValue('1.5')
  level1_5,
  @JsonValue('2.0')
  level2_0,
  @JsonValue('2.5')
  level2_5,
  @JsonValue('3.0')
  level3_0,
  @JsonValue('3.5')
  level3_5,
  @JsonValue('4.0')
  level4_0,
  @JsonValue('4.5')
  level4_5,
  @JsonValue('5.0+')
  level5_0Plus,
}

extension SkillLevelExtension on SkillLevel {
  /// The bracket this rating belongs to (for filtering/interactibility)
  SkillBracket get bracket {
    switch (this) {
      case SkillLevel.level1_0:
      case SkillLevel.level1_5:
      case SkillLevel.level2_0:
        return SkillBracket.beginner;
      case SkillLevel.level2_5:
        return SkillBracket.novice;
      case SkillLevel.level3_0:
      case SkillLevel.level3_5:
        return SkillBracket.intermediate;
      case SkillLevel.level4_0:
      case SkillLevel.level4_5:
        return SkillBracket.advanced;
      case SkillLevel.level5_0Plus:
        return SkillBracket.expert;
    }
  }

  /// Display name showing rating (e.g., "3.5")
  String get displayName {
    switch (this) {
      case SkillLevel.level1_0:
        return '1.0';
      case SkillLevel.level1_5:
        return '1.5';
      case SkillLevel.level2_0:
        return '2.0';
      case SkillLevel.level2_5:
        return '2.5';
      case SkillLevel.level3_0:
        return '3.0';
      case SkillLevel.level3_5:
        return '3.5';
      case SkillLevel.level4_0:
        return '4.0';
      case SkillLevel.level4_5:
        return '4.5';
      case SkillLevel.level5_0Plus:
        return '5.0+';
    }
  }

  /// Full display with bracket name (e.g., "3.5 - Intermediate")
  String get fullDisplayName {
    switch (this) {
      case SkillLevel.level1_0:
        return '1.0 - Beginner';
      case SkillLevel.level1_5:
        return '1.5 - Beginner';
      case SkillLevel.level2_0:
        return '2.0 - Beginner';
      case SkillLevel.level2_5:
        return '2.5 - Novice';
      case SkillLevel.level3_0:
        return '3.0 - Intermediate';
      case SkillLevel.level3_5:
        return '3.5 - Intermediate';
      case SkillLevel.level4_0:
        return '4.0 - Advanced';
      case SkillLevel.level4_5:
        return '4.5 - Advanced';
      case SkillLevel.level5_0Plus:
        return '5.0+ - Expert';
    }
  }

  /// Description for signup dropdown
  String get description {
    switch (this) {
      case SkillLevel.level1_0:
        return 'Brand new to pickleball';
      case SkillLevel.level1_5:
        return 'Learning basic rules and strokes';
      case SkillLevel.level2_0:
        return 'Can sustain short rallies';
      case SkillLevel.level2_5:
        return 'Knows two-bounce rule, developing consistency';
      case SkillLevel.level3_0:
        return 'Consistent serves, learning strategy';
      case SkillLevel.level3_5:
        return 'Developing dinks, understanding positioning';
      case SkillLevel.level4_0:
        return 'Strong shot accuracy, strategic play';
      case SkillLevel.level4_5:
        return 'Advanced strategy, minimal unforced errors';
      case SkillLevel.level5_0Plus:
        return 'Tournament-level mastery';
    }
  }

  /// JSON value for Firestore
  String get jsonValue {
    switch (this) {
      case SkillLevel.level1_0:
        return '1.0';
      case SkillLevel.level1_5:
        return '1.5';
      case SkillLevel.level2_0:
        return '2.0';
      case SkillLevel.level2_5:
        return '2.5';
      case SkillLevel.level3_0:
        return '3.0';
      case SkillLevel.level3_5:
        return '3.5';
      case SkillLevel.level4_0:
        return '4.0';
      case SkillLevel.level4_5:
        return '4.5';
      case SkillLevel.level5_0Plus:
        return '5.0+';
    }
  }

  /// For backward compatibility - returns bracket's jsonValue
  String get bracketJsonValue => bracket.jsonValue;
}

@freezed
class User with _$User {
  const factory User({
    required String userId,
    required String displayName,
    required String email,
    required SkillLevel skillLevel,
    /// Skill bracket derived from skillLevel (stored for efficient Firestore queries)
    @JsonKey(fromJson: _skillBracketFromJson, toJson: _skillBracketToJson)
    required SkillBracket skillBracket,
    required String location,
    String? profileImageURL,
    @Default(0) int matchesPlayed,
    @Default(0) int matchesWon,
    @Default(0) int matchesLost,
    @Default(0.0) double winRate,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime updatedAt,
    EmailNotificationPreferences? emailNotifications,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(_migrateUserJson(json));
}

/// Migrate old user JSON to include skillBracket
Map<String, dynamic> _migrateUserJson(Map<String, dynamic> json) {
  if (!json.containsKey('skillBracket') && json.containsKey('skillLevel')) {
    final modifiedJson = Map<String, dynamic>.from(json);
    final skillLevelStr = json['skillLevel'] as String?;
    if (skillLevelStr != null) {
      // Derive bracket from skill level
      final bracket = _bracketFromSkillLevelString(skillLevelStr);
      modifiedJson['skillBracket'] = bracket;
    }
    return modifiedJson;
  }
  return json;
}

String _bracketFromSkillLevelString(String skillLevelStr) {
  // Handle new format (1.0, 1.5, etc.)
  switch (skillLevelStr) {
    case '1.0':
    case '1.5':
    case '2.0':
      return 'Beginner';
    case '2.5':
      return 'Novice';
    case '3.0':
    case '3.5':
      return 'Intermediate';
    case '4.0':
    case '4.5':
      return 'Advanced';
    case '5.0+':
      return 'Expert';
    // Handle old format
    case 'Beginner':
      return 'Beginner';
    case 'Novice':
      return 'Novice';
    case 'Intermediate':
      return 'Intermediate';
    case 'Advanced':
    case 'Advanced+':
      return 'Advanced';
    case 'Expert':
      return 'Expert';
    default:
      return 'Intermediate';
  }
}

SkillBracket _skillBracketFromJson(dynamic value) {
  if (value is String) {
    for (final bracket in SkillBracket.values) {
      if (bracket.jsonValue == value || bracket.name == value) {
        return bracket;
      }
    }
  }
  return SkillBracket.intermediate;
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
