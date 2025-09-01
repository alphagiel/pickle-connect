// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ladder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LadderEntry _$LadderEntryFromJson(Map<String, dynamic> json) {
  return _LadderEntry.fromJson(json);
}

/// @nodoc
mixin _$LadderEntry {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get seasonId => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get wins => throw _privateConstructorUsedError;
  int get losses => throw _privateConstructorUsedError;
  int? get previousRank => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LadderEntryCopyWith<LadderEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LadderEntryCopyWith<$Res> {
  factory $LadderEntryCopyWith(
          LadderEntry value, $Res Function(LadderEntry) then) =
      _$LadderEntryCopyWithImpl<$Res, LadderEntry>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String seasonId,
      int rank,
      double rating,
      int wins,
      int losses,
      int? previousRank,
      DateTime? lastUpdated});
}

/// @nodoc
class _$LadderEntryCopyWithImpl<$Res, $Val extends LadderEntry>
    implements $LadderEntryCopyWith<$Res> {
  _$LadderEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? seasonId = null,
    Object? rank = null,
    Object? rating = null,
    Object? wins = null,
    Object? losses = null,
    Object? previousRank = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      seasonId: null == seasonId
          ? _value.seasonId
          : seasonId // ignore: cast_nullable_to_non_nullable
              as String,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      wins: null == wins
          ? _value.wins
          : wins // ignore: cast_nullable_to_non_nullable
              as int,
      losses: null == losses
          ? _value.losses
          : losses // ignore: cast_nullable_to_non_nullable
              as int,
      previousRank: freezed == previousRank
          ? _value.previousRank
          : previousRank // ignore: cast_nullable_to_non_nullable
              as int?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LadderEntryImplCopyWith<$Res>
    implements $LadderEntryCopyWith<$Res> {
  factory _$$LadderEntryImplCopyWith(
          _$LadderEntryImpl value, $Res Function(_$LadderEntryImpl) then) =
      __$$LadderEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String seasonId,
      int rank,
      double rating,
      int wins,
      int losses,
      int? previousRank,
      DateTime? lastUpdated});
}

/// @nodoc
class __$$LadderEntryImplCopyWithImpl<$Res>
    extends _$LadderEntryCopyWithImpl<$Res, _$LadderEntryImpl>
    implements _$$LadderEntryImplCopyWith<$Res> {
  __$$LadderEntryImplCopyWithImpl(
      _$LadderEntryImpl _value, $Res Function(_$LadderEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? seasonId = null,
    Object? rank = null,
    Object? rating = null,
    Object? wins = null,
    Object? losses = null,
    Object? previousRank = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_$LadderEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      seasonId: null == seasonId
          ? _value.seasonId
          : seasonId // ignore: cast_nullable_to_non_nullable
              as String,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      wins: null == wins
          ? _value.wins
          : wins // ignore: cast_nullable_to_non_nullable
              as int,
      losses: null == losses
          ? _value.losses
          : losses // ignore: cast_nullable_to_non_nullable
              as int,
      previousRank: freezed == previousRank
          ? _value.previousRank
          : previousRank // ignore: cast_nullable_to_non_nullable
              as int?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LadderEntryImpl implements _LadderEntry {
  const _$LadderEntryImpl(
      {required this.id,
      required this.userId,
      required this.seasonId,
      required this.rank,
      required this.rating,
      required this.wins,
      required this.losses,
      this.previousRank,
      this.lastUpdated});

  factory _$LadderEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$LadderEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String seasonId;
  @override
  final int rank;
  @override
  final double rating;
  @override
  final int wins;
  @override
  final int losses;
  @override
  final int? previousRank;
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'LadderEntry(id: $id, userId: $userId, seasonId: $seasonId, rank: $rank, rating: $rating, wins: $wins, losses: $losses, previousRank: $previousRank, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LadderEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.seasonId, seasonId) ||
                other.seasonId == seasonId) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.wins, wins) || other.wins == wins) &&
            (identical(other.losses, losses) || other.losses == losses) &&
            (identical(other.previousRank, previousRank) ||
                other.previousRank == previousRank) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, seasonId, rank,
      rating, wins, losses, previousRank, lastUpdated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LadderEntryImplCopyWith<_$LadderEntryImpl> get copyWith =>
      __$$LadderEntryImplCopyWithImpl<_$LadderEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LadderEntryImplToJson(
      this,
    );
  }
}

abstract class _LadderEntry implements LadderEntry {
  const factory _LadderEntry(
      {required final String id,
      required final String userId,
      required final String seasonId,
      required final int rank,
      required final double rating,
      required final int wins,
      required final int losses,
      final int? previousRank,
      final DateTime? lastUpdated}) = _$LadderEntryImpl;

  factory _LadderEntry.fromJson(Map<String, dynamic> json) =
      _$LadderEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get seasonId;
  @override
  int get rank;
  @override
  double get rating;
  @override
  int get wins;
  @override
  int get losses;
  @override
  int? get previousRank;
  @override
  DateTime? get lastUpdated;
  @override
  @JsonKey(ignore: true)
  _$$LadderEntryImplCopyWith<_$LadderEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Season _$SeasonFromJson(Map<String, dynamic> json) {
  return _Season.fromJson(json);
}

/// @nodoc
mixin _$Season {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  SeasonStatus get status => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SeasonCopyWith<Season> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SeasonCopyWith<$Res> {
  factory $SeasonCopyWith(Season value, $Res Function(Season) then) =
      _$SeasonCopyWithImpl<$Res, Season>;
  @useResult
  $Res call(
      {String id,
      String name,
      DateTime startDate,
      DateTime endDate,
      SeasonStatus status,
      String? description});
}

/// @nodoc
class _$SeasonCopyWithImpl<$Res, $Val extends Season>
    implements $SeasonCopyWith<$Res> {
  _$SeasonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? status = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SeasonStatus,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SeasonImplCopyWith<$Res> implements $SeasonCopyWith<$Res> {
  factory _$$SeasonImplCopyWith(
          _$SeasonImpl value, $Res Function(_$SeasonImpl) then) =
      __$$SeasonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      DateTime startDate,
      DateTime endDate,
      SeasonStatus status,
      String? description});
}

/// @nodoc
class __$$SeasonImplCopyWithImpl<$Res>
    extends _$SeasonCopyWithImpl<$Res, _$SeasonImpl>
    implements _$$SeasonImplCopyWith<$Res> {
  __$$SeasonImplCopyWithImpl(
      _$SeasonImpl _value, $Res Function(_$SeasonImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? status = null,
    Object? description = freezed,
  }) {
    return _then(_$SeasonImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SeasonStatus,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SeasonImpl implements _Season {
  const _$SeasonImpl(
      {required this.id,
      required this.name,
      required this.startDate,
      required this.endDate,
      this.status = SeasonStatus.upcoming,
      this.description});

  factory _$SeasonImpl.fromJson(Map<String, dynamic> json) =>
      _$$SeasonImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  @JsonKey()
  final SeasonStatus status;
  @override
  final String? description;

  @override
  String toString() {
    return 'Season(id: $id, name: $name, startDate: $startDate, endDate: $endDate, status: $status, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SeasonImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, startDate, endDate, status, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SeasonImplCopyWith<_$SeasonImpl> get copyWith =>
      __$$SeasonImplCopyWithImpl<_$SeasonImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SeasonImplToJson(
      this,
    );
  }
}

abstract class _Season implements Season {
  const factory _Season(
      {required final String id,
      required final String name,
      required final DateTime startDate,
      required final DateTime endDate,
      final SeasonStatus status,
      final String? description}) = _$SeasonImpl;

  factory _Season.fromJson(Map<String, dynamic> json) = _$SeasonImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  SeasonStatus get status;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$SeasonImplCopyWith<_$SeasonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Match _$MatchFromJson(Map<String, dynamic> json) {
  return _Match.fromJson(json);
}

/// @nodoc
mixin _$Match {
  String get id => throw _privateConstructorUsedError;
  String get player1Id => throw _privateConstructorUsedError;
  String get player2Id => throw _privateConstructorUsedError;
  DateTime get scheduledAt => throw _privateConstructorUsedError;
  MatchResult? get result => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  MatchStatus get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

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
      MatchResult? result,
      String? notes,
      MatchStatus status,
      DateTime? createdAt});

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
    Object? result = freezed,
    Object? notes = freezed,
    Object? status = null,
    Object? createdAt = freezed,
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
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as MatchResult?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MatchStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      MatchResult? result,
      String? notes,
      MatchStatus status,
      DateTime? createdAt});

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
    Object? result = freezed,
    Object? notes = freezed,
    Object? status = null,
    Object? createdAt = freezed,
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
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as MatchResult?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MatchStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      this.result,
      this.notes,
      this.status = MatchStatus.scheduled,
      this.createdAt});

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
  final MatchResult? result;
  @override
  final String? notes;
  @override
  @JsonKey()
  final MatchStatus status;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Match(id: $id, player1Id: $player1Id, player2Id: $player2Id, scheduledAt: $scheduledAt, result: $result, notes: $notes, status: $status, createdAt: $createdAt)';
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
            (identical(other.result, result) || other.result == result) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, player1Id, player2Id,
      scheduledAt, result, notes, status, createdAt);

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
      final MatchResult? result,
      final String? notes,
      final MatchStatus status,
      final DateTime? createdAt}) = _$MatchImpl;

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
  MatchResult? get result;
  @override
  String? get notes;
  @override
  MatchStatus get status;
  @override
  DateTime? get createdAt;
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
  DateTime? get completedAt => throw _privateConstructorUsedError;

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
      {String winnerId, String loserId, List<Set> sets, DateTime? completedAt});
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
    Object? completedAt = freezed,
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
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      {String winnerId, String loserId, List<Set> sets, DateTime? completedAt});
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
    Object? completedAt = freezed,
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
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      this.completedAt})
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
  final DateTime? completedAt;

  @override
  String toString() {
    return 'MatchResult(winnerId: $winnerId, loserId: $loserId, sets: $sets, completedAt: $completedAt)';
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
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, winnerId, loserId,
      const DeepCollectionEquality().hash(_sets), completedAt);

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
      final DateTime? completedAt}) = _$MatchResultImpl;

  factory _MatchResult.fromJson(Map<String, dynamic> json) =
      _$MatchResultImpl.fromJson;

  @override
  String get winnerId;
  @override
  String get loserId;
  @override
  List<Set> get sets;
  @override
  DateTime? get completedAt;
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
  int get player1Score => throw _privateConstructorUsedError;
  int get player2Score => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SetCopyWith<Set> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetCopyWith<$Res> {
  factory $SetCopyWith(Set value, $Res Function(Set) then) =
      _$SetCopyWithImpl<$Res, Set>;
  @useResult
  $Res call({int player1Score, int player2Score});
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
    Object? player1Score = null,
    Object? player2Score = null,
  }) {
    return _then(_value.copyWith(
      player1Score: null == player1Score
          ? _value.player1Score
          : player1Score // ignore: cast_nullable_to_non_nullable
              as int,
      player2Score: null == player2Score
          ? _value.player2Score
          : player2Score // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SetImplCopyWith<$Res> implements $SetCopyWith<$Res> {
  factory _$$SetImplCopyWith(_$SetImpl value, $Res Function(_$SetImpl) then) =
      __$$SetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int player1Score, int player2Score});
}

/// @nodoc
class __$$SetImplCopyWithImpl<$Res> extends _$SetCopyWithImpl<$Res, _$SetImpl>
    implements _$$SetImplCopyWith<$Res> {
  __$$SetImplCopyWithImpl(_$SetImpl _value, $Res Function(_$SetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player1Score = null,
    Object? player2Score = null,
  }) {
    return _then(_$SetImpl(
      player1Score: null == player1Score
          ? _value.player1Score
          : player1Score // ignore: cast_nullable_to_non_nullable
              as int,
      player2Score: null == player2Score
          ? _value.player2Score
          : player2Score // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SetImpl implements _Set {
  const _$SetImpl({required this.player1Score, required this.player2Score});

  factory _$SetImpl.fromJson(Map<String, dynamic> json) =>
      _$$SetImplFromJson(json);

  @override
  final int player1Score;
  @override
  final int player2Score;

  @override
  String toString() {
    return 'Set(player1Score: $player1Score, player2Score: $player2Score)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetImpl &&
            (identical(other.player1Score, player1Score) ||
                other.player1Score == player1Score) &&
            (identical(other.player2Score, player2Score) ||
                other.player2Score == player2Score));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, player1Score, player2Score);

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
      {required final int player1Score,
      required final int player2Score}) = _$SetImpl;

  factory _Set.fromJson(Map<String, dynamic> json) = _$SetImpl.fromJson;

  @override
  int get player1Score;
  @override
  int get player2Score;
  @override
  @JsonKey(ignore: true)
  _$$SetImplCopyWith<_$SetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
