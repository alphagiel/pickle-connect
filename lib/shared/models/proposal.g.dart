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

_$ScoresImpl _$$ScoresImplFromJson(Map<String, dynamic> json) => _$ScoresImpl(
      creatorScore: (json['creatorScore'] as num).toInt(),
      opponentScore: (json['opponentScore'] as num).toInt(),
    );

Map<String, dynamic> _$$ScoresImplToJson(_$ScoresImpl instance) =>
    <String, dynamic>{
      'creatorScore': instance.creatorScore,
      'opponentScore': instance.opponentScore,
    };

_$ProposalImpl _$$ProposalImplFromJson(Map<String, dynamic> json) =>
    _$ProposalImpl(
      proposalId: json['proposalId'] as String,
      creatorId: json['creatorId'] as String,
      creatorName: json['creatorName'] as String,
      skillLevels: (json['skillLevels'] as List<dynamic>)
          .map((e) => $enumDecode(_$SkillLevelEnumMap, e))
          .toList(),
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
      'skillLevels':
          instance.skillLevels.map((e) => _$SkillLevelEnumMap[e]!).toList(),
      'location': instance.location,
      'dateTime': _timestampToJson(instance.dateTime),
      'status': _$ProposalStatusEnumMap[instance.status]!,
      'acceptedBy': instance.acceptedBy,
      'scores': instance.scores,
      'scoreConfirmedBy': instance.scoreConfirmedBy,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
    };

const _$SkillLevelEnumMap = {
  SkillLevel.beginner: 'Beginner',
  SkillLevel.intermediate: 'Intermediate',
  SkillLevel.advancedPlus: 'Advanced+',
};

const _$ProposalStatusEnumMap = {
  ProposalStatus.open: 'open',
  ProposalStatus.accepted: 'accepted',
  ProposalStatus.expired: 'expired',
  ProposalStatus.completed: 'completed',
  ProposalStatus.canceled: 'canceled',
};
