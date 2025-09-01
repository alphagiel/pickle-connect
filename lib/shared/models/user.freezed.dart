// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  UserRole get role => throw _privateConstructorUsedError;
  String? get ustaRating => throw _privateConstructorUsedError;
  String? get utrRating => throw _privateConstructorUsedError;
  SkillDivision? get skillDivision => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String id,
      String email,
      String fullName,
      String phoneNumber,
      UserRole role,
      String? ustaRating,
      String? utrRating,
      SkillDivision? skillDivision,
      bool isActive,
      DateTime? createdAt,
      DateTime? lastLoginAt});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? fullName = null,
    Object? phoneNumber = null,
    Object? role = null,
    Object? ustaRating = freezed,
    Object? utrRating = freezed,
    Object? skillDivision = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? lastLoginAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      ustaRating: freezed == ustaRating
          ? _value.ustaRating
          : ustaRating // ignore: cast_nullable_to_non_nullable
              as String?,
      utrRating: freezed == utrRating
          ? _value.utrRating
          : utrRating // ignore: cast_nullable_to_non_nullable
              as String?,
      skillDivision: freezed == skillDivision
          ? _value.skillDivision
          : skillDivision // ignore: cast_nullable_to_non_nullable
              as SkillDivision?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String fullName,
      String phoneNumber,
      UserRole role,
      String? ustaRating,
      String? utrRating,
      SkillDivision? skillDivision,
      bool isActive,
      DateTime? createdAt,
      DateTime? lastLoginAt});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? fullName = null,
    Object? phoneNumber = null,
    Object? role = null,
    Object? ustaRating = freezed,
    Object? utrRating = freezed,
    Object? skillDivision = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? lastLoginAt = freezed,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      ustaRating: freezed == ustaRating
          ? _value.ustaRating
          : ustaRating // ignore: cast_nullable_to_non_nullable
              as String?,
      utrRating: freezed == utrRating
          ? _value.utrRating
          : utrRating // ignore: cast_nullable_to_non_nullable
              as String?,
      skillDivision: freezed == skillDivision
          ? _value.skillDivision
          : skillDivision // ignore: cast_nullable_to_non_nullable
              as SkillDivision?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {required this.id,
      required this.email,
      required this.fullName,
      required this.phoneNumber,
      required this.role,
      this.ustaRating,
      this.utrRating,
      this.skillDivision,
      this.isActive = true,
      this.createdAt,
      this.lastLoginAt});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String fullName;
  @override
  final String phoneNumber;
  @override
  final UserRole role;
  @override
  final String? ustaRating;
  @override
  final String? utrRating;
  @override
  final SkillDivision? skillDivision;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? lastLoginAt;

  @override
  String toString() {
    return 'User(id: $id, email: $email, fullName: $fullName, phoneNumber: $phoneNumber, role: $role, ustaRating: $ustaRating, utrRating: $utrRating, skillDivision: $skillDivision, isActive: $isActive, createdAt: $createdAt, lastLoginAt: $lastLoginAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.ustaRating, ustaRating) ||
                other.ustaRating == ustaRating) &&
            (identical(other.utrRating, utrRating) ||
                other.utrRating == utrRating) &&
            (identical(other.skillDivision, skillDivision) ||
                other.skillDivision == skillDivision) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      fullName,
      phoneNumber,
      role,
      ustaRating,
      utrRating,
      skillDivision,
      isActive,
      createdAt,
      lastLoginAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String id,
      required final String email,
      required final String fullName,
      required final String phoneNumber,
      required final UserRole role,
      final String? ustaRating,
      final String? utrRating,
      final SkillDivision? skillDivision,
      final bool isActive,
      final DateTime? createdAt,
      final DateTime? lastLoginAt}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get fullName;
  @override
  String get phoneNumber;
  @override
  UserRole get role;
  @override
  String? get ustaRating;
  @override
  String? get utrRating;
  @override
  SkillDivision? get skillDivision;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get lastLoginAt;
  @override
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
