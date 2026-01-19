// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proposal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AcceptedByImpl _$$AcceptedByImplFromJson(Map<String, dynamic> json) =>
    _$AcceptedByImpl(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
    );

Map<String, dynamic> _$$AcceptedByImplToJson(_$AcceptedByImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
    };

_$GameScoreImpl _$$GameScoreImplFromJson(Map<String, dynamic> json) =>
    _$GameScoreImpl(
      creatorScore: (json['creatorScore'] as num).toInt(),
      opponentScore: (json['opponentScore'] as num).toInt(),
    );

Map<String, dynamic> _$$GameScoreImplToJson(_$GameScoreImpl instance) =>
    <String, dynamic>{
      'creatorScore': instance.creatorScore,
      'opponentScore': instance.opponentScore,
    };

_$ScoresImpl _$$ScoresImplFromJson(Map<String, dynamic> json) => _$ScoresImpl(
      games: (json['games'] as List<dynamic>)
          .map((e) => GameScore.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ScoresImplToJson(_$ScoresImpl instance) =>
    <String, dynamic>{
      'games': instance.games,
    };
