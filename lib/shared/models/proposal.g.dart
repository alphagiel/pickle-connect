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

_$ProposalImpl _$$ProposalImplFromJson(Map<String, dynamic> json) =>
    _$ProposalImpl(
      proposalId: json['proposalId'] as String,
      creatorId: json['creatorId'] as String,
      creatorName: json['creatorName'] as String,
      skillLevel: _skillLevelFromJson(json['skillLevel']),
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
    );

Map<String, dynamic> _$$ProposalImplToJson(_$ProposalImpl instance) =>
    <String, dynamic>{
      'proposalId': instance.proposalId,
      'creatorId': instance.creatorId,
      'creatorName': instance.creatorName,
      'skillLevel': _skillLevelToJson(instance.skillLevel),
      'location': instance.location,
      'dateTime': _timestampToJson(instance.dateTime),
      'status': _$ProposalStatusEnumMap[instance.status]!,
      'acceptedBy': instance.acceptedBy,
      'scores': instance.scores,
      'scoreConfirmedBy': instance.scoreConfirmedBy,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
    };

const _$ProposalStatusEnumMap = {
  ProposalStatus.open: 'open',
  ProposalStatus.accepted: 'accepted',
  ProposalStatus.expired: 'expired',
  ProposalStatus.completed: 'completed',
  ProposalStatus.canceled: 'canceled',
};
