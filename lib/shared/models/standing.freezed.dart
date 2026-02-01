// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'standing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Standing _$StandingFromJson(Map<String, dynamic> json) {
  return _Standing.fromJson(json);
}

/// @nodoc
mixin _$Standing {
  String get userId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  SkillLevel get skillLevel => throw _privateConstructorUsedError;
  int get matchesPlayed => throw _privateConstructorUsedError;
  int get matchesWon => throw _privateConstructorUsedError;
  int get matchesLost => throw _privateConstructorUsedError;
  double get winRate => throw _privateConstructorUsedError;
  int get rankingPoints => throw _privateConstructorUsedError;
  int get streak =>
      throw _privateConstructorUsedError; // Positive for consecutive wins, negative for losses (e.g., +3 or -2)
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StandingCopyWith<Standing> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StandingCopyWith<$Res> {
  factory $StandingCopyWith(Standing value, $Res Function(Standing) then) =
      _$StandingCopyWithImpl<$Res, Standing>;
  @useResult
  $Res call(
      {String userId,
      String displayName,
      SkillLevel skillLevel,
      int matchesPlayed,
      int matchesWon,
      int matchesLost,
      double winRate,
      int rankingPoints,
      int streak,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime lastUpdated});
}

/// @nodoc
class _$StandingCopyWithImpl<$Res, $Val extends Standing>
    implements $StandingCopyWith<$Res> {
  _$StandingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? skillLevel = null,
    Object? matchesPlayed = null,
    Object? matchesWon = null,
    Object? matchesLost = null,
    Object? winRate = null,
    Object? rankingPoints = null,
    Object? streak = null,
    Object? lastUpdated = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      skillLevel: null == skillLevel
          ? _value.skillLevel
          : skillLevel // ignore: cast_nullable_to_non_nullable
              as SkillLevel,
      matchesPlayed: null == matchesPlayed
          ? _value.matchesPlayed
          : matchesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      matchesWon: null == matchesWon
          ? _value.matchesWon
          : matchesWon // ignore: cast_nullable_to_non_nullable
              as int,
      matchesLost: null == matchesLost
          ? _value.matchesLost
          : matchesLost // ignore: cast_nullable_to_non_nullable
              as int,
      winRate: null == winRate
          ? _value.winRate
          : winRate // ignore: cast_nullable_to_non_nullable
              as double,
      rankingPoints: null == rankingPoints
          ? _value.rankingPoints
          : rankingPoints // ignore: cast_nullable_to_non_nullable
              as int,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StandingImplCopyWith<$Res>
    implements $StandingCopyWith<$Res> {
  factory _$$StandingImplCopyWith(
          _$StandingImpl value, $Res Function(_$StandingImpl) then) =
      __$$StandingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String displayName,
      SkillLevel skillLevel,
      int matchesPlayed,
      int matchesWon,
      int matchesLost,
      double winRate,
      int rankingPoints,
      int streak,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime lastUpdated});
}

/// @nodoc
class __$$StandingImplCopyWithImpl<$Res>
    extends _$StandingCopyWithImpl<$Res, _$StandingImpl>
    implements _$$StandingImplCopyWith<$Res> {
  __$$StandingImplCopyWithImpl(
      _$StandingImpl _value, $Res Function(_$StandingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? skillLevel = null,
    Object? matchesPlayed = null,
    Object? matchesWon = null,
    Object? matchesLost = null,
    Object? winRate = null,
    Object? rankingPoints = null,
    Object? streak = null,
    Object? lastUpdated = null,
  }) {
    return _then(_$StandingImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      skillLevel: null == skillLevel
          ? _value.skillLevel
          : skillLevel // ignore: cast_nullable_to_non_nullable
              as SkillLevel,
      matchesPlayed: null == matchesPlayed
          ? _value.matchesPlayed
          : matchesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      matchesWon: null == matchesWon
          ? _value.matchesWon
          : matchesWon // ignore: cast_nullable_to_non_nullable
              as int,
      matchesLost: null == matchesLost
          ? _value.matchesLost
          : matchesLost // ignore: cast_nullable_to_non_nullable
              as int,
      winRate: null == winRate
          ? _value.winRate
          : winRate // ignore: cast_nullable_to_non_nullable
              as double,
      rankingPoints: null == rankingPoints
          ? _value.rankingPoints
          : rankingPoints // ignore: cast_nullable_to_non_nullable
              as int,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StandingImpl implements _Standing {
  const _$StandingImpl(
      {required this.userId,
      required this.displayName,
      required this.skillLevel,
      this.matchesPlayed = 0,
      this.matchesWon = 0,
      this.matchesLost = 0,
      this.winRate = 0.0,
      this.rankingPoints = 1000,
      this.streak = 0,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required this.lastUpdated});

  factory _$StandingImpl.fromJson(Map<String, dynamic> json) =>
      _$$StandingImplFromJson(json);

  @override
  final String userId;
  @override
  final String displayName;
  @override
  final SkillLevel skillLevel;
  @override
  @JsonKey()
  final int matchesPlayed;
  @override
  @JsonKey()
  final int matchesWon;
  @override
  @JsonKey()
  final int matchesLost;
  @override
  @JsonKey()
  final double winRate;
  @override
  @JsonKey()
  final int rankingPoints;
  @override
  @JsonKey()
  final int streak;
// Positive for consecutive wins, negative for losses (e.g., +3 or -2)
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'Standing(userId: $userId, displayName: $displayName, skillLevel: $skillLevel, matchesPlayed: $matchesPlayed, matchesWon: $matchesWon, matchesLost: $matchesLost, winRate: $winRate, rankingPoints: $rankingPoints, streak: $streak, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StandingImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.skillLevel, skillLevel) ||
                other.skillLevel == skillLevel) &&
            (identical(other.matchesPlayed, matchesPlayed) ||
                other.matchesPlayed == matchesPlayed) &&
            (identical(other.matchesWon, matchesWon) ||
                other.matchesWon == matchesWon) &&
            (identical(other.matchesLost, matchesLost) ||
                other.matchesLost == matchesLost) &&
            (identical(other.winRate, winRate) || other.winRate == winRate) &&
            (identical(other.rankingPoints, rankingPoints) ||
                other.rankingPoints == rankingPoints) &&
            (identical(other.streak, streak) || other.streak == streak) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      displayName,
      skillLevel,
      matchesPlayed,
      matchesWon,
      matchesLost,
      winRate,
      rankingPoints,
      streak,
      lastUpdated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StandingImplCopyWith<_$StandingImpl> get copyWith =>
      __$$StandingImplCopyWithImpl<_$StandingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StandingImplToJson(
      this,
    );
  }
}

abstract class _Standing implements Standing {
  const factory _Standing(
      {required final String userId,
      required final String displayName,
      required final SkillLevel skillLevel,
      final int matchesPlayed,
      final int matchesWon,
      final int matchesLost,
      final double winRate,
      final int rankingPoints,
      final int streak,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required final DateTime lastUpdated}) = _$StandingImpl;

  factory _Standing.fromJson(Map<String, dynamic> json) =
      _$StandingImpl.fromJson;

  @override
  String get userId;
  @override
  String get displayName;
  @override
  SkillLevel get skillLevel;
  @override
  int get matchesPlayed;
  @override
  int get matchesWon;
  @override
  int get matchesLost;
  @override
  double get winRate;
  @override
  int get rankingPoints;
  @override
  int get streak;
  @override // Positive for consecutive wins, negative for losses (e.g., +3 or -2)
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get lastUpdated;
  @override
  @JsonKey(ignore: true)
  _$$StandingImplCopyWith<_$StandingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
