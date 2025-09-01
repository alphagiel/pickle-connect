// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      ustaRating: json['ustaRating'] as String?,
      utrRating: json['utrRating'] as String?,
      skillDivision:
          $enumDecodeNullable(_$SkillDivisionEnumMap, json['skillDivision']),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'role': _$UserRoleEnumMap[instance.role]!,
      'ustaRating': instance.ustaRating,
      'utrRating': instance.utrRating,
      'skillDivision': _$SkillDivisionEnumMap[instance.skillDivision],
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.user: 'user',
};

const _$SkillDivisionEnumMap = {
  SkillDivision.beginner: 'beginner',
  SkillDivision.intermediate: 'intermediate',
  SkillDivision.advanced: 'advanced',
};
