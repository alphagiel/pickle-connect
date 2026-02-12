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

EmailNotificationPreferences _$EmailNotificationPreferencesFromJson(
    Map<String, dynamic> json) {
  return _EmailNotificationPreferences.fromJson(json);
}

/// @nodoc
mixin _$EmailNotificationPreferences {
  bool get welcome => throw _privateConstructorUsedError;
  bool get newProposals => throw _privateConstructorUsedError;
  bool get proposalAccepted => throw _privateConstructorUsedError;
  bool get proposalUnaccepted => throw _privateConstructorUsedError;
  bool get matchResults => throw _privateConstructorUsedError;
  bool get doublesUpdates => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmailNotificationPreferencesCopyWith<EmailNotificationPreferences>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmailNotificationPreferencesCopyWith<$Res> {
  factory $EmailNotificationPreferencesCopyWith(
          EmailNotificationPreferences value,
          $Res Function(EmailNotificationPreferences) then) =
      _$EmailNotificationPreferencesCopyWithImpl<$Res,
          EmailNotificationPreferences>;
  @useResult
  $Res call(
      {bool welcome,
      bool newProposals,
      bool proposalAccepted,
      bool proposalUnaccepted,
      bool matchResults,
      bool doublesUpdates});
}

/// @nodoc
class _$EmailNotificationPreferencesCopyWithImpl<$Res,
        $Val extends EmailNotificationPreferences>
    implements $EmailNotificationPreferencesCopyWith<$Res> {
  _$EmailNotificationPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? welcome = null,
    Object? newProposals = null,
    Object? proposalAccepted = null,
    Object? proposalUnaccepted = null,
    Object? matchResults = null,
    Object? doublesUpdates = null,
  }) {
    return _then(_value.copyWith(
      welcome: null == welcome
          ? _value.welcome
          : welcome // ignore: cast_nullable_to_non_nullable
              as bool,
      newProposals: null == newProposals
          ? _value.newProposals
          : newProposals // ignore: cast_nullable_to_non_nullable
              as bool,
      proposalAccepted: null == proposalAccepted
          ? _value.proposalAccepted
          : proposalAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      proposalUnaccepted: null == proposalUnaccepted
          ? _value.proposalUnaccepted
          : proposalUnaccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      matchResults: null == matchResults
          ? _value.matchResults
          : matchResults // ignore: cast_nullable_to_non_nullable
              as bool,
      doublesUpdates: null == doublesUpdates
          ? _value.doublesUpdates
          : doublesUpdates // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmailNotificationPreferencesImplCopyWith<$Res>
    implements $EmailNotificationPreferencesCopyWith<$Res> {
  factory _$$EmailNotificationPreferencesImplCopyWith(
          _$EmailNotificationPreferencesImpl value,
          $Res Function(_$EmailNotificationPreferencesImpl) then) =
      __$$EmailNotificationPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool welcome,
      bool newProposals,
      bool proposalAccepted,
      bool proposalUnaccepted,
      bool matchResults,
      bool doublesUpdates});
}

/// @nodoc
class __$$EmailNotificationPreferencesImplCopyWithImpl<$Res>
    extends _$EmailNotificationPreferencesCopyWithImpl<$Res,
        _$EmailNotificationPreferencesImpl>
    implements _$$EmailNotificationPreferencesImplCopyWith<$Res> {
  __$$EmailNotificationPreferencesImplCopyWithImpl(
      _$EmailNotificationPreferencesImpl _value,
      $Res Function(_$EmailNotificationPreferencesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? welcome = null,
    Object? newProposals = null,
    Object? proposalAccepted = null,
    Object? proposalUnaccepted = null,
    Object? matchResults = null,
    Object? doublesUpdates = null,
  }) {
    return _then(_$EmailNotificationPreferencesImpl(
      welcome: null == welcome
          ? _value.welcome
          : welcome // ignore: cast_nullable_to_non_nullable
              as bool,
      newProposals: null == newProposals
          ? _value.newProposals
          : newProposals // ignore: cast_nullable_to_non_nullable
              as bool,
      proposalAccepted: null == proposalAccepted
          ? _value.proposalAccepted
          : proposalAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      proposalUnaccepted: null == proposalUnaccepted
          ? _value.proposalUnaccepted
          : proposalUnaccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      matchResults: null == matchResults
          ? _value.matchResults
          : matchResults // ignore: cast_nullable_to_non_nullable
              as bool,
      doublesUpdates: null == doublesUpdates
          ? _value.doublesUpdates
          : doublesUpdates // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmailNotificationPreferencesImpl
    implements _EmailNotificationPreferences {
  const _$EmailNotificationPreferencesImpl(
      {this.welcome = true,
      this.newProposals = true,
      this.proposalAccepted = true,
      this.proposalUnaccepted = true,
      this.matchResults = true,
      this.doublesUpdates = true});

  factory _$EmailNotificationPreferencesImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$EmailNotificationPreferencesImplFromJson(json);

  @override
  @JsonKey()
  final bool welcome;
  @override
  @JsonKey()
  final bool newProposals;
  @override
  @JsonKey()
  final bool proposalAccepted;
  @override
  @JsonKey()
  final bool proposalUnaccepted;
  @override
  @JsonKey()
  final bool matchResults;
  @override
  @JsonKey()
  final bool doublesUpdates;

  @override
  String toString() {
    return 'EmailNotificationPreferences(welcome: $welcome, newProposals: $newProposals, proposalAccepted: $proposalAccepted, proposalUnaccepted: $proposalUnaccepted, matchResults: $matchResults, doublesUpdates: $doublesUpdates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailNotificationPreferencesImpl &&
            (identical(other.welcome, welcome) || other.welcome == welcome) &&
            (identical(other.newProposals, newProposals) ||
                other.newProposals == newProposals) &&
            (identical(other.proposalAccepted, proposalAccepted) ||
                other.proposalAccepted == proposalAccepted) &&
            (identical(other.proposalUnaccepted, proposalUnaccepted) ||
                other.proposalUnaccepted == proposalUnaccepted) &&
            (identical(other.matchResults, matchResults) ||
                other.matchResults == matchResults) &&
            (identical(other.doublesUpdates, doublesUpdates) ||
                other.doublesUpdates == doublesUpdates));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, welcome, newProposals,
      proposalAccepted, proposalUnaccepted, matchResults, doublesUpdates);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmailNotificationPreferencesImplCopyWith<
          _$EmailNotificationPreferencesImpl>
      get copyWith => __$$EmailNotificationPreferencesImplCopyWithImpl<
          _$EmailNotificationPreferencesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmailNotificationPreferencesImplToJson(
      this,
    );
  }
}

abstract class _EmailNotificationPreferences
    implements EmailNotificationPreferences {
  const factory _EmailNotificationPreferences(
      {final bool welcome,
      final bool newProposals,
      final bool proposalAccepted,
      final bool proposalUnaccepted,
      final bool matchResults,
      final bool doublesUpdates}) = _$EmailNotificationPreferencesImpl;

  factory _EmailNotificationPreferences.fromJson(Map<String, dynamic> json) =
      _$EmailNotificationPreferencesImpl.fromJson;

  @override
  bool get welcome;
  @override
  bool get newProposals;
  @override
  bool get proposalAccepted;
  @override
  bool get proposalUnaccepted;
  @override
  bool get matchResults;
  @override
  bool get doublesUpdates;
  @override
  @JsonKey(ignore: true)
  _$$EmailNotificationPreferencesImplCopyWith<
          _$EmailNotificationPreferencesImpl>
      get copyWith => throw _privateConstructorUsedError;
}

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get userId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToJson)
  SkillLevel get skillLevel => throw _privateConstructorUsedError;

  /// Skill bracket derived from skillLevel (stored for efficient Firestore queries)
  @JsonKey(fromJson: _skillBracketFromJson, toJson: _skillBracketToJson)
  SkillBracket get skillBracket => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String? get profileImageURL => throw _privateConstructorUsedError;
  int get matchesPlayed => throw _privateConstructorUsedError;
  int get matchesWon => throw _privateConstructorUsedError;
  int get matchesLost => throw _privateConstructorUsedError;
  double get winRate => throw _privateConstructorUsedError; // Doubles stats
  int get doublesPlayed => throw _privateConstructorUsedError;
  int get doublesWon => throw _privateConstructorUsedError;
  int get doublesLost => throw _privateConstructorUsedError;
  double get doublesWinRate => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get updatedAt => throw _privateConstructorUsedError;
  EmailNotificationPreferences? get emailNotifications =>
      throw _privateConstructorUsedError;

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
      {String userId,
      String displayName,
      String email,
      @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToJson)
      SkillLevel skillLevel,
      @JsonKey(fromJson: _skillBracketFromJson, toJson: _skillBracketToJson)
      SkillBracket skillBracket,
      String location,
      String? profileImageURL,
      int matchesPlayed,
      int matchesWon,
      int matchesLost,
      double winRate,
      int doublesPlayed,
      int doublesWon,
      int doublesLost,
      double doublesWinRate,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime updatedAt,
      EmailNotificationPreferences? emailNotifications});

  $EmailNotificationPreferencesCopyWith<$Res>? get emailNotifications;
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
    Object? userId = null,
    Object? displayName = null,
    Object? email = null,
    Object? skillLevel = null,
    Object? skillBracket = null,
    Object? location = null,
    Object? profileImageURL = freezed,
    Object? matchesPlayed = null,
    Object? matchesWon = null,
    Object? matchesLost = null,
    Object? winRate = null,
    Object? doublesPlayed = null,
    Object? doublesWon = null,
    Object? doublesLost = null,
    Object? doublesWinRate = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? emailNotifications = freezed,
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
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
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
      profileImageURL: freezed == profileImageURL
          ? _value.profileImageURL
          : profileImageURL // ignore: cast_nullable_to_non_nullable
              as String?,
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
      doublesPlayed: null == doublesPlayed
          ? _value.doublesPlayed
          : doublesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      doublesWon: null == doublesWon
          ? _value.doublesWon
          : doublesWon // ignore: cast_nullable_to_non_nullable
              as int,
      doublesLost: null == doublesLost
          ? _value.doublesLost
          : doublesLost // ignore: cast_nullable_to_non_nullable
              as int,
      doublesWinRate: null == doublesWinRate
          ? _value.doublesWinRate
          : doublesWinRate // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      emailNotifications: freezed == emailNotifications
          ? _value.emailNotifications
          : emailNotifications // ignore: cast_nullable_to_non_nullable
              as EmailNotificationPreferences?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $EmailNotificationPreferencesCopyWith<$Res>? get emailNotifications {
    if (_value.emailNotifications == null) {
      return null;
    }

    return $EmailNotificationPreferencesCopyWith<$Res>(
        _value.emailNotifications!, (value) {
      return _then(_value.copyWith(emailNotifications: value) as $Val);
    });
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
      {String userId,
      String displayName,
      String email,
      @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToJson)
      SkillLevel skillLevel,
      @JsonKey(fromJson: _skillBracketFromJson, toJson: _skillBracketToJson)
      SkillBracket skillBracket,
      String location,
      String? profileImageURL,
      int matchesPlayed,
      int matchesWon,
      int matchesLost,
      double winRate,
      int doublesPlayed,
      int doublesWon,
      int doublesLost,
      double doublesWinRate,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime updatedAt,
      EmailNotificationPreferences? emailNotifications});

  @override
  $EmailNotificationPreferencesCopyWith<$Res>? get emailNotifications;
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
    Object? userId = null,
    Object? displayName = null,
    Object? email = null,
    Object? skillLevel = null,
    Object? skillBracket = null,
    Object? location = null,
    Object? profileImageURL = freezed,
    Object? matchesPlayed = null,
    Object? matchesWon = null,
    Object? matchesLost = null,
    Object? winRate = null,
    Object? doublesPlayed = null,
    Object? doublesWon = null,
    Object? doublesLost = null,
    Object? doublesWinRate = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? emailNotifications = freezed,
  }) {
    return _then(_$UserImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
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
      profileImageURL: freezed == profileImageURL
          ? _value.profileImageURL
          : profileImageURL // ignore: cast_nullable_to_non_nullable
              as String?,
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
      doublesPlayed: null == doublesPlayed
          ? _value.doublesPlayed
          : doublesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      doublesWon: null == doublesWon
          ? _value.doublesWon
          : doublesWon // ignore: cast_nullable_to_non_nullable
              as int,
      doublesLost: null == doublesLost
          ? _value.doublesLost
          : doublesLost // ignore: cast_nullable_to_non_nullable
              as int,
      doublesWinRate: null == doublesWinRate
          ? _value.doublesWinRate
          : doublesWinRate // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      emailNotifications: freezed == emailNotifications
          ? _value.emailNotifications
          : emailNotifications // ignore: cast_nullable_to_non_nullable
              as EmailNotificationPreferences?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {required this.userId,
      required this.displayName,
      required this.email,
      @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToJson)
      required this.skillLevel,
      @JsonKey(fromJson: _skillBracketFromJson, toJson: _skillBracketToJson)
      required this.skillBracket,
      required this.location,
      this.profileImageURL,
      this.matchesPlayed = 0,
      this.matchesWon = 0,
      this.matchesLost = 0,
      this.winRate = 0.0,
      this.doublesPlayed = 0,
      this.doublesWon = 0,
      this.doublesLost = 0,
      this.doublesWinRate = 0.0,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required this.createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required this.updatedAt,
      this.emailNotifications});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String userId;
  @override
  final String displayName;
  @override
  final String email;
  @override
  @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToJson)
  final SkillLevel skillLevel;

  /// Skill bracket derived from skillLevel (stored for efficient Firestore queries)
  @override
  @JsonKey(fromJson: _skillBracketFromJson, toJson: _skillBracketToJson)
  final SkillBracket skillBracket;
  @override
  final String location;
  @override
  final String? profileImageURL;
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
// Doubles stats
  @override
  @JsonKey()
  final int doublesPlayed;
  @override
  @JsonKey()
  final int doublesWon;
  @override
  @JsonKey()
  final int doublesLost;
  @override
  @JsonKey()
  final double doublesWinRate;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime updatedAt;
  @override
  final EmailNotificationPreferences? emailNotifications;

  @override
  String toString() {
    return 'User(userId: $userId, displayName: $displayName, email: $email, skillLevel: $skillLevel, skillBracket: $skillBracket, location: $location, profileImageURL: $profileImageURL, matchesPlayed: $matchesPlayed, matchesWon: $matchesWon, matchesLost: $matchesLost, winRate: $winRate, doublesPlayed: $doublesPlayed, doublesWon: $doublesWon, doublesLost: $doublesLost, doublesWinRate: $doublesWinRate, createdAt: $createdAt, updatedAt: $updatedAt, emailNotifications: $emailNotifications)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.skillLevel, skillLevel) ||
                other.skillLevel == skillLevel) &&
            (identical(other.skillBracket, skillBracket) ||
                other.skillBracket == skillBracket) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.profileImageURL, profileImageURL) ||
                other.profileImageURL == profileImageURL) &&
            (identical(other.matchesPlayed, matchesPlayed) ||
                other.matchesPlayed == matchesPlayed) &&
            (identical(other.matchesWon, matchesWon) ||
                other.matchesWon == matchesWon) &&
            (identical(other.matchesLost, matchesLost) ||
                other.matchesLost == matchesLost) &&
            (identical(other.winRate, winRate) || other.winRate == winRate) &&
            (identical(other.doublesPlayed, doublesPlayed) ||
                other.doublesPlayed == doublesPlayed) &&
            (identical(other.doublesWon, doublesWon) ||
                other.doublesWon == doublesWon) &&
            (identical(other.doublesLost, doublesLost) ||
                other.doublesLost == doublesLost) &&
            (identical(other.doublesWinRate, doublesWinRate) ||
                other.doublesWinRate == doublesWinRate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.emailNotifications, emailNotifications) ||
                other.emailNotifications == emailNotifications));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      displayName,
      email,
      skillLevel,
      skillBracket,
      location,
      profileImageURL,
      matchesPlayed,
      matchesWon,
      matchesLost,
      winRate,
      doublesPlayed,
      doublesWon,
      doublesLost,
      doublesWinRate,
      createdAt,
      updatedAt,
      emailNotifications);

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
      {required final String userId,
      required final String displayName,
      required final String email,
      @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToJson)
      required final SkillLevel skillLevel,
      @JsonKey(fromJson: _skillBracketFromJson, toJson: _skillBracketToJson)
      required final SkillBracket skillBracket,
      required final String location,
      final String? profileImageURL,
      final int matchesPlayed,
      final int matchesWon,
      final int matchesLost,
      final double winRate,
      final int doublesPlayed,
      final int doublesWon,
      final int doublesLost,
      final double doublesWinRate,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required final DateTime createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required final DateTime updatedAt,
      final EmailNotificationPreferences? emailNotifications}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get userId;
  @override
  String get displayName;
  @override
  String get email;
  @override
  @JsonKey(fromJson: _skillLevelFromJson, toJson: _skillLevelToJson)
  SkillLevel get skillLevel;
  @override

  /// Skill bracket derived from skillLevel (stored for efficient Firestore queries)
  @JsonKey(fromJson: _skillBracketFromJson, toJson: _skillBracketToJson)
  SkillBracket get skillBracket;
  @override
  String get location;
  @override
  String? get profileImageURL;
  @override
  int get matchesPlayed;
  @override
  int get matchesWon;
  @override
  int get matchesLost;
  @override
  double get winRate;
  @override // Doubles stats
  int get doublesPlayed;
  @override
  int get doublesWon;
  @override
  int get doublesLost;
  @override
  double get doublesWinRate;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get updatedAt;
  @override
  EmailNotificationPreferences? get emailNotifications;
  @override
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
