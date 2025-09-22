// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Match _$MatchFromJson(Map<String, dynamic> json) {
  return _Match.fromJson(json);
}

/// @nodoc
mixin _$Match {
  String get id => throw _privateConstructorUsedError;
  String get player1Id => throw _privateConstructorUsedError;
  String get player2Id => throw _privateConstructorUsedError;
  DateTime get scheduledAt => throw _privateConstructorUsedError;
  MatchStatus get status => throw _privateConstructorUsedError;
  String? get player1Name => throw _privateConstructorUsedError;
  String? get player2Name => throw _privateConstructorUsedError;
  String? get courtId => throw _privateConstructorUsedError;
  String? get seasonId => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  MatchResult? get result => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<String> get participants => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MatchCopyWith<Match> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchCopyWith<$Res> {
  factory $MatchCopyWith(Match value, $Res Function(Match) then) =
      _$MatchCopyWithImpl<$Res, Match>;
  @useResult
  $Res call(
      {String id,
      String player1Id,
      String player2Id,
      DateTime scheduledAt,
      MatchStatus status,
      String? player1Name,
      String? player2Name,
      String? courtId,
      String? seasonId,
      String? notes,
      MatchResult? result,
      DateTime? completedAt,
      DateTime createdAt,
      DateTime updatedAt,
      List<String> participants});

  $MatchResultCopyWith<$Res>? get result;
}

/// @nodoc
class _$MatchCopyWithImpl<$Res, $Val extends Match>
    implements $MatchCopyWith<$Res> {
  _$MatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? player1Id = null,
    Object? player2Id = null,
    Object? scheduledAt = null,
    Object? status = null,
    Object? player1Name = freezed,
    Object? player2Name = freezed,
    Object? courtId = freezed,
    Object? seasonId = freezed,
    Object? notes = freezed,
    Object? result = freezed,
    Object? completedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? participants = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      player1Id: null == player1Id
          ? _value.player1Id
          : player1Id // ignore: cast_nullable_to_non_nullable
              as String,
      player2Id: null == player2Id
          ? _value.player2Id
          : player2Id // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledAt: null == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MatchStatus,
      player1Name: freezed == player1Name
          ? _value.player1Name
          : player1Name // ignore: cast_nullable_to_non_nullable
              as String?,
      player2Name: freezed == player2Name
          ? _value.player2Name
          : player2Name // ignore: cast_nullable_to_non_nullable
              as String?,
      courtId: freezed == courtId
          ? _value.courtId
          : courtId // ignore: cast_nullable_to_non_nullable
              as String?,
      seasonId: freezed == seasonId
          ? _value.seasonId
          : seasonId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as MatchResult?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MatchResultCopyWith<$Res>? get result {
    if (_value.result == null) {
      return null;
    }

    return $MatchResultCopyWith<$Res>(_value.result!, (value) {
      return _then(_value.copyWith(result: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MatchImplCopyWith<$Res> implements $MatchCopyWith<$Res> {
  factory _$$MatchImplCopyWith(
          _$MatchImpl value, $Res Function(_$MatchImpl) then) =
      __$$MatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String player1Id,
      String player2Id,
      DateTime scheduledAt,
      MatchStatus status,
      String? player1Name,
      String? player2Name,
      String? courtId,
      String? seasonId,
      String? notes,
      MatchResult? result,
      DateTime? completedAt,
      DateTime createdAt,
      DateTime updatedAt,
      List<String> participants});

  @override
  $MatchResultCopyWith<$Res>? get result;
}

/// @nodoc
class __$$MatchImplCopyWithImpl<$Res>
    extends _$MatchCopyWithImpl<$Res, _$MatchImpl>
    implements _$$MatchImplCopyWith<$Res> {
  __$$MatchImplCopyWithImpl(
      _$MatchImpl _value, $Res Function(_$MatchImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? player1Id = null,
    Object? player2Id = null,
    Object? scheduledAt = null,
    Object? status = null,
    Object? player1Name = freezed,
    Object? player2Name = freezed,
    Object? courtId = freezed,
    Object? seasonId = freezed,
    Object? notes = freezed,
    Object? result = freezed,
    Object? completedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? participants = null,
  }) {
    return _then(_$MatchImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      player1Id: null == player1Id
          ? _value.player1Id
          : player1Id // ignore: cast_nullable_to_non_nullable
              as String,
      player2Id: null == player2Id
          ? _value.player2Id
          : player2Id // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledAt: null == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MatchStatus,
      player1Name: freezed == player1Name
          ? _value.player1Name
          : player1Name // ignore: cast_nullable_to_non_nullable
              as String?,
      player2Name: freezed == player2Name
          ? _value.player2Name
          : player2Name // ignore: cast_nullable_to_non_nullable
              as String?,
      courtId: freezed == courtId
          ? _value.courtId
          : courtId // ignore: cast_nullable_to_non_nullable
              as String?,
      seasonId: freezed == seasonId
          ? _value.seasonId
          : seasonId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as MatchResult?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchImpl implements _Match {
  const _$MatchImpl(
      {required this.id,
      required this.player1Id,
      required this.player2Id,
      required this.scheduledAt,
      this.status = MatchStatus.proposed,
      this.player1Name,
      this.player2Name,
      this.courtId,
      this.seasonId,
      this.notes,
      this.result,
      this.completedAt,
      required this.createdAt,
      required this.updatedAt,
      final List<String> participants = const []})
      : _participants = participants;

  factory _$MatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchImplFromJson(json);

  @override
  final String id;
  @override
  final String player1Id;
  @override
  final String player2Id;
  @override
  final DateTime scheduledAt;
  @override
  @JsonKey()
  final MatchStatus status;
  @override
  final String? player1Name;
  @override
  final String? player2Name;
  @override
  final String? courtId;
  @override
  final String? seasonId;
  @override
  final String? notes;
  @override
  final MatchResult? result;
  @override
  final DateTime? completedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<String> _participants;
  @override
  @JsonKey()
  List<String> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  String toString() {
    return 'Match(id: $id, player1Id: $player1Id, player2Id: $player2Id, scheduledAt: $scheduledAt, status: $status, player1Name: $player1Name, player2Name: $player2Name, courtId: $courtId, seasonId: $seasonId, notes: $notes, result: $result, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt, participants: $participants)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.player1Id, player1Id) ||
                other.player1Id == player1Id) &&
            (identical(other.player2Id, player2Id) ||
                other.player2Id == player2Id) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.player1Name, player1Name) ||
                other.player1Name == player1Name) &&
            (identical(other.player2Name, player2Name) ||
                other.player2Name == player2Name) &&
            (identical(other.courtId, courtId) || other.courtId == courtId) &&
            (identical(other.seasonId, seasonId) ||
                other.seasonId == seasonId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      player1Id,
      player2Id,
      scheduledAt,
      status,
      player1Name,
      player2Name,
      courtId,
      seasonId,
      notes,
      result,
      completedAt,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_participants));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      __$$MatchImplCopyWithImpl<_$MatchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchImplToJson(
      this,
    );
  }
}

abstract class _Match implements Match {
  const factory _Match(
      {required final String id,
      required final String player1Id,
      required final String player2Id,
      required final DateTime scheduledAt,
      final MatchStatus status,
      final String? player1Name,
      final String? player2Name,
      final String? courtId,
      final String? seasonId,
      final String? notes,
      final MatchResult? result,
      final DateTime? completedAt,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final List<String> participants}) = _$MatchImpl;

  factory _Match.fromJson(Map<String, dynamic> json) = _$MatchImpl.fromJson;

  @override
  String get id;
  @override
  String get player1Id;
  @override
  String get player2Id;
  @override
  DateTime get scheduledAt;
  @override
  MatchStatus get status;
  @override
  String? get player1Name;
  @override
  String? get player2Name;
  @override
  String? get courtId;
  @override
  String? get seasonId;
  @override
  String? get notes;
  @override
  MatchResult? get result;
  @override
  DateTime? get completedAt;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  List<String> get participants;
  @override
  @JsonKey(ignore: true)
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatchResult _$MatchResultFromJson(Map<String, dynamic> json) {
  return _MatchResult.fromJson(json);
}

/// @nodoc
mixin _$MatchResult {
  String get winnerId => throw _privateConstructorUsedError;
  String get loserId => throw _privateConstructorUsedError;
  List<Set> get sets => throw _privateConstructorUsedError;
  int get player1Games => throw _privateConstructorUsedError;
  int get player2Games => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  MatchFormat get format => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MatchResultCopyWith<MatchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchResultCopyWith<$Res> {
  factory $MatchResultCopyWith(
          MatchResult value, $Res Function(MatchResult) then) =
      _$MatchResultCopyWithImpl<$Res, MatchResult>;
  @useResult
  $Res call(
      {String winnerId,
      String loserId,
      List<Set> sets,
      int player1Games,
      int player2Games,
      String? notes,
      MatchFormat format});
}

/// @nodoc
class _$MatchResultCopyWithImpl<$Res, $Val extends MatchResult>
    implements $MatchResultCopyWith<$Res> {
  _$MatchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? winnerId = null,
    Object? loserId = null,
    Object? sets = null,
    Object? player1Games = null,
    Object? player2Games = null,
    Object? notes = freezed,
    Object? format = null,
  }) {
    return _then(_value.copyWith(
      winnerId: null == winnerId
          ? _value.winnerId
          : winnerId // ignore: cast_nullable_to_non_nullable
              as String,
      loserId: null == loserId
          ? _value.loserId
          : loserId // ignore: cast_nullable_to_non_nullable
              as String,
      sets: null == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<Set>,
      player1Games: null == player1Games
          ? _value.player1Games
          : player1Games // ignore: cast_nullable_to_non_nullable
              as int,
      player2Games: null == player2Games
          ? _value.player2Games
          : player2Games // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as MatchFormat,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MatchResultImplCopyWith<$Res>
    implements $MatchResultCopyWith<$Res> {
  factory _$$MatchResultImplCopyWith(
          _$MatchResultImpl value, $Res Function(_$MatchResultImpl) then) =
      __$$MatchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String winnerId,
      String loserId,
      List<Set> sets,
      int player1Games,
      int player2Games,
      String? notes,
      MatchFormat format});
}

/// @nodoc
class __$$MatchResultImplCopyWithImpl<$Res>
    extends _$MatchResultCopyWithImpl<$Res, _$MatchResultImpl>
    implements _$$MatchResultImplCopyWith<$Res> {
  __$$MatchResultImplCopyWithImpl(
      _$MatchResultImpl _value, $Res Function(_$MatchResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? winnerId = null,
    Object? loserId = null,
    Object? sets = null,
    Object? player1Games = null,
    Object? player2Games = null,
    Object? notes = freezed,
    Object? format = null,
  }) {
    return _then(_$MatchResultImpl(
      winnerId: null == winnerId
          ? _value.winnerId
          : winnerId // ignore: cast_nullable_to_non_nullable
              as String,
      loserId: null == loserId
          ? _value.loserId
          : loserId // ignore: cast_nullable_to_non_nullable
              as String,
      sets: null == sets
          ? _value._sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<Set>,
      player1Games: null == player1Games
          ? _value.player1Games
          : player1Games // ignore: cast_nullable_to_non_nullable
              as int,
      player2Games: null == player2Games
          ? _value.player2Games
          : player2Games // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as MatchFormat,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchResultImpl implements _MatchResult {
  const _$MatchResultImpl(
      {required this.winnerId,
      required this.loserId,
      required final List<Set> sets,
      this.player1Games = 0,
      this.player2Games = 0,
      this.notes,
      this.format = MatchFormat.bestOfThree})
      : _sets = sets;

  factory _$MatchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchResultImplFromJson(json);

  @override
  final String winnerId;
  @override
  final String loserId;
  final List<Set> _sets;
  @override
  List<Set> get sets {
    if (_sets is EqualUnmodifiableListView) return _sets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sets);
  }

  @override
  @JsonKey()
  final int player1Games;
  @override
  @JsonKey()
  final int player2Games;
  @override
  final String? notes;
  @override
  @JsonKey()
  final MatchFormat format;

  @override
  String toString() {
    return 'MatchResult(winnerId: $winnerId, loserId: $loserId, sets: $sets, player1Games: $player1Games, player2Games: $player2Games, notes: $notes, format: $format)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchResultImpl &&
            (identical(other.winnerId, winnerId) ||
                other.winnerId == winnerId) &&
            (identical(other.loserId, loserId) || other.loserId == loserId) &&
            const DeepCollectionEquality().equals(other._sets, _sets) &&
            (identical(other.player1Games, player1Games) ||
                other.player1Games == player1Games) &&
            (identical(other.player2Games, player2Games) ||
                other.player2Games == player2Games) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.format, format) || other.format == format));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      winnerId,
      loserId,
      const DeepCollectionEquality().hash(_sets),
      player1Games,
      player2Games,
      notes,
      format);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchResultImplCopyWith<_$MatchResultImpl> get copyWith =>
      __$$MatchResultImplCopyWithImpl<_$MatchResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchResultImplToJson(
      this,
    );
  }
}

abstract class _MatchResult implements MatchResult {
  const factory _MatchResult(
      {required final String winnerId,
      required final String loserId,
      required final List<Set> sets,
      final int player1Games,
      final int player2Games,
      final String? notes,
      final MatchFormat format}) = _$MatchResultImpl;

  factory _MatchResult.fromJson(Map<String, dynamic> json) =
      _$MatchResultImpl.fromJson;

  @override
  String get winnerId;
  @override
  String get loserId;
  @override
  List<Set> get sets;
  @override
  int get player1Games;
  @override
  int get player2Games;
  @override
  String? get notes;
  @override
  MatchFormat get format;
  @override
  @JsonKey(ignore: true)
  _$$MatchResultImplCopyWith<_$MatchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Set _$SetFromJson(Map<String, dynamic> json) {
  return _Set.fromJson(json);
}

/// @nodoc
mixin _$Set {
  int get player1Games => throw _privateConstructorUsedError;
  int get player2Games => throw _privateConstructorUsedError;
  Tiebreak? get tiebreak => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SetCopyWith<Set> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetCopyWith<$Res> {
  factory $SetCopyWith(Set value, $Res Function(Set) then) =
      _$SetCopyWithImpl<$Res, Set>;
  @useResult
  $Res call(
      {int player1Games,
      int player2Games,
      Tiebreak? tiebreak,
      bool isCompleted});

  $TiebreakCopyWith<$Res>? get tiebreak;
}

/// @nodoc
class _$SetCopyWithImpl<$Res, $Val extends Set> implements $SetCopyWith<$Res> {
  _$SetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player1Games = null,
    Object? player2Games = null,
    Object? tiebreak = freezed,
    Object? isCompleted = null,
  }) {
    return _then(_value.copyWith(
      player1Games: null == player1Games
          ? _value.player1Games
          : player1Games // ignore: cast_nullable_to_non_nullable
              as int,
      player2Games: null == player2Games
          ? _value.player2Games
          : player2Games // ignore: cast_nullable_to_non_nullable
              as int,
      tiebreak: freezed == tiebreak
          ? _value.tiebreak
          : tiebreak // ignore: cast_nullable_to_non_nullable
              as Tiebreak?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TiebreakCopyWith<$Res>? get tiebreak {
    if (_value.tiebreak == null) {
      return null;
    }

    return $TiebreakCopyWith<$Res>(_value.tiebreak!, (value) {
      return _then(_value.copyWith(tiebreak: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SetImplCopyWith<$Res> implements $SetCopyWith<$Res> {
  factory _$$SetImplCopyWith(_$SetImpl value, $Res Function(_$SetImpl) then) =
      __$$SetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int player1Games,
      int player2Games,
      Tiebreak? tiebreak,
      bool isCompleted});

  @override
  $TiebreakCopyWith<$Res>? get tiebreak;
}

/// @nodoc
class __$$SetImplCopyWithImpl<$Res> extends _$SetCopyWithImpl<$Res, _$SetImpl>
    implements _$$SetImplCopyWith<$Res> {
  __$$SetImplCopyWithImpl(_$SetImpl _value, $Res Function(_$SetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player1Games = null,
    Object? player2Games = null,
    Object? tiebreak = freezed,
    Object? isCompleted = null,
  }) {
    return _then(_$SetImpl(
      player1Games: null == player1Games
          ? _value.player1Games
          : player1Games // ignore: cast_nullable_to_non_nullable
              as int,
      player2Games: null == player2Games
          ? _value.player2Games
          : player2Games // ignore: cast_nullable_to_non_nullable
              as int,
      tiebreak: freezed == tiebreak
          ? _value.tiebreak
          : tiebreak // ignore: cast_nullable_to_non_nullable
              as Tiebreak?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SetImpl implements _Set {
  const _$SetImpl(
      {this.player1Games = 0,
      this.player2Games = 0,
      this.tiebreak,
      this.isCompleted = false});

  factory _$SetImpl.fromJson(Map<String, dynamic> json) =>
      _$$SetImplFromJson(json);

  @override
  @JsonKey()
  final int player1Games;
  @override
  @JsonKey()
  final int player2Games;
  @override
  final Tiebreak? tiebreak;
  @override
  @JsonKey()
  final bool isCompleted;

  @override
  String toString() {
    return 'Set(player1Games: $player1Games, player2Games: $player2Games, tiebreak: $tiebreak, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetImpl &&
            (identical(other.player1Games, player1Games) ||
                other.player1Games == player1Games) &&
            (identical(other.player2Games, player2Games) ||
                other.player2Games == player2Games) &&
            (identical(other.tiebreak, tiebreak) ||
                other.tiebreak == tiebreak) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, player1Games, player2Games, tiebreak, isCompleted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SetImplCopyWith<_$SetImpl> get copyWith =>
      __$$SetImplCopyWithImpl<_$SetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetImplToJson(
      this,
    );
  }
}

abstract class _Set implements Set {
  const factory _Set(
      {final int player1Games,
      final int player2Games,
      final Tiebreak? tiebreak,
      final bool isCompleted}) = _$SetImpl;

  factory _Set.fromJson(Map<String, dynamic> json) = _$SetImpl.fromJson;

  @override
  int get player1Games;
  @override
  int get player2Games;
  @override
  Tiebreak? get tiebreak;
  @override
  bool get isCompleted;
  @override
  @JsonKey(ignore: true)
  _$$SetImplCopyWith<_$SetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Tiebreak _$TiebreakFromJson(Map<String, dynamic> json) {
  return _Tiebreak.fromJson(json);
}

/// @nodoc
mixin _$Tiebreak {
  int get player1Points => throw _privateConstructorUsedError;
  int get player2Points => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TiebreakCopyWith<Tiebreak> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TiebreakCopyWith<$Res> {
  factory $TiebreakCopyWith(Tiebreak value, $Res Function(Tiebreak) then) =
      _$TiebreakCopyWithImpl<$Res, Tiebreak>;
  @useResult
  $Res call({int player1Points, int player2Points});
}

/// @nodoc
class _$TiebreakCopyWithImpl<$Res, $Val extends Tiebreak>
    implements $TiebreakCopyWith<$Res> {
  _$TiebreakCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player1Points = null,
    Object? player2Points = null,
  }) {
    return _then(_value.copyWith(
      player1Points: null == player1Points
          ? _value.player1Points
          : player1Points // ignore: cast_nullable_to_non_nullable
              as int,
      player2Points: null == player2Points
          ? _value.player2Points
          : player2Points // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TiebreakImplCopyWith<$Res>
    implements $TiebreakCopyWith<$Res> {
  factory _$$TiebreakImplCopyWith(
          _$TiebreakImpl value, $Res Function(_$TiebreakImpl) then) =
      __$$TiebreakImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int player1Points, int player2Points});
}

/// @nodoc
class __$$TiebreakImplCopyWithImpl<$Res>
    extends _$TiebreakCopyWithImpl<$Res, _$TiebreakImpl>
    implements _$$TiebreakImplCopyWith<$Res> {
  __$$TiebreakImplCopyWithImpl(
      _$TiebreakImpl _value, $Res Function(_$TiebreakImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player1Points = null,
    Object? player2Points = null,
  }) {
    return _then(_$TiebreakImpl(
      player1Points: null == player1Points
          ? _value.player1Points
          : player1Points // ignore: cast_nullable_to_non_nullable
              as int,
      player2Points: null == player2Points
          ? _value.player2Points
          : player2Points // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TiebreakImpl implements _Tiebreak {
  const _$TiebreakImpl({this.player1Points = 0, this.player2Points = 0});

  factory _$TiebreakImpl.fromJson(Map<String, dynamic> json) =>
      _$$TiebreakImplFromJson(json);

  @override
  @JsonKey()
  final int player1Points;
  @override
  @JsonKey()
  final int player2Points;

  @override
  String toString() {
    return 'Tiebreak(player1Points: $player1Points, player2Points: $player2Points)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TiebreakImpl &&
            (identical(other.player1Points, player1Points) ||
                other.player1Points == player1Points) &&
            (identical(other.player2Points, player2Points) ||
                other.player2Points == player2Points));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, player1Points, player2Points);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TiebreakImplCopyWith<_$TiebreakImpl> get copyWith =>
      __$$TiebreakImplCopyWithImpl<_$TiebreakImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TiebreakImplToJson(
      this,
    );
  }
}

abstract class _Tiebreak implements Tiebreak {
  const factory _Tiebreak({final int player1Points, final int player2Points}) =
      _$TiebreakImpl;

  factory _Tiebreak.fromJson(Map<String, dynamic> json) =
      _$TiebreakImpl.fromJson;

  @override
  int get player1Points;
  @override
  int get player2Points;
  @override
  @JsonKey(ignore: true)
  _$$TiebreakImplCopyWith<_$TiebreakImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
