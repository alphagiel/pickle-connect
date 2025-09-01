// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'court.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourtImpl _$$CourtImplFromJson(Map<String, dynamic> json) => _$CourtImpl(
      id: json['id'] as String,
      number: (json['number'] as num).toInt(),
      name: json['name'] as String,
      status: $enumDecodeNullable(_$CourtStatusEnumMap, json['status']) ??
          CourtStatus.available,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$CourtImplToJson(_$CourtImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'name': instance.name,
      'status': _$CourtStatusEnumMap[instance.status]!,
      'description': instance.description,
      'isActive': instance.isActive,
    };

const _$CourtStatusEnumMap = {
  CourtStatus.available: 'available',
  CourtStatus.occupied: 'occupied',
  CourtStatus.reserved: 'reserved',
  CourtStatus.maintenance: 'maintenance',
};

_$CourtBookingImpl _$$CourtBookingImplFromJson(Map<String, dynamic> json) =>
    _$CourtBookingImpl(
      id: json['id'] as String,
      courtId: json['courtId'] as String,
      userId: json['userId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CourtBookingImplToJson(_$CourtBookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courtId': instance.courtId,
      'userId': instance.userId,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'status': _$BookingStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$BookingStatusEnumMap = {
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.pending: 'pending',
  BookingStatus.cancelled: 'cancelled',
  BookingStatus.completed: 'completed',
};
