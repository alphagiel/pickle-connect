import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

part 'standing.freezed.dart';
part 'standing.g.dart';

@freezed
class Standing with _$Standing {
  const factory Standing({
    required String userId,
    required String displayName,
    required SkillLevel skillLevel,
    @Default(0) int matchesPlayed,
    @Default(0) int matchesWon,
    @Default(0) int matchesLost,
    @Default(0.0) double winRate,
    @Default(1000) int rankingPoints,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime lastUpdated,
  }) = _Standing;

  factory Standing.fromJson(Map<String, dynamic> json) => _$StandingFromJson(json);
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
  return Timestamp.fromDate(dateTime);
}