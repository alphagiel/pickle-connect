// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'proposal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AcceptedBy _$AcceptedByFromJson(Map<String, dynamic> json) {
  return _AcceptedBy.fromJson(json);
}

/// @nodoc
mixin _$AcceptedBy {
  String get userId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AcceptedByCopyWith<AcceptedBy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AcceptedByCopyWith<$Res> {
  factory $AcceptedByCopyWith(
          AcceptedBy value, $Res Function(AcceptedBy) then) =
      _$AcceptedByCopyWithImpl<$Res, AcceptedBy>;
  @useResult
  $Res call({String userId, String displayName});
}

/// @nodoc
class _$AcceptedByCopyWithImpl<$Res, $Val extends AcceptedBy>
    implements $AcceptedByCopyWith<$Res> {
  _$AcceptedByCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AcceptedByImplCopyWith<$Res>
    implements $AcceptedByCopyWith<$Res> {
  factory _$$AcceptedByImplCopyWith(
          _$AcceptedByImpl value, $Res Function(_$AcceptedByImpl) then) =
      __$$AcceptedByImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, String displayName});
}

/// @nodoc
class __$$AcceptedByImplCopyWithImpl<$Res>
    extends _$AcceptedByCopyWithImpl<$Res, _$AcceptedByImpl>
    implements _$$AcceptedByImplCopyWith<$Res> {
  __$$AcceptedByImplCopyWithImpl(
      _$AcceptedByImpl _value, $Res Function(_$AcceptedByImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
  }) {
    return _then(_$AcceptedByImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AcceptedByImpl implements _AcceptedBy {
  const _$AcceptedByImpl({required this.userId, required this.displayName});

  factory _$AcceptedByImpl.fromJson(Map<String, dynamic> json) =>
      _$$AcceptedByImplFromJson(json);

  @override
  final String userId;
  @override
  final String displayName;

  @override
  String toString() {
    return 'AcceptedBy(userId: $userId, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AcceptedByImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, displayName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AcceptedByImplCopyWith<_$AcceptedByImpl> get copyWith =>
      __$$AcceptedByImplCopyWithImpl<_$AcceptedByImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AcceptedByImplToJson(
      this,
    );
  }
}

abstract class _AcceptedBy implements AcceptedBy {
  const factory _AcceptedBy(
      {required final String userId,
      required final String displayName}) = _$AcceptedByImpl;

  factory _AcceptedBy.fromJson(Map<String, dynamic> json) =
      _$AcceptedByImpl.fromJson;

  @override
  String get userId;
  @override
  String get displayName;
  @override
  @JsonKey(ignore: true)
  _$$AcceptedByImplCopyWith<_$AcceptedByImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DoublesPlayer _$DoublesPlayerFromJson(Map<String, dynamic> json) {
  return _DoublesPlayer.fromJson(json);
}

/// @nodoc
mixin _$DoublesPlayer {
  String get userId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  int? get team => throw _privateConstructorUsedError;
  DoublesPlayerStatus get status => throw _privateConstructorUsedError;
  String? get invitedBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DoublesPlayerCopyWith<DoublesPlayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DoublesPlayerCopyWith<$Res> {
  factory $DoublesPlayerCopyWith(
          DoublesPlayer value, $Res Function(DoublesPlayer) then) =
      _$DoublesPlayerCopyWithImpl<$Res, DoublesPlayer>;
  @useResult
  $Res call(
      {String userId,
      String displayName,
      int? team,
      DoublesPlayerStatus status,
      String? invitedBy});
}

/// @nodoc
class _$DoublesPlayerCopyWithImpl<$Res, $Val extends DoublesPlayer>
    implements $DoublesPlayerCopyWith<$Res> {
  _$DoublesPlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? team = freezed,
    Object? status = null,
    Object? invitedBy = freezed,
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
      team: freezed == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DoublesPlayerStatus,
      invitedBy: freezed == invitedBy
          ? _value.invitedBy
          : invitedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DoublesPlayerImplCopyWith<$Res>
    implements $DoublesPlayerCopyWith<$Res> {
  factory _$$DoublesPlayerImplCopyWith(
          _$DoublesPlayerImpl value, $Res Function(_$DoublesPlayerImpl) then) =
      __$$DoublesPlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String displayName,
      int? team,
      DoublesPlayerStatus status,
      String? invitedBy});
}

/// @nodoc
class __$$DoublesPlayerImplCopyWithImpl<$Res>
    extends _$DoublesPlayerCopyWithImpl<$Res, _$DoublesPlayerImpl>
    implements _$$DoublesPlayerImplCopyWith<$Res> {
  __$$DoublesPlayerImplCopyWithImpl(
      _$DoublesPlayerImpl _value, $Res Function(_$DoublesPlayerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? team = freezed,
    Object? status = null,
    Object? invitedBy = freezed,
  }) {
    return _then(_$DoublesPlayerImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      team: freezed == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DoublesPlayerStatus,
      invitedBy: freezed == invitedBy
          ? _value.invitedBy
          : invitedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DoublesPlayerImpl implements _DoublesPlayer {
  const _$DoublesPlayerImpl(
      {required this.userId,
      required this.displayName,
      this.team,
      this.status = DoublesPlayerStatus.requested,
      this.invitedBy});

  factory _$DoublesPlayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$DoublesPlayerImplFromJson(json);

  @override
  final String userId;
  @override
  final String displayName;
  @override
  final int? team;
  @override
  @JsonKey()
  final DoublesPlayerStatus status;
  @override
  final String? invitedBy;

  @override
  String toString() {
    return 'DoublesPlayer(userId: $userId, displayName: $displayName, team: $team, status: $status, invitedBy: $invitedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoublesPlayerImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.invitedBy, invitedBy) ||
                other.invitedBy == invitedBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, displayName, team, status, invitedBy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DoublesPlayerImplCopyWith<_$DoublesPlayerImpl> get copyWith =>
      __$$DoublesPlayerImplCopyWithImpl<_$DoublesPlayerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DoublesPlayerImplToJson(
      this,
    );
  }
}

abstract class _DoublesPlayer implements DoublesPlayer {
  const factory _DoublesPlayer(
      {required final String userId,
      required final String displayName,
      final int? team,
      final DoublesPlayerStatus status,
      final String? invitedBy}) = _$DoublesPlayerImpl;

  factory _DoublesPlayer.fromJson(Map<String, dynamic> json) =
      _$DoublesPlayerImpl.fromJson;

  @override
  String get userId;
  @override
  String get displayName;
  @override
  int? get team;
  @override
  DoublesPlayerStatus get status;
  @override
  String? get invitedBy;
  @override
  @JsonKey(ignore: true)
  _$$DoublesPlayerImplCopyWith<_$DoublesPlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GameScore _$GameScoreFromJson(Map<String, dynamic> json) {
  return _GameScore.fromJson(json);
}

/// @nodoc
mixin _$GameScore {
  int get creatorScore => throw _privateConstructorUsedError;
  int get opponentScore => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GameScoreCopyWith<GameScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameScoreCopyWith<$Res> {
  factory $GameScoreCopyWith(GameScore value, $Res Function(GameScore) then) =
      _$GameScoreCopyWithImpl<$Res, GameScore>;
  @useResult
  $Res call({int creatorScore, int opponentScore});
}

/// @nodoc
class _$GameScoreCopyWithImpl<$Res, $Val extends GameScore>
    implements $GameScoreCopyWith<$Res> {
  _$GameScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? creatorScore = null,
    Object? opponentScore = null,
  }) {
    return _then(_value.copyWith(
      creatorScore: null == creatorScore
          ? _value.creatorScore
          : creatorScore // ignore: cast_nullable_to_non_nullable
              as int,
      opponentScore: null == opponentScore
          ? _value.opponentScore
          : opponentScore // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameScoreImplCopyWith<$Res>
    implements $GameScoreCopyWith<$Res> {
  factory _$$GameScoreImplCopyWith(
          _$GameScoreImpl value, $Res Function(_$GameScoreImpl) then) =
      __$$GameScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int creatorScore, int opponentScore});
}

/// @nodoc
class __$$GameScoreImplCopyWithImpl<$Res>
    extends _$GameScoreCopyWithImpl<$Res, _$GameScoreImpl>
    implements _$$GameScoreImplCopyWith<$Res> {
  __$$GameScoreImplCopyWithImpl(
      _$GameScoreImpl _value, $Res Function(_$GameScoreImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? creatorScore = null,
    Object? opponentScore = null,
  }) {
    return _then(_$GameScoreImpl(
      creatorScore: null == creatorScore
          ? _value.creatorScore
          : creatorScore // ignore: cast_nullable_to_non_nullable
              as int,
      opponentScore: null == opponentScore
          ? _value.opponentScore
          : opponentScore // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameScoreImpl implements _GameScore {
  const _$GameScoreImpl(
      {required this.creatorScore, required this.opponentScore});

  factory _$GameScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameScoreImplFromJson(json);

  @override
  final int creatorScore;
  @override
  final int opponentScore;

  @override
  String toString() {
    return 'GameScore(creatorScore: $creatorScore, opponentScore: $opponentScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameScoreImpl &&
            (identical(other.creatorScore, creatorScore) ||
                other.creatorScore == creatorScore) &&
            (identical(other.opponentScore, opponentScore) ||
                other.opponentScore == opponentScore));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, creatorScore, opponentScore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GameScoreImplCopyWith<_$GameScoreImpl> get copyWith =>
      __$$GameScoreImplCopyWithImpl<_$GameScoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameScoreImplToJson(
      this,
    );
  }
}

abstract class _GameScore implements GameScore {
  const factory _GameScore(
      {required final int creatorScore,
      required final int opponentScore}) = _$GameScoreImpl;

  factory _GameScore.fromJson(Map<String, dynamic> json) =
      _$GameScoreImpl.fromJson;

  @override
  int get creatorScore;
  @override
  int get opponentScore;
  @override
  @JsonKey(ignore: true)
  _$$GameScoreImplCopyWith<_$GameScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Scores _$ScoresFromJson(Map<String, dynamic> json) {
  return _Scores.fromJson(json);
}

/// @nodoc
mixin _$Scores {
  List<GameScore> get games => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScoresCopyWith<Scores> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoresCopyWith<$Res> {
  factory $ScoresCopyWith(Scores value, $Res Function(Scores) then) =
      _$ScoresCopyWithImpl<$Res, Scores>;
  @useResult
  $Res call({List<GameScore> games});
}

/// @nodoc
class _$ScoresCopyWithImpl<$Res, $Val extends Scores>
    implements $ScoresCopyWith<$Res> {
  _$ScoresCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? games = null,
  }) {
    return _then(_value.copyWith(
      games: null == games
          ? _value.games
          : games // ignore: cast_nullable_to_non_nullable
              as List<GameScore>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScoresImplCopyWith<$Res> implements $ScoresCopyWith<$Res> {
  factory _$$ScoresImplCopyWith(
          _$ScoresImpl value, $Res Function(_$ScoresImpl) then) =
      __$$ScoresImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<GameScore> games});
}

/// @nodoc
class __$$ScoresImplCopyWithImpl<$Res>
    extends _$ScoresCopyWithImpl<$Res, _$ScoresImpl>
    implements _$$ScoresImplCopyWith<$Res> {
  __$$ScoresImplCopyWithImpl(
      _$ScoresImpl _value, $Res Function(_$ScoresImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? games = null,
  }) {
    return _then(_$ScoresImpl(
      games: null == games
          ? _value._games
          : games // ignore: cast_nullable_to_non_nullable
              as List<GameScore>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$ScoresImpl extends _Scores {
  const _$ScoresImpl({required final List<GameScore> games})
      : _games = games,
        super._();

  factory _$ScoresImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScoresImplFromJson(json);

  final List<GameScore> _games;
  @override
  List<GameScore> get games {
    if (_games is EqualUnmodifiableListView) return _games;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_games);
  }

  @override
  String toString() {
    return 'Scores(games: $games)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoresImpl &&
            const DeepCollectionEquality().equals(other._games, _games));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_games));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoresImplCopyWith<_$ScoresImpl> get copyWith =>
      __$$ScoresImplCopyWithImpl<_$ScoresImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScoresImplToJson(
      this,
    );
  }
}

abstract class _Scores extends Scores {
  const factory _Scores({required final List<GameScore> games}) = _$ScoresImpl;
  const _Scores._() : super._();

  factory _Scores.fromJson(Map<String, dynamic> json) = _$ScoresImpl.fromJson;

  @override
  List<GameScore> get games;
  @override
  @JsonKey(ignore: true)
  _$$ScoresImplCopyWith<_$ScoresImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Proposal _$ProposalFromJson(Map<String, dynamic> json) {
  return _Proposal.fromJson(json);
}

/// @nodoc
mixin _$Proposal {
  String get proposalId => throw _privateConstructorUsedError;
  String get creatorId => throw _privateConstructorUsedError;
  String get creatorName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToJson)
  SkillLevel get skillLevel => throw _privateConstructorUsedError;

  /// Bracket for filtering - derived from skillLevel but stored for efficient queries
  @JsonKey(fromJson: _skillBracketFromJson, toJson: _skillBracketToJson)
  SkillBracket get skillBracket => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get dateTime => throw _privateConstructorUsedError;
  ProposalStatus get status => throw _privateConstructorUsedError;
  AcceptedBy? get acceptedBy => throw _privateConstructorUsedError;
  Scores? get scores => throw _privateConstructorUsedError;
  List<String> get scoreConfirmedBy => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Doubles fields
  MatchType get matchType => throw _privateConstructorUsedError;
  List<DoublesPlayer> get doublesPlayers => throw _privateConstructorUsedError;
  int get openSlots => throw _privateConstructorUsedError;

  /// Denormalized list of user IDs for Firestore array-contains queries
  List<String> get playerIds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProposalCopyWith<Proposal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProposalCopyWith<$Res> {
  factory $ProposalCopyWith(Proposal value, $Res Function(Proposal) then) =
      _$ProposalCopyWithImpl<$Res, Proposal>;
  @useResult
  $Res call(
      {String proposalId,
      String creatorId,
      String creatorName,
      @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToJson)
      SkillLevel skillLevel,
      @JsonKey(fromJson: _skillBracketFromJson, toJson: _skillBracketToJson)
      SkillBracket skillBracket,
      String location,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime dateTime,
      ProposalStatus status,
      AcceptedBy? acceptedBy,
      Scores? scores,
      List<String> scoreConfirmedBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime updatedAt,
      MatchType matchType,
      List<DoublesPlayer> doublesPlayers,
      int openSlots,
      List<String> playerIds});

  $AcceptedByCopyWith<$Res>? get acceptedBy;
  $ScoresCopyWith<$Res>? get scores;
}

/// @nodoc
class _$ProposalCopyWithImpl<$Res, $Val extends Proposal>
    implements $ProposalCopyWith<$Res> {
  _$ProposalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? proposalId = null,
    Object? creatorId = null,
    Object? creatorName = null,
    Object? skillLevel = null,
    Object? skillBracket = null,
    Object? location = null,
    Object? dateTime = null,
    Object? status = null,
    Object? acceptedBy = freezed,
    Object? scores = freezed,
    Object? scoreConfirmedBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? matchType = null,
    Object? doublesPlayers = null,
    Object? openSlots = null,
    Object? playerIds = null,
  }) {
    return _then(_value.copyWith(
      proposalId: null == proposalId
          ? _value.proposalId
          : proposalId // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      creatorName: null == creatorName
          ? _value.creatorName
          : creatorName // ignore: cast_nullable_to_non_nullable
              as String,
      skillLevel: null == skillLevel
          ? _value.skillLevel
          : skillLevel // ignore: cast_nullable_to_non_nullable
              as SkillLevel,
      skillBracket: null == skillBracket
          ? _value.skillBracket
          : skillBracket // ignore: cast_nullable_to_non_nullable
              as SkillBracket,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProposalStatus,
      acceptedBy: freezed == acceptedBy
          ? _value.acceptedBy
          : acceptedBy // ignore: cast_nullable_to_non_nullable
              as AcceptedBy?,
      scores: freezed == scores
          ? _value.scores
          : scores // ignore: cast_nullable_to_non_nullable
              as Scores?,
      scoreConfirmedBy: null == scoreConfirmedBy
          ? _value.scoreConfirmedBy
          : scoreConfirmedBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      matchType: null == matchType
          ? _value.matchType
          : matchType // ignore: cast_nullable_to_non_nullable
              as MatchType,
      doublesPlayers: null == doublesPlayers
          ? _value.doublesPlayers
          : doublesPlayers // ignore: cast_nullable_to_non_nullable
              as List<DoublesPlayer>,
      openSlots: null == openSlots
          ? _value.openSlots
          : openSlots // ignore: cast_nullable_to_non_nullable
              as int,
      playerIds: null == playerIds
          ? _value.playerIds
          : playerIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AcceptedByCopyWith<$Res>? get acceptedBy {
    if (_value.acceptedBy == null) {
      return null;
    }

    return $AcceptedByCopyWith<$Res>(_value.acceptedBy!, (value) {
      return _then(_value.copyWith(acceptedBy: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ScoresCopyWith<$Res>? get scores {
    if (_value.scores == null) {
      return null;
    }

    return $ScoresCopyWith<$Res>(_value.scores!, (value) {
      return _then(_value.copyWith(scores: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProposalImplCopyWith<$Res>
    implements $ProposalCopyWith<$Res> {
  factory _$$ProposalImplCopyWith(
          _$ProposalImpl value, $Res Function(_$ProposalImpl) then) =
      __$$ProposalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String proposalId,
      String creatorId,
      String creatorName,
      @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToJson)
      SkillLevel skillLevel,
      @JsonKey(fromJson: _skillBracketFromJson, toJson: _skillBracketToJson)
      SkillBracket skillBracket,
      String location,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime dateTime,
      ProposalStatus status,
      AcceptedBy? acceptedBy,
      Scores? scores,
      List<String> scoreConfirmedBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime updatedAt,
      MatchType matchType,
      List<DoublesPlayer> doublesPlayers,
      int openSlots,
      List<String> playerIds});

  @override
  $AcceptedByCopyWith<$Res>? get acceptedBy;
  @override
  $ScoresCopyWith<$Res>? get scores;
}

/// @nodoc
class __$$ProposalImplCopyWithImpl<$Res>
    extends _$ProposalCopyWithImpl<$Res, _$ProposalImpl>
    implements _$$ProposalImplCopyWith<$Res> {
  __$$ProposalImplCopyWithImpl(
      _$ProposalImpl _value, $Res Function(_$ProposalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? proposalId = null,
    Object? creatorId = null,
    Object? creatorName = null,
    Object? skillLevel = null,
    Object? skillBracket = null,
    Object? location = null,
    Object? dateTime = null,
    Object? status = null,
    Object? acceptedBy = freezed,
    Object? scores = freezed,
    Object? scoreConfirmedBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? matchType = null,
    Object? doublesPlayers = null,
    Object? openSlots = null,
    Object? playerIds = null,
  }) {
    return _then(_$ProposalImpl(
      proposalId: null == proposalId
          ? _value.proposalId
          : proposalId // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      creatorName: null == creatorName
          ? _value.creatorName
          : creatorName // ignore: cast_nullable_to_non_nullable
              as String,
      skillLevel: null == skillLevel
          ? _value.skillLevel
          : skillLevel // ignore: cast_nullable_to_non_nullable
              as SkillLevel,
      skillBracket: null == skillBracket
          ? _value.skillBracket
          : skillBracket // ignore: cast_nullable_to_non_nullable
              as SkillBracket,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProposalStatus,
      acceptedBy: freezed == acceptedBy
          ? _value.acceptedBy
          : acceptedBy // ignore: cast_nullable_to_non_nullable
              as AcceptedBy?,
      scores: freezed == scores
          ? _value.scores
          : scores // ignore: cast_nullable_to_non_nullable
              as Scores?,
      scoreConfirmedBy: null == scoreConfirmedBy
          ? _value._scoreConfirmedBy
          : scoreConfirmedBy // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      matchType: null == matchType
          ? _value.matchType
          : matchType // ignore: cast_nullable_to_non_nullable
              as MatchType,
      doublesPlayers: null == doublesPlayers
          ? _value._doublesPlayers
          : doublesPlayers // ignore: cast_nullable_to_non_nullable
              as List<DoublesPlayer>,
      openSlots: null == openSlots
          ? _value.openSlots
          : openSlots // ignore: cast_nullable_to_non_nullable
              as int,
      playerIds: null == playerIds
          ? _value._playerIds
          : playerIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$ProposalImpl extends _Proposal {
  const _$ProposalImpl(
      {required this.proposalId,
      required this.creatorId,
      required this.creatorName,
      @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToJson)
      required this.skillLevel,
      @JsonKey(fromJson: _skillBracketFromJson, toJson: _skillBracketToJson)
      required this.skillBracket,
      required this.location,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required this.dateTime,
      required this.status,
      this.acceptedBy,
      this.scores,
      final List<String> scoreConfirmedBy = const [],
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required this.createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required this.updatedAt,
      this.matchType = MatchType.singles,
      final List<DoublesPlayer> doublesPlayers = const [],
      this.openSlots = 0,
      final List<String> playerIds = const []})
      : _scoreConfirmedBy = scoreConfirmedBy,
        _doublesPlayers = doublesPlayers,
        _playerIds = playerIds,
        super._();

  factory _$ProposalImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProposalImplFromJson(json);

  @override
  final String proposalId;
  @override
  final String creatorId;
  @override
  final String creatorName;
  @override
  @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToJson)
  final SkillLevel skillLevel;

  /// Bracket for filtering - derived from skillLevel but stored for efficient queries
  @override
  @JsonKey(fromJson: _skillBracketFromJson, toJson: _skillBracketToJson)
  final SkillBracket skillBracket;
  @override
  final String location;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime dateTime;
  @override
  final ProposalStatus status;
  @override
  final AcceptedBy? acceptedBy;
  @override
  final Scores? scores;
  final List<String> _scoreConfirmedBy;
  @override
  @JsonKey()
  List<String> get scoreConfirmedBy {
    if (_scoreConfirmedBy is EqualUnmodifiableListView)
      return _scoreConfirmedBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scoreConfirmedBy);
  }

  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime updatedAt;
// Doubles fields
  @override
  @JsonKey()
  final MatchType matchType;
  final List<DoublesPlayer> _doublesPlayers;
  @override
  @JsonKey()
  List<DoublesPlayer> get doublesPlayers {
    if (_doublesPlayers is EqualUnmodifiableListView) return _doublesPlayers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_doublesPlayers);
  }

  @override
  @JsonKey()
  final int openSlots;

  /// Denormalized list of user IDs for Firestore array-contains queries
  final List<String> _playerIds;

  /// Denormalized list of user IDs for Firestore array-contains queries
  @override
  @JsonKey()
  List<String> get playerIds {
    if (_playerIds is EqualUnmodifiableListView) return _playerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playerIds);
  }

  @override
  String toString() {
    return 'Proposal(proposalId: $proposalId, creatorId: $creatorId, creatorName: $creatorName, skillLevel: $skillLevel, skillBracket: $skillBracket, location: $location, dateTime: $dateTime, status: $status, acceptedBy: $acceptedBy, scores: $scores, scoreConfirmedBy: $scoreConfirmedBy, createdAt: $createdAt, updatedAt: $updatedAt, matchType: $matchType, doublesPlayers: $doublesPlayers, openSlots: $openSlots, playerIds: $playerIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProposalImpl &&
            (identical(other.proposalId, proposalId) ||
                other.proposalId == proposalId) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            (identical(other.creatorName, creatorName) ||
                other.creatorName == creatorName) &&
            (identical(other.skillLevel, skillLevel) ||
                other.skillLevel == skillLevel) &&
            (identical(other.skillBracket, skillBracket) ||
                other.skillBracket == skillBracket) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.acceptedBy, acceptedBy) ||
                other.acceptedBy == acceptedBy) &&
            (identical(other.scores, scores) || other.scores == scores) &&
            const DeepCollectionEquality()
                .equals(other._scoreConfirmedBy, _scoreConfirmedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.matchType, matchType) ||
                other.matchType == matchType) &&
            const DeepCollectionEquality()
                .equals(other._doublesPlayers, _doublesPlayers) &&
            (identical(other.openSlots, openSlots) ||
                other.openSlots == openSlots) &&
            const DeepCollectionEquality()
                .equals(other._playerIds, _playerIds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      proposalId,
      creatorId,
      creatorName,
      skillLevel,
      skillBracket,
      location,
      dateTime,
      status,
      acceptedBy,
      scores,
      const DeepCollectionEquality().hash(_scoreConfirmedBy),
      createdAt,
      updatedAt,
      matchType,
      const DeepCollectionEquality().hash(_doublesPlayers),
      openSlots,
      const DeepCollectionEquality().hash(_playerIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProposalImplCopyWith<_$ProposalImpl> get copyWith =>
      __$$ProposalImplCopyWithImpl<_$ProposalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProposalImplToJson(
      this,
    );
  }
}

abstract class _Proposal extends Proposal {
  const factory _Proposal(
      {required final String proposalId,
      required final String creatorId,
      required final String creatorName,
      @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToJson)
      required final SkillLevel skillLevel,
      @JsonKey(fromJson: _skillBracketFromJson, toJson: _skillBracketToJson)
      required final SkillBracket skillBracket,
      required final String location,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required final DateTime dateTime,
      required final ProposalStatus status,
      final AcceptedBy? acceptedBy,
      final Scores? scores,
      final List<String> scoreConfirmedBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required final DateTime createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required final DateTime updatedAt,
      final MatchType matchType,
      final List<DoublesPlayer> doublesPlayers,
      final int openSlots,
      final List<String> playerIds}) = _$ProposalImpl;
  const _Proposal._() : super._();

  factory _Proposal.fromJson(Map<String, dynamic> json) =
      _$ProposalImpl.fromJson;

  @override
  String get proposalId;
  @override
  String get creatorId;
  @override
  String get creatorName;
  @override
  @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToJson)
  SkillLevel get skillLevel;
  @override

  /// Bracket for filtering - derived from skillLevel but stored for efficient queries
  @JsonKey(fromJson: _skillBracketFromJson, toJson: _skillBracketToJson)
  SkillBracket get skillBracket;
  @override
  String get location;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get dateTime;
  @override
  ProposalStatus get status;
  @override
  AcceptedBy? get acceptedBy;
  @override
  Scores? get scores;
  @override
  List<String> get scoreConfirmedBy;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get updatedAt;
  @override // Doubles fields
  MatchType get matchType;
  @override
  List<DoublesPlayer> get doublesPlayers;
  @override
  int get openSlots;
  @override

  /// Denormalized list of user IDs for Firestore array-contains queries
  List<String> get playerIds;
  @override
  @JsonKey(ignore: true)
  _$$ProposalImplCopyWith<_$ProposalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
