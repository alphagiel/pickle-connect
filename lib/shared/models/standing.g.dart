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
      streak: (json['streak'] as num?)?.toInt() ?? 0,
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
      'streak': instance.streak,
      'lastUpdated': _timestampToJson(instance.lastUpdated),
    };

const _$SkillLevelEnumMap = {
  SkillLevel.level1_0: '1.0',
  SkillLevel.level1_5: '1.5',
  SkillLevel.level2_0: '2.0',
  SkillLevel.level2_5: '2.5',
  SkillLevel.level3_0: '3.0',
  SkillLevel.level3_5: '3.5',
  SkillLevel.level4_0: '4.0',
  SkillLevel.level4_5: '4.5',
  SkillLevel.level5_0Plus: '5.0+',
};
