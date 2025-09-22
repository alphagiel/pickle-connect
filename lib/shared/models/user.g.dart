// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      skillLevel: $enumDecode(_$SkillLevelEnumMap, json['skillLevel']),
      location: json['location'] as String,
      profileImageURL: json['profileImageURL'] as String?,
      matchesPlayed: (json['matchesPlayed'] as num?)?.toInt() ?? 0,
      matchesWon: (json['matchesWon'] as num?)?.toInt() ?? 0,
      matchesLost: (json['matchesLost'] as num?)?.toInt() ?? 0,
      winRate: (json['winRate'] as num?)?.toDouble() ?? 0.0,
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'email': instance.email,
      'skillLevel': _$SkillLevelEnumMap[instance.skillLevel]!,
      'location': instance.location,
      'profileImageURL': instance.profileImageURL,
      'matchesPlayed': instance.matchesPlayed,
      'matchesWon': instance.matchesWon,
      'matchesLost': instance.matchesLost,
      'winRate': instance.winRate,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
    };

const _$SkillLevelEnumMap = {
  SkillLevel.beginner: 'Beginner',
  SkillLevel.intermediate: 'Intermediate',
  SkillLevel.advancedPlus: 'Advanced+',
};
