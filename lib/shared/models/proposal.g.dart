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

_$DoublesPlayerImpl _$$DoublesPlayerImplFromJson(Map<String, dynamic> json) =>
    _$DoublesPlayerImpl(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      team: (json['team'] as num?)?.toInt(),
      status:
          $enumDecodeNullable(_$DoublesPlayerStatusEnumMap, json['status']) ??
              DoublesPlayerStatus.requested,
      invitedBy: json['invitedBy'] as String?,
    );

Map<String, dynamic> _$$DoublesPlayerImplToJson(_$DoublesPlayerImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'team': instance.team,
      'status': _$DoublesPlayerStatusEnumMap[instance.status]!,
      'invitedBy': instance.invitedBy,
    };

const _$DoublesPlayerStatusEnumMap = {
  DoublesPlayerStatus.confirmed: 'confirmed',
  DoublesPlayerStatus.invited: 'invited',
  DoublesPlayerStatus.requested: 'requested',
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
      'games': instance.games.map((e) => e.toJson()).toList(),
    };

_$ProposalImpl _$$ProposalImplFromJson(Map<String, dynamic> json) =>
    _$ProposalImpl(
      proposalId: json['proposalId'] as String,
      creatorId: json['creatorId'] as String,
      creatorName: json['creatorName'] as String,
      skillLevel: _skillLevelFromJson(json['skillLevel']),
      skillBracket: _skillBracketFromJson(json['skillBracket']),
      location: json['location'] as String,
      dateTime: _timestampFromJson(json['dateTime']),
      status: $enumDecode(_$ProposalStatusEnumMap, json['status']),
      acceptedBy: json['acceptedBy'] == null
          ? null
          : AcceptedBy.fromJson(json['acceptedBy'] as Map<String, dynamic>),
      scores: json['scores'] == null
          ? null
          : Scores.fromJson(json['scores'] as Map<String, dynamic>),
      scoreConfirmedBy: (json['scoreConfirmedBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
      matchType: $enumDecodeNullable(_$MatchTypeEnumMap, json['matchType']) ??
          MatchType.singles,
      doublesPlayers: (json['doublesPlayers'] as List<dynamic>?)
              ?.map((e) => DoublesPlayer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      openSlots: (json['openSlots'] as num?)?.toInt() ?? 0,
      playerIds: (json['playerIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      zone: json['zone'] as String? ?? 'east_triangle',
    );

Map<String, dynamic> _$$ProposalImplToJson(_$ProposalImpl instance) =>
    <String, dynamic>{
      'proposalId': instance.proposalId,
      'creatorId': instance.creatorId,
      'creatorName': instance.creatorName,
      'skillLevel': _skillLevelToJson(instance.skillLevel),
      'skillBracket': _skillBracketToJson(instance.skillBracket),
      'location': instance.location,
      'dateTime': _timestampToJson(instance.dateTime),
      'status': _$ProposalStatusEnumMap[instance.status]!,
      'acceptedBy': instance.acceptedBy?.toJson(),
      'scores': instance.scores?.toJson(),
      'scoreConfirmedBy': instance.scoreConfirmedBy,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
      'matchType': _$MatchTypeEnumMap[instance.matchType]!,
      'doublesPlayers': instance.doublesPlayers.map((e) => e.toJson()).toList(),
      'openSlots': instance.openSlots,
      'playerIds': instance.playerIds,
      'zone': instance.zone,
    };

const _$ProposalStatusEnumMap = {
  ProposalStatus.open: 'open',
  ProposalStatus.accepted: 'accepted',
  ProposalStatus.expired: 'expired',
  ProposalStatus.completed: 'completed',
  ProposalStatus.canceled: 'canceled',
};

const _$MatchTypeEnumMap = {
  MatchType.singles: 'singles',
  MatchType.doubles: 'doubles',
};
