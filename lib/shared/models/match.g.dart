// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchImpl _$$MatchImplFromJson(Map<String, dynamic> json) => _$MatchImpl(
      id: json['id'] as String,
      player1Id: json['player1Id'] as String,
      player2Id: json['player2Id'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      status: $enumDecodeNullable(_$MatchStatusEnumMap, json['status']) ??
          MatchStatus.proposed,
      player1Name: json['player1Name'] as String?,
      player2Name: json['player2Name'] as String?,
      courtId: json['courtId'] as String?,
      seasonId: json['seasonId'] as String?,
      notes: json['notes'] as String?,
      result: json['result'] == null
          ? null
          : MatchResult.fromJson(json['result'] as Map<String, dynamic>),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MatchImplToJson(_$MatchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'player1Id': instance.player1Id,
      'player2Id': instance.player2Id,
      'scheduledAt': instance.scheduledAt.toIso8601String(),
      'status': _$MatchStatusEnumMap[instance.status]!,
      'player1Name': instance.player1Name,
      'player2Name': instance.player2Name,
      'courtId': instance.courtId,
      'seasonId': instance.seasonId,
      'notes': instance.notes,
      'result': instance.result,
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'participants': instance.participants,
    };

const _$MatchStatusEnumMap = {
  MatchStatus.proposed: 'proposed',
  MatchStatus.scheduled: 'scheduled',
  MatchStatus.inProgress: 'in_progress',
  MatchStatus.completed: 'completed',
  MatchStatus.cancelled: 'cancelled',
};

_$MatchResultImpl _$$MatchResultImplFromJson(Map<String, dynamic> json) =>
    _$MatchResultImpl(
      winnerId: json['winnerId'] as String,
      loserId: json['loserId'] as String,
      sets: (json['sets'] as List<dynamic>)
          .map((e) => Set.fromJson(e as Map<String, dynamic>))
          .toList(),
      player1Games: (json['player1Games'] as num?)?.toInt() ?? 0,
      player2Games: (json['player2Games'] as num?)?.toInt() ?? 0,
      notes: json['notes'] as String?,
      format: $enumDecodeNullable(_$MatchFormatEnumMap, json['format']) ??
          MatchFormat.bestOfThree,
    );

Map<String, dynamic> _$$MatchResultImplToJson(_$MatchResultImpl instance) =>
    <String, dynamic>{
      'winnerId': instance.winnerId,
      'loserId': instance.loserId,
      'sets': instance.sets,
      'player1Games': instance.player1Games,
      'player2Games': instance.player2Games,
      'notes': instance.notes,
      'format': _$MatchFormatEnumMap[instance.format]!,
    };

const _$MatchFormatEnumMap = {
  MatchFormat.bestOfThree: 'best_of_three',
  MatchFormat.bestOfFive: 'best_of_five',
  MatchFormat.proSet: 'pro_set',
  MatchFormat.singleSet: 'single_set',
};

_$SetImpl _$$SetImplFromJson(Map<String, dynamic> json) => _$SetImpl(
      player1Games: (json['player1Games'] as num?)?.toInt() ?? 0,
      player2Games: (json['player2Games'] as num?)?.toInt() ?? 0,
      tiebreak: json['tiebreak'] == null
          ? null
          : Tiebreak.fromJson(json['tiebreak'] as Map<String, dynamic>),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$SetImplToJson(_$SetImpl instance) => <String, dynamic>{
      'player1Games': instance.player1Games,
      'player2Games': instance.player2Games,
      'tiebreak': instance.tiebreak,
      'isCompleted': instance.isCompleted,
    };

_$TiebreakImpl _$$TiebreakImplFromJson(Map<String, dynamic> json) =>
    _$TiebreakImpl(
      player1Points: (json['player1Points'] as num?)?.toInt() ?? 0,
      player2Points: (json['player2Points'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TiebreakImplToJson(_$TiebreakImpl instance) =>
    <String, dynamic>{
      'player1Points': instance.player1Points,
      'player2Points': instance.player2Points,
    };
