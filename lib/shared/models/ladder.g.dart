// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ladder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LadderEntryImpl _$$LadderEntryImplFromJson(Map<String, dynamic> json) =>
    _$LadderEntryImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      seasonId: json['seasonId'] as String,
      rank: (json['rank'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      wins: (json['wins'] as num).toInt(),
      losses: (json['losses'] as num).toInt(),
      previousRank: (json['previousRank'] as num?)?.toInt(),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$LadderEntryImplToJson(_$LadderEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'seasonId': instance.seasonId,
      'rank': instance.rank,
      'rating': instance.rating,
      'wins': instance.wins,
      'losses': instance.losses,
      'previousRank': instance.previousRank,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };

_$SeasonImpl _$$SeasonImplFromJson(Map<String, dynamic> json) => _$SeasonImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      status: $enumDecodeNullable(_$SeasonStatusEnumMap, json['status']) ??
          SeasonStatus.upcoming,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$SeasonImplToJson(_$SeasonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'status': _$SeasonStatusEnumMap[instance.status]!,
      'description': instance.description,
    };

const _$SeasonStatusEnumMap = {
  SeasonStatus.upcoming: 'upcoming',
  SeasonStatus.active: 'active',
  SeasonStatus.completed: 'completed',
};

_$MatchImpl _$$MatchImplFromJson(Map<String, dynamic> json) => _$MatchImpl(
      id: json['id'] as String,
      player1Id: json['player1Id'] as String,
      player2Id: json['player2Id'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      result: json['result'] == null
          ? null
          : MatchResult.fromJson(json['result'] as Map<String, dynamic>),
      notes: json['notes'] as String?,
      status: $enumDecodeNullable(_$MatchStatusEnumMap, json['status']) ??
          MatchStatus.scheduled,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$MatchImplToJson(_$MatchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'player1Id': instance.player1Id,
      'player2Id': instance.player2Id,
      'scheduledAt': instance.scheduledAt.toIso8601String(),
      'result': instance.result,
      'notes': instance.notes,
      'status': _$MatchStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$MatchStatusEnumMap = {
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
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$MatchResultImplToJson(_$MatchResultImpl instance) =>
    <String, dynamic>{
      'winnerId': instance.winnerId,
      'loserId': instance.loserId,
      'sets': instance.sets,
      'completedAt': instance.completedAt?.toIso8601String(),
    };

_$SetImpl _$$SetImplFromJson(Map<String, dynamic> json) => _$SetImpl(
      player1Score: (json['player1Score'] as num).toInt(),
      player2Score: (json['player2Score'] as num).toInt(),
    );

Map<String, dynamic> _$$SetImplToJson(_$SetImpl instance) => <String, dynamic>{
      'player1Score': instance.player1Score,
      'player2Score': instance.player2Score,
    };
