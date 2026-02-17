import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'zone.freezed.dart';
part 'zone.g.dart';

@freezed
class AppZone with _$AppZone {
  const factory AppZone({
    required String id,
    required String displayName,
    required String description,
    @Default([]) List<String> cities,
    @Default('') String region,
    @Default(true) bool active,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime createdAt,
  }) = _AppZone;

  factory AppZone.fromJson(Map<String, dynamic> json) =>
      _$AppZoneFromJson(json);
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
