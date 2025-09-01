// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'court.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Court _$CourtFromJson(Map<String, dynamic> json) {
  return _Court.fromJson(json);
}

/// @nodoc
mixin _$Court {
  String get id => throw _privateConstructorUsedError;
  int get number => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  CourtStatus get status => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CourtCopyWith<Court> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourtCopyWith<$Res> {
  factory $CourtCopyWith(Court value, $Res Function(Court) then) =
      _$CourtCopyWithImpl<$Res, Court>;
  @useResult
  $Res call(
      {String id,
      int number,
      String name,
      CourtStatus status,
      String? description,
      bool isActive});
}

/// @nodoc
class _$CourtCopyWithImpl<$Res, $Val extends Court>
    implements $CourtCopyWith<$Res> {
  _$CourtCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? number = null,
    Object? name = null,
    Object? status = null,
    Object? description = freezed,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CourtStatus,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CourtImplCopyWith<$Res> implements $CourtCopyWith<$Res> {
  factory _$$CourtImplCopyWith(
          _$CourtImpl value, $Res Function(_$CourtImpl) then) =
      __$$CourtImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int number,
      String name,
      CourtStatus status,
      String? description,
      bool isActive});
}

/// @nodoc
class __$$CourtImplCopyWithImpl<$Res>
    extends _$CourtCopyWithImpl<$Res, _$CourtImpl>
    implements _$$CourtImplCopyWith<$Res> {
  __$$CourtImplCopyWithImpl(
      _$CourtImpl _value, $Res Function(_$CourtImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? number = null,
    Object? name = null,
    Object? status = null,
    Object? description = freezed,
    Object? isActive = null,
  }) {
    return _then(_$CourtImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CourtStatus,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CourtImpl implements _Court {
  const _$CourtImpl(
      {required this.id,
      required this.number,
      required this.name,
      this.status = CourtStatus.available,
      this.description,
      this.isActive = true});

  factory _$CourtImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourtImplFromJson(json);

  @override
  final String id;
  @override
  final int number;
  @override
  final String name;
  @override
  @JsonKey()
  final CourtStatus status;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'Court(id: $id, number: $number, name: $name, status: $status, description: $description, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourtImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, number, name, status, description, isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CourtImplCopyWith<_$CourtImpl> get copyWith =>
      __$$CourtImplCopyWithImpl<_$CourtImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourtImplToJson(
      this,
    );
  }
}

abstract class _Court implements Court {
  const factory _Court(
      {required final String id,
      required final int number,
      required final String name,
      final CourtStatus status,
      final String? description,
      final bool isActive}) = _$CourtImpl;

  factory _Court.fromJson(Map<String, dynamic> json) = _$CourtImpl.fromJson;

  @override
  String get id;
  @override
  int get number;
  @override
  String get name;
  @override
  CourtStatus get status;
  @override
  String? get description;
  @override
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$CourtImplCopyWith<_$CourtImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CourtBooking _$CourtBookingFromJson(Map<String, dynamic> json) {
  return _CourtBooking.fromJson(json);
}

/// @nodoc
mixin _$CourtBooking {
  String get id => throw _privateConstructorUsedError;
  String get courtId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  BookingStatus get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CourtBookingCopyWith<CourtBooking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourtBookingCopyWith<$Res> {
  factory $CourtBookingCopyWith(
          CourtBooking value, $Res Function(CourtBooking) then) =
      _$CourtBookingCopyWithImpl<$Res, CourtBooking>;
  @useResult
  $Res call(
      {String id,
      String courtId,
      String userId,
      DateTime startTime,
      DateTime endTime,
      BookingStatus status,
      String? notes,
      DateTime? createdAt});
}

/// @nodoc
class _$CourtBookingCopyWithImpl<$Res, $Val extends CourtBooking>
    implements $CourtBookingCopyWith<$Res> {
  _$CourtBookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courtId = null,
    Object? userId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      courtId: null == courtId
          ? _value.courtId
          : courtId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CourtBookingImplCopyWith<$Res>
    implements $CourtBookingCopyWith<$Res> {
  factory _$$CourtBookingImplCopyWith(
          _$CourtBookingImpl value, $Res Function(_$CourtBookingImpl) then) =
      __$$CourtBookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String courtId,
      String userId,
      DateTime startTime,
      DateTime endTime,
      BookingStatus status,
      String? notes,
      DateTime? createdAt});
}

/// @nodoc
class __$$CourtBookingImplCopyWithImpl<$Res>
    extends _$CourtBookingCopyWithImpl<$Res, _$CourtBookingImpl>
    implements _$$CourtBookingImplCopyWith<$Res> {
  __$$CourtBookingImplCopyWithImpl(
      _$CourtBookingImpl _value, $Res Function(_$CourtBookingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courtId = null,
    Object? userId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$CourtBookingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      courtId: null == courtId
          ? _value.courtId
          : courtId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CourtBookingImpl implements _CourtBooking {
  const _$CourtBookingImpl(
      {required this.id,
      required this.courtId,
      required this.userId,
      required this.startTime,
      required this.endTime,
      required this.status,
      this.notes,
      this.createdAt});

  factory _$CourtBookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourtBookingImplFromJson(json);

  @override
  final String id;
  @override
  final String courtId;
  @override
  final String userId;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final BookingStatus status;
  @override
  final String? notes;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'CourtBooking(id: $id, courtId: $courtId, userId: $userId, startTime: $startTime, endTime: $endTime, status: $status, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourtBookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.courtId, courtId) || other.courtId == courtId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, courtId, userId, startTime,
      endTime, status, notes, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CourtBookingImplCopyWith<_$CourtBookingImpl> get copyWith =>
      __$$CourtBookingImplCopyWithImpl<_$CourtBookingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourtBookingImplToJson(
      this,
    );
  }
}

abstract class _CourtBooking implements CourtBooking {
  const factory _CourtBooking(
      {required final String id,
      required final String courtId,
      required final String userId,
      required final DateTime startTime,
      required final DateTime endTime,
      required final BookingStatus status,
      final String? notes,
      final DateTime? createdAt}) = _$CourtBookingImpl;

  factory _CourtBooking.fromJson(Map<String, dynamic> json) =
      _$CourtBookingImpl.fromJson;

  @override
  String get id;
  @override
  String get courtId;
  @override
  String get userId;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  BookingStatus get status;
  @override
  String? get notes;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$CourtBookingImplCopyWith<_$CourtBookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
