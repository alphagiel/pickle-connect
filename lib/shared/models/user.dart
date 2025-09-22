import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum SkillLevel {
  @JsonValue('Beginner')
  beginner,
  @JsonValue('Intermediate')
  intermediate,
  @JsonValue('Advanced+')
  advancedPlus,
}

extension SkillLevelExtension on SkillLevel {
  String get displayName {
    switch (this) {
      case SkillLevel.beginner:
        return 'Beginner';
      case SkillLevel.intermediate:
        return 'Intermediate';
      case SkillLevel.advancedPlus:
        return 'Advanced+';
    }
  }
}

@freezed
class User with _$User {
  const factory User({
    required String userId,
    required String displayName,
    required String email,
    required SkillLevel skillLevel,
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
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
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