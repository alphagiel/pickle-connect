// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmailNotificationPreferencesImpl _$$EmailNotificationPreferencesImplFromJson(
        Map<String, dynamic> json) =>
    _$EmailNotificationPreferencesImpl(
      welcome: json['welcome'] as bool? ?? true,
      newProposals: json['newProposals'] as bool? ?? true,
      proposalAccepted: json['proposalAccepted'] as bool? ?? true,
      proposalUnaccepted: json['proposalUnaccepted'] as bool? ?? true,
      matchResults: json['matchResults'] as bool? ?? true,
      doublesUpdates: json['doublesUpdates'] as bool? ?? true,
    );

Map<String, dynamic> _$$EmailNotificationPreferencesImplToJson(
        _$EmailNotificationPreferencesImpl instance) =>
    <String, dynamic>{
      'welcome': instance.welcome,
      'newProposals': instance.newProposals,
      'proposalAccepted': instance.proposalAccepted,
      'proposalUnaccepted': instance.proposalUnaccepted,
      'matchResults': instance.matchResults,
      'doublesUpdates': instance.doublesUpdates,
    };

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      skillLevel: _skillLevelFromJson(json['skillLevel']),
      skillBracket: _skillBracketFromJson(json['skillBracket']),
      location: json['location'] as String,
      profileImageURL: json['profileImageURL'] as String?,
      matchesPlayed: (json['matchesPlayed'] as num?)?.toInt() ?? 0,
      matchesWon: (json['matchesWon'] as num?)?.toInt() ?? 0,
      matchesLost: (json['matchesLost'] as num?)?.toInt() ?? 0,
      winRate: (json['winRate'] as num?)?.toDouble() ?? 0.0,
      doublesPlayed: (json['doublesPlayed'] as num?)?.toInt() ?? 0,
      doublesWon: (json['doublesWon'] as num?)?.toInt() ?? 0,
      doublesLost: (json['doublesLost'] as num?)?.toInt() ?? 0,
      doublesWinRate: (json['doublesWinRate'] as num?)?.toDouble() ?? 0.0,
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
      emailNotifications: json['emailNotifications'] == null
          ? null
          : EmailNotificationPreferences.fromJson(
              json['emailNotifications'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'email': instance.email,
      'skillLevel': _skillLevelToJson(instance.skillLevel),
      'skillBracket': _skillBracketToJson(instance.skillBracket),
      'location': instance.location,
      'profileImageURL': instance.profileImageURL,
      'matchesPlayed': instance.matchesPlayed,
      'matchesWon': instance.matchesWon,
      'matchesLost': instance.matchesLost,
      'winRate': instance.winRate,
      'doublesPlayed': instance.doublesPlayed,
      'doublesWon': instance.doublesWon,
      'doublesLost': instance.doublesLost,
      'doublesWinRate': instance.doublesWinRate,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
      'emailNotifications': instance.emailNotifications,
    };
