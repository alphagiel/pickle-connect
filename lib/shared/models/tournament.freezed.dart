// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Tournament _$TournamentFromJson(Map<String, dynamic> json) {
  return _Tournament.fromJson(json);
}

/// @nodoc
mixin _$Tournament {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  TournamentFormat get format => throw _privateConstructorUsedError;
  DateTime get registrationStart => throw _privateConstructorUsedError;
  DateTime get registrationEnd => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  int get maxParticipants => throw _privateConstructorUsedError;
  int get currentParticipants => throw _privateConstructorUsedError;
  TournamentStatus get status => throw _privateConstructorUsedError;
  List<String>? get eligibleDivisions => throw _privateConstructorUsedError;
  double? get entryFee => throw _privateConstructorUsedError;
  String? get prizeDescription => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TournamentCopyWith<Tournament> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentCopyWith<$Res> {
  factory $TournamentCopyWith(
          Tournament value, $Res Function(Tournament) then) =
      _$TournamentCopyWithImpl<$Res, Tournament>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      TournamentFormat format,
      DateTime registrationStart,
      DateTime registrationEnd,
      DateTime startDate,
      DateTime endDate,
      int maxParticipants,
      int currentParticipants,
      TournamentStatus status,
      List<String>? eligibleDivisions,
      double? entryFee,
      String? prizeDescription,
      DateTime? createdAt});
}

/// @nodoc
class _$TournamentCopyWithImpl<$Res, $Val extends Tournament>
    implements $TournamentCopyWith<$Res> {
  _$TournamentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? format = null,
    Object? registrationStart = null,
    Object? registrationEnd = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? maxParticipants = null,
    Object? currentParticipants = null,
    Object? status = null,
    Object? eligibleDivisions = freezed,
    Object? entryFee = freezed,
    Object? prizeDescription = freezed,
    Object? createdAt = freezed,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as TournamentFormat,
      registrationStart: null == registrationStart
          ? _value.registrationStart
          : registrationStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      registrationEnd: null == registrationEnd
          ? _value.registrationEnd
          : registrationEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      maxParticipants: null == maxParticipants
          ? _value.maxParticipants
          : maxParticipants // ignore: cast_nullable_to_non_nullable
              as int,
      currentParticipants: null == currentParticipants
          ? _value.currentParticipants
          : currentParticipants // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TournamentStatus,
      eligibleDivisions: freezed == eligibleDivisions
          ? _value.eligibleDivisions
          : eligibleDivisions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      entryFee: freezed == entryFee
          ? _value.entryFee
          : entryFee // ignore: cast_nullable_to_non_nullable
              as double?,
      prizeDescription: freezed == prizeDescription
          ? _value.prizeDescription
          : prizeDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TournamentImplCopyWith<$Res>
    implements $TournamentCopyWith<$Res> {
  factory _$$TournamentImplCopyWith(
          _$TournamentImpl value, $Res Function(_$TournamentImpl) then) =
      __$$TournamentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      TournamentFormat format,
      DateTime registrationStart,
      DateTime registrationEnd,
      DateTime startDate,
      DateTime endDate,
      int maxParticipants,
      int currentParticipants,
      TournamentStatus status,
      List<String>? eligibleDivisions,
      double? entryFee,
      String? prizeDescription,
      DateTime? createdAt});
}

/// @nodoc
class __$$TournamentImplCopyWithImpl<$Res>
    extends _$TournamentCopyWithImpl<$Res, _$TournamentImpl>
    implements _$$TournamentImplCopyWith<$Res> {
  __$$TournamentImplCopyWithImpl(
      _$TournamentImpl _value, $Res Function(_$TournamentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? format = null,
    Object? registrationStart = null,
    Object? registrationEnd = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? maxParticipants = null,
    Object? currentParticipants = null,
    Object? status = null,
    Object? eligibleDivisions = freezed,
    Object? entryFee = freezed,
    Object? prizeDescription = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$TournamentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as TournamentFormat,
      registrationStart: null == registrationStart
          ? _value.registrationStart
          : registrationStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      registrationEnd: null == registrationEnd
          ? _value.registrationEnd
          : registrationEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      maxParticipants: null == maxParticipants
          ? _value.maxParticipants
          : maxParticipants // ignore: cast_nullable_to_non_nullable
              as int,
      currentParticipants: null == currentParticipants
          ? _value.currentParticipants
          : currentParticipants // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TournamentStatus,
      eligibleDivisions: freezed == eligibleDivisions
          ? _value._eligibleDivisions
          : eligibleDivisions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      entryFee: freezed == entryFee
          ? _value.entryFee
          : entryFee // ignore: cast_nullable_to_non_nullable
              as double?,
      prizeDescription: freezed == prizeDescription
          ? _value.prizeDescription
          : prizeDescription // ignore: cast_nullable_to_non_nullable
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
class _$TournamentImpl implements _Tournament {
  const _$TournamentImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.format,
      required this.registrationStart,
      required this.registrationEnd,
      required this.startDate,
      required this.endDate,
      required this.maxParticipants,
      this.currentParticipants = 0,
      this.status = TournamentStatus.upcoming,
      final List<String>? eligibleDivisions,
      this.entryFee,
      this.prizeDescription,
      this.createdAt})
      : _eligibleDivisions = eligibleDivisions;

  factory _$TournamentImpl.fromJson(Map<String, dynamic> json) =>
      _$$TournamentImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final TournamentFormat format;
  @override
  final DateTime registrationStart;
  @override
  final DateTime registrationEnd;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final int maxParticipants;
  @override
  @JsonKey()
  final int currentParticipants;
  @override
  @JsonKey()
  final TournamentStatus status;
  final List<String>? _eligibleDivisions;
  @override
  List<String>? get eligibleDivisions {
    final value = _eligibleDivisions;
    if (value == null) return null;
    if (_eligibleDivisions is EqualUnmodifiableListView)
      return _eligibleDivisions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final double? entryFee;
  @override
  final String? prizeDescription;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Tournament(id: $id, name: $name, description: $description, format: $format, registrationStart: $registrationStart, registrationEnd: $registrationEnd, startDate: $startDate, endDate: $endDate, maxParticipants: $maxParticipants, currentParticipants: $currentParticipants, status: $status, eligibleDivisions: $eligibleDivisions, entryFee: $entryFee, prizeDescription: $prizeDescription, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.registrationStart, registrationStart) ||
                other.registrationStart == registrationStart) &&
            (identical(other.registrationEnd, registrationEnd) ||
                other.registrationEnd == registrationEnd) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.maxParticipants, maxParticipants) ||
                other.maxParticipants == maxParticipants) &&
            (identical(other.currentParticipants, currentParticipants) ||
                other.currentParticipants == currentParticipants) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._eligibleDivisions, _eligibleDivisions) &&
            (identical(other.entryFee, entryFee) ||
                other.entryFee == entryFee) &&
            (identical(other.prizeDescription, prizeDescription) ||
                other.prizeDescription == prizeDescription) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      format,
      registrationStart,
      registrationEnd,
      startDate,
      endDate,
      maxParticipants,
      currentParticipants,
      status,
      const DeepCollectionEquality().hash(_eligibleDivisions),
      entryFee,
      prizeDescription,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TournamentImplCopyWith<_$TournamentImpl> get copyWith =>
      __$$TournamentImplCopyWithImpl<_$TournamentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TournamentImplToJson(
      this,
    );
  }
}

abstract class _Tournament implements Tournament {
  const factory _Tournament(
      {required final String id,
      required final String name,
      required final String description,
      required final TournamentFormat format,
      required final DateTime registrationStart,
      required final DateTime registrationEnd,
      required final DateTime startDate,
      required final DateTime endDate,
      required final int maxParticipants,
      final int currentParticipants,
      final TournamentStatus status,
      final List<String>? eligibleDivisions,
      final double? entryFee,
      final String? prizeDescription,
      final DateTime? createdAt}) = _$TournamentImpl;

  factory _Tournament.fromJson(Map<String, dynamic> json) =
      _$TournamentImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  TournamentFormat get format;
  @override
  DateTime get registrationStart;
  @override
  DateTime get registrationEnd;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  int get maxParticipants;
  @override
  int get currentParticipants;
  @override
  TournamentStatus get status;
  @override
  List<String>? get eligibleDivisions;
  @override
  double? get entryFee;
  @override
  String? get prizeDescription;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$TournamentImplCopyWith<_$TournamentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TournamentParticipant _$TournamentParticipantFromJson(
    Map<String, dynamic> json) {
  return _TournamentParticipant.fromJson(json);
}

/// @nodoc
mixin _$TournamentParticipant {
  String get id => throw _privateConstructorUsedError;
  String get tournamentId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get registeredAt => throw _privateConstructorUsedError;
  ParticipantStatus get status => throw _privateConstructorUsedError;
  int? get seed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TournamentParticipantCopyWith<TournamentParticipant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentParticipantCopyWith<$Res> {
  factory $TournamentParticipantCopyWith(TournamentParticipant value,
          $Res Function(TournamentParticipant) then) =
      _$TournamentParticipantCopyWithImpl<$Res, TournamentParticipant>;
  @useResult
  $Res call(
      {String id,
      String tournamentId,
      String userId,
      DateTime registeredAt,
      ParticipantStatus status,
      int? seed});
}

/// @nodoc
class _$TournamentParticipantCopyWithImpl<$Res,
        $Val extends TournamentParticipant>
    implements $TournamentParticipantCopyWith<$Res> {
  _$TournamentParticipantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tournamentId = null,
    Object? userId = null,
    Object? registeredAt = null,
    Object? status = null,
    Object? seed = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tournamentId: null == tournamentId
          ? _value.tournamentId
          : tournamentId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      registeredAt: null == registeredAt
          ? _value.registeredAt
          : registeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ParticipantStatus,
      seed: freezed == seed
          ? _value.seed
          : seed // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TournamentParticipantImplCopyWith<$Res>
    implements $TournamentParticipantCopyWith<$Res> {
  factory _$$TournamentParticipantImplCopyWith(
          _$TournamentParticipantImpl value,
          $Res Function(_$TournamentParticipantImpl) then) =
      __$$TournamentParticipantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String tournamentId,
      String userId,
      DateTime registeredAt,
      ParticipantStatus status,
      int? seed});
}

/// @nodoc
class __$$TournamentParticipantImplCopyWithImpl<$Res>
    extends _$TournamentParticipantCopyWithImpl<$Res,
        _$TournamentParticipantImpl>
    implements _$$TournamentParticipantImplCopyWith<$Res> {
  __$$TournamentParticipantImplCopyWithImpl(_$TournamentParticipantImpl _value,
      $Res Function(_$TournamentParticipantImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tournamentId = null,
    Object? userId = null,
    Object? registeredAt = null,
    Object? status = null,
    Object? seed = freezed,
  }) {
    return _then(_$TournamentParticipantImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tournamentId: null == tournamentId
          ? _value.tournamentId
          : tournamentId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      registeredAt: null == registeredAt
          ? _value.registeredAt
          : registeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ParticipantStatus,
      seed: freezed == seed
          ? _value.seed
          : seed // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TournamentParticipantImpl implements _TournamentParticipant {
  const _$TournamentParticipantImpl(
      {required this.id,
      required this.tournamentId,
      required this.userId,
      required this.registeredAt,
      this.status = ParticipantStatus.registered,
      this.seed});

  factory _$TournamentParticipantImpl.fromJson(Map<String, dynamic> json) =>
      _$$TournamentParticipantImplFromJson(json);

  @override
  final String id;
  @override
  final String tournamentId;
  @override
  final String userId;
  @override
  final DateTime registeredAt;
  @override
  @JsonKey()
  final ParticipantStatus status;
  @override
  final int? seed;

  @override
  String toString() {
    return 'TournamentParticipant(id: $id, tournamentId: $tournamentId, userId: $userId, registeredAt: $registeredAt, status: $status, seed: $seed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentParticipantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tournamentId, tournamentId) ||
                other.tournamentId == tournamentId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.registeredAt, registeredAt) ||
                other.registeredAt == registeredAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.seed, seed) || other.seed == seed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, tournamentId, userId, registeredAt, status, seed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TournamentParticipantImplCopyWith<_$TournamentParticipantImpl>
      get copyWith => __$$TournamentParticipantImplCopyWithImpl<
          _$TournamentParticipantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TournamentParticipantImplToJson(
      this,
    );
  }
}

abstract class _TournamentParticipant implements TournamentParticipant {
  const factory _TournamentParticipant(
      {required final String id,
      required final String tournamentId,
      required final String userId,
      required final DateTime registeredAt,
      final ParticipantStatus status,
      final int? seed}) = _$TournamentParticipantImpl;

  factory _TournamentParticipant.fromJson(Map<String, dynamic> json) =
      _$TournamentParticipantImpl.fromJson;

  @override
  String get id;
  @override
  String get tournamentId;
  @override
  String get userId;
  @override
  DateTime get registeredAt;
  @override
  ParticipantStatus get status;
  @override
  int? get seed;
  @override
  @JsonKey(ignore: true)
  _$$TournamentParticipantImplCopyWith<_$TournamentParticipantImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TournamentMatch _$TournamentMatchFromJson(Map<String, dynamic> json) {
  return _TournamentMatch.fromJson(json);
}

/// @nodoc
mixin _$TournamentMatch {
  String get id => throw _privateConstructorUsedError;
  String get tournamentId => throw _privateConstructorUsedError;
  String get participant1Id => throw _privateConstructorUsedError;
  String get participant2Id => throw _privateConstructorUsedError;
  int get round => throw _privateConstructorUsedError;
  DateTime? get scheduledAt => throw _privateConstructorUsedError;
  String? get courtId => throw _privateConstructorUsedError;
  TournamentMatchResult? get result => throw _privateConstructorUsedError;
  TournamentMatchStatus get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TournamentMatchCopyWith<TournamentMatch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentMatchCopyWith<$Res> {
  factory $TournamentMatchCopyWith(
          TournamentMatch value, $Res Function(TournamentMatch) then) =
      _$TournamentMatchCopyWithImpl<$Res, TournamentMatch>;
  @useResult
  $Res call(
      {String id,
      String tournamentId,
      String participant1Id,
      String participant2Id,
      int round,
      DateTime? scheduledAt,
      String? courtId,
      TournamentMatchResult? result,
      TournamentMatchStatus status});

  $TournamentMatchResultCopyWith<$Res>? get result;
}

/// @nodoc
class _$TournamentMatchCopyWithImpl<$Res, $Val extends TournamentMatch>
    implements $TournamentMatchCopyWith<$Res> {
  _$TournamentMatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tournamentId = null,
    Object? participant1Id = null,
    Object? participant2Id = null,
    Object? round = null,
    Object? scheduledAt = freezed,
    Object? courtId = freezed,
    Object? result = freezed,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tournamentId: null == tournamentId
          ? _value.tournamentId
          : tournamentId // ignore: cast_nullable_to_non_nullable
              as String,
      participant1Id: null == participant1Id
          ? _value.participant1Id
          : participant1Id // ignore: cast_nullable_to_non_nullable
              as String,
      participant2Id: null == participant2Id
          ? _value.participant2Id
          : participant2Id // ignore: cast_nullable_to_non_nullable
              as String,
      round: null == round
          ? _value.round
          : round // ignore: cast_nullable_to_non_nullable
              as int,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      courtId: freezed == courtId
          ? _value.courtId
          : courtId // ignore: cast_nullable_to_non_nullable
              as String?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as TournamentMatchResult?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TournamentMatchStatus,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TournamentMatchResultCopyWith<$Res>? get result {
    if (_value.result == null) {
      return null;
    }

    return $TournamentMatchResultCopyWith<$Res>(_value.result!, (value) {
      return _then(_value.copyWith(result: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TournamentMatchImplCopyWith<$Res>
    implements $TournamentMatchCopyWith<$Res> {
  factory _$$TournamentMatchImplCopyWith(_$TournamentMatchImpl value,
          $Res Function(_$TournamentMatchImpl) then) =
      __$$TournamentMatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String tournamentId,
      String participant1Id,
      String participant2Id,
      int round,
      DateTime? scheduledAt,
      String? courtId,
      TournamentMatchResult? result,
      TournamentMatchStatus status});

  @override
  $TournamentMatchResultCopyWith<$Res>? get result;
}

/// @nodoc
class __$$TournamentMatchImplCopyWithImpl<$Res>
    extends _$TournamentMatchCopyWithImpl<$Res, _$TournamentMatchImpl>
    implements _$$TournamentMatchImplCopyWith<$Res> {
  __$$TournamentMatchImplCopyWithImpl(
      _$TournamentMatchImpl _value, $Res Function(_$TournamentMatchImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tournamentId = null,
    Object? participant1Id = null,
    Object? participant2Id = null,
    Object? round = null,
    Object? scheduledAt = freezed,
    Object? courtId = freezed,
    Object? result = freezed,
    Object? status = null,
  }) {
    return _then(_$TournamentMatchImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tournamentId: null == tournamentId
          ? _value.tournamentId
          : tournamentId // ignore: cast_nullable_to_non_nullable
              as String,
      participant1Id: null == participant1Id
          ? _value.participant1Id
          : participant1Id // ignore: cast_nullable_to_non_nullable
              as String,
      participant2Id: null == participant2Id
          ? _value.participant2Id
          : participant2Id // ignore: cast_nullable_to_non_nullable
              as String,
      round: null == round
          ? _value.round
          : round // ignore: cast_nullable_to_non_nullable
              as int,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      courtId: freezed == courtId
          ? _value.courtId
          : courtId // ignore: cast_nullable_to_non_nullable
              as String?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as TournamentMatchResult?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TournamentMatchStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TournamentMatchImpl implements _TournamentMatch {
  const _$TournamentMatchImpl(
      {required this.id,
      required this.tournamentId,
      required this.participant1Id,
      required this.participant2Id,
      required this.round,
      this.scheduledAt,
      this.courtId,
      this.result,
      this.status = TournamentMatchStatus.pending});

  factory _$TournamentMatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$TournamentMatchImplFromJson(json);

  @override
  final String id;
  @override
  final String tournamentId;
  @override
  final String participant1Id;
  @override
  final String participant2Id;
  @override
  final int round;
  @override
  final DateTime? scheduledAt;
  @override
  final String? courtId;
  @override
  final TournamentMatchResult? result;
  @override
  @JsonKey()
  final TournamentMatchStatus status;

  @override
  String toString() {
    return 'TournamentMatch(id: $id, tournamentId: $tournamentId, participant1Id: $participant1Id, participant2Id: $participant2Id, round: $round, scheduledAt: $scheduledAt, courtId: $courtId, result: $result, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentMatchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tournamentId, tournamentId) ||
                other.tournamentId == tournamentId) &&
            (identical(other.participant1Id, participant1Id) ||
                other.participant1Id == participant1Id) &&
            (identical(other.participant2Id, participant2Id) ||
                other.participant2Id == participant2Id) &&
            (identical(other.round, round) || other.round == round) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.courtId, courtId) || other.courtId == courtId) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, tournamentId, participant1Id,
      participant2Id, round, scheduledAt, courtId, result, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TournamentMatchImplCopyWith<_$TournamentMatchImpl> get copyWith =>
      __$$TournamentMatchImplCopyWithImpl<_$TournamentMatchImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TournamentMatchImplToJson(
      this,
    );
  }
}

abstract class _TournamentMatch implements TournamentMatch {
  const factory _TournamentMatch(
      {required final String id,
      required final String tournamentId,
      required final String participant1Id,
      required final String participant2Id,
      required final int round,
      final DateTime? scheduledAt,
      final String? courtId,
      final TournamentMatchResult? result,
      final TournamentMatchStatus status}) = _$TournamentMatchImpl;

  factory _TournamentMatch.fromJson(Map<String, dynamic> json) =
      _$TournamentMatchImpl.fromJson;

  @override
  String get id;
  @override
  String get tournamentId;
  @override
  String get participant1Id;
  @override
  String get participant2Id;
  @override
  int get round;
  @override
  DateTime? get scheduledAt;
  @override
  String? get courtId;
  @override
  TournamentMatchResult? get result;
  @override
  TournamentMatchStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$TournamentMatchImplCopyWith<_$TournamentMatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TournamentMatchResult _$TournamentMatchResultFromJson(
    Map<String, dynamic> json) {
  return _TournamentMatchResult.fromJson(json);
}

/// @nodoc
mixin _$TournamentMatchResult {
  String get winnerId => throw _privateConstructorUsedError;
  String get loserId => throw _privateConstructorUsedError;
  List<Set> get sets => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TournamentMatchResultCopyWith<TournamentMatchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentMatchResultCopyWith<$Res> {
  factory $TournamentMatchResultCopyWith(TournamentMatchResult value,
          $Res Function(TournamentMatchResult) then) =
      _$TournamentMatchResultCopyWithImpl<$Res, TournamentMatchResult>;
  @useResult
  $Res call(
      {String winnerId, String loserId, List<Set> sets, DateTime? completedAt});
}

/// @nodoc
class _$TournamentMatchResultCopyWithImpl<$Res,
        $Val extends TournamentMatchResult>
    implements $TournamentMatchResultCopyWith<$Res> {
  _$TournamentMatchResultCopyWithImpl(this._value, this._then);

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
abstract class _$$TournamentMatchResultImplCopyWith<$Res>
    implements $TournamentMatchResultCopyWith<$Res> {
  factory _$$TournamentMatchResultImplCopyWith(
          _$TournamentMatchResultImpl value,
          $Res Function(_$TournamentMatchResultImpl) then) =
      __$$TournamentMatchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String winnerId, String loserId, List<Set> sets, DateTime? completedAt});
}

/// @nodoc
class __$$TournamentMatchResultImplCopyWithImpl<$Res>
    extends _$TournamentMatchResultCopyWithImpl<$Res,
        _$TournamentMatchResultImpl>
    implements _$$TournamentMatchResultImplCopyWith<$Res> {
  __$$TournamentMatchResultImplCopyWithImpl(_$TournamentMatchResultImpl _value,
      $Res Function(_$TournamentMatchResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? winnerId = null,
    Object? loserId = null,
    Object? sets = null,
    Object? completedAt = freezed,
  }) {
    return _then(_$TournamentMatchResultImpl(
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
class _$TournamentMatchResultImpl implements _TournamentMatchResult {
  const _$TournamentMatchResultImpl(
      {required this.winnerId,
      required this.loserId,
      required final List<Set> sets,
      this.completedAt})
      : _sets = sets;

  factory _$TournamentMatchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TournamentMatchResultImplFromJson(json);

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
    return 'TournamentMatchResult(winnerId: $winnerId, loserId: $loserId, sets: $sets, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentMatchResultImpl &&
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
  _$$TournamentMatchResultImplCopyWith<_$TournamentMatchResultImpl>
      get copyWith => __$$TournamentMatchResultImplCopyWithImpl<
          _$TournamentMatchResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TournamentMatchResultImplToJson(
      this,
    );
  }
}

abstract class _TournamentMatchResult implements TournamentMatchResult {
  const factory _TournamentMatchResult(
      {required final String winnerId,
      required final String loserId,
      required final List<Set> sets,
      final DateTime? completedAt}) = _$TournamentMatchResultImpl;

  factory _TournamentMatchResult.fromJson(Map<String, dynamic> json) =
      _$TournamentMatchResultImpl.fromJson;

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
  _$$TournamentMatchResultImplCopyWith<_$TournamentMatchResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}
