// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StandingImpl _$$StandingImplFromJson(Map<String, dynamic> json) =>
    _$StandingImpl(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      skillLevel: $enumDecode(_$SkillLevelEnumMap, json['skillLevel']),
      matchesPlayed: (json['matchesPlayed'] as num?)?.toInt() ?? 0,
      matchesWon: (json['matchesWon'] as num?)?.toInt() ?? 0,
      matchesLost: (json['matchesLost'] as num?)?.toInt() ?? 0,
      winRate: (json['winRate'] as num?)?.toDouble() ?? 0.0,
      rankingPoints: (json['rankingPoints'] as num?)?.toInt() ?? 1000,
      lastUpdated: _timestampFromJson(json['lastUpdated']),
    );

Map<String, dynamic> _$$StandingImplToJson(_$StandingImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'skillLevel': _$SkillLevelEnumMap[instance.skillLevel]!,
      'matchesPlayed': instance.matchesPlayed,
      'matchesWon': instance.matchesWon,
      'matchesLost': instance.matchesLost,
      'winRate': instance.winRate,
      'rankingPoints': instance.rankingPoints,
      'lastUpdated': _timestampToJson(instance.lastUpdated),
    };

const _$SkillLevelEnumMap = {
  SkillLevel.beginner: 'Beginner',
  SkillLevel.intermediate: 'Intermediate',
  SkillLevel.advancedPlus: 'Advanced+',
};
