// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'zone.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppZone _$AppZoneFromJson(Map<String, dynamic> json) {
  return _AppZone.fromJson(json);
}

/// @nodoc
mixin _$AppZone {
  String get id => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get cities => throw _privateConstructorUsedError;
  String get region => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppZoneCopyWith<AppZone> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppZoneCopyWith<$Res> {
  factory $AppZoneCopyWith(AppZone value, $Res Function(AppZone) then) =
      _$AppZoneCopyWithImpl<$Res, AppZone>;
  @useResult
  $Res call(
      {String id,
      String displayName,
      String description,
      List<String> cities,
      String region,
      bool active,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime createdAt});
}

/// @nodoc
class _$AppZoneCopyWithImpl<$Res, $Val extends AppZone>
    implements $AppZoneCopyWith<$Res> {
  _$AppZoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? description = null,
    Object? cities = null,
    Object? region = null,
    Object? active = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      cities: null == cities
          ? _value.cities
          : cities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppZoneImplCopyWith<$Res> implements $AppZoneCopyWith<$Res> {
  factory _$$AppZoneImplCopyWith(
          _$AppZoneImpl value, $Res Function(_$AppZoneImpl) then) =
      __$$AppZoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String displayName,
      String description,
      List<String> cities,
      String region,
      bool active,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime createdAt});
}

/// @nodoc
class __$$AppZoneImplCopyWithImpl<$Res>
    extends _$AppZoneCopyWithImpl<$Res, _$AppZoneImpl>
    implements _$$AppZoneImplCopyWith<$Res> {
  __$$AppZoneImplCopyWithImpl(
      _$AppZoneImpl _value, $Res Function(_$AppZoneImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? description = null,
    Object? cities = null,
    Object? region = null,
    Object? active = null,
    Object? createdAt = null,
  }) {
    return _then(_$AppZoneImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      cities: null == cities
          ? _value._cities
          : cities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppZoneImpl implements _AppZone {
  const _$AppZoneImpl(
      {required this.id,
      required this.displayName,
      required this.description,
      final List<String> cities = const [],
      this.region = '',
      this.active = true,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required this.createdAt})
      : _cities = cities;

  factory _$AppZoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppZoneImplFromJson(json);

  @override
  final String id;
  @override
  final String displayName;
  @override
  final String description;
  final List<String> _cities;
  @override
  @JsonKey()
  List<String> get cities {
    if (_cities is EqualUnmodifiableListView) return _cities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cities);
  }

  @override
  @JsonKey()
  final String region;
  @override
  @JsonKey()
  final bool active;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime createdAt;

  @override
  String toString() {
    return 'AppZone(id: $id, displayName: $displayName, description: $description, cities: $cities, region: $region, active: $active, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppZoneImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._cities, _cities) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, displayName, description,
      const DeepCollectionEquality().hash(_cities), region, active, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppZoneImplCopyWith<_$AppZoneImpl> get copyWith =>
      __$$AppZoneImplCopyWithImpl<_$AppZoneImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppZoneImplToJson(
      this,
    );
  }
}

abstract class _AppZone implements AppZone {
  const factory _AppZone(
      {required final String id,
      required final String displayName,
      required final String description,
      final List<String> cities,
      final String region,
      final bool active,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required final DateTime createdAt}) = _$AppZoneImpl;

  factory _AppZone.fromJson(Map<String, dynamic> json) = _$AppZoneImpl.fromJson;

  @override
  String get id;
  @override
  String get displayName;
  @override
  String get description;
  @override
  List<String> get cities;
  @override
  String get region;
  @override
  bool get active;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$AppZoneImplCopyWith<_$AppZoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
