// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TournamentImpl _$$TournamentImplFromJson(Map<String, dynamic> json) =>
    _$TournamentImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      format: $enumDecode(_$TournamentFormatEnumMap, json['format']),
      registrationStart: DateTime.parse(json['registrationStart'] as String),
      registrationEnd: DateTime.parse(json['registrationEnd'] as String),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      maxParticipants: (json['maxParticipants'] as num).toInt(),
      currentParticipants: (json['currentParticipants'] as num?)?.toInt() ?? 0,
      status: $enumDecodeNullable(_$TournamentStatusEnumMap, json['status']) ??
          TournamentStatus.upcoming,
      eligibleDivisions: (json['eligibleDivisions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      entryFee: (json['entryFee'] as num?)?.toDouble(),
      prizeDescription: json['prizeDescription'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TournamentImplToJson(_$TournamentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'format': _$TournamentFormatEnumMap[instance.format]!,
      'registrationStart': instance.registrationStart.toIso8601String(),
      'registrationEnd': instance.registrationEnd.toIso8601String(),
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'maxParticipants': instance.maxParticipants,
      'currentParticipants': instance.currentParticipants,
      'status': _$TournamentStatusEnumMap[instance.status]!,
      'eligibleDivisions': instance.eligibleDivisions,
      'entryFee': instance.entryFee,
      'prizeDescription': instance.prizeDescription,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$TournamentFormatEnumMap = {
  TournamentFormat.singleElimination: 'single_elimination',
  TournamentFormat.doubleElimination: 'double_elimination',
  TournamentFormat.roundRobin: 'round_robin',
  TournamentFormat.topEightElimination: 'top_eight_elimination',
};

const _$TournamentStatusEnumMap = {
  TournamentStatus.upcoming: 'upcoming',
  TournamentStatus.registrationOpen: 'registration_open',
  TournamentStatus.registrationClosed: 'registration_closed',
  TournamentStatus.inProgress: 'in_progress',
  TournamentStatus.completed: 'completed',
  TournamentStatus.cancelled: 'cancelled',
};

_$TournamentParticipantImpl _$$TournamentParticipantImplFromJson(
        Map<String, dynamic> json) =>
    _$TournamentParticipantImpl(
      id: json['id'] as String,
      tournamentId: json['tournamentId'] as String,
      userId: json['userId'] as String,
      registeredAt: DateTime.parse(json['registeredAt'] as String),
      status: $enumDecodeNullable(_$ParticipantStatusEnumMap, json['status']) ??
          ParticipantStatus.registered,
      seed: (json['seed'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TournamentParticipantImplToJson(
        _$TournamentParticipantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tournamentId': instance.tournamentId,
      'userId': instance.userId,
      'registeredAt': instance.registeredAt.toIso8601String(),
      'status': _$ParticipantStatusEnumMap[instance.status]!,
      'seed': instance.seed,
    };

const _$ParticipantStatusEnumMap = {
  ParticipantStatus.registered: 'registered',
  ParticipantStatus.confirmed: 'confirmed',
  ParticipantStatus.eliminated: 'eliminated',
  ParticipantStatus.withdrawn: 'withdrawn',
};

_$TournamentMatchImpl _$$TournamentMatchImplFromJson(
        Map<String, dynamic> json) =>
    _$TournamentMatchImpl(
      id: json['id'] as String,
      tournamentId: json['tournamentId'] as String,
      participant1Id: json['participant1Id'] as String,
      participant2Id: json['participant2Id'] as String,
      round: (json['round'] as num).toInt(),
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      courtId: json['courtId'] as String?,
      result: json['result'] == null
          ? null
          : TournamentMatchResult.fromJson(
              json['result'] as Map<String, dynamic>),
      status:
          $enumDecodeNullable(_$TournamentMatchStatusEnumMap, json['status']) ??
              TournamentMatchStatus.pending,
    );

Map<String, dynamic> _$$TournamentMatchImplToJson(
        _$TournamentMatchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tournamentId': instance.tournamentId,
      'participant1Id': instance.participant1Id,
      'participant2Id': instance.participant2Id,
      'round': instance.round,
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'courtId': instance.courtId,
      'result': instance.result,
      'status': _$TournamentMatchStatusEnumMap[instance.status]!,
    };

const _$TournamentMatchStatusEnumMap = {
  TournamentMatchStatus.pending: 'pending',
  TournamentMatchStatus.scheduled: 'scheduled',
  TournamentMatchStatus.inProgress: 'in_progress',
  TournamentMatchStatus.completed: 'completed',
  TournamentMatchStatus.cancelled: 'cancelled',
};

_$TournamentMatchResultImpl _$$TournamentMatchResultImplFromJson(
        Map<String, dynamic> json) =>
    _$TournamentMatchResultImpl(
      winnerId: json['winnerId'] as String,
      loserId: json['loserId'] as String,
      sets: (json['sets'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).toSet())
          .toList(),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$TournamentMatchResultImplToJson(
        _$TournamentMatchResultImpl instance) =>
    <String, dynamic>{
      'winnerId': instance.winnerId,
      'loserId': instance.loserId,
      'sets': instance.sets.map((e) => e.toList()).toList(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };
