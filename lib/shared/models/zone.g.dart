// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppZoneImpl _$$AppZoneImplFromJson(Map<String, dynamic> json) =>
    _$AppZoneImpl(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      description: json['description'] as String,
      cities: (json['cities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      region: json['region'] as String? ?? '',
      active: json['active'] as bool? ?? true,
      createdAt: _timestampFromJson(json['createdAt']),
    );

Map<String, dynamic> _$$AppZoneImplToJson(_$AppZoneImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'description': instance.description,
      'cities': instance.cities,
      'region': instance.region,
      'active': instance.active,
      'createdAt': _timestampToJson(instance.createdAt),
    };
