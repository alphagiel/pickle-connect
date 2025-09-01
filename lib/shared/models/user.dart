import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String fullName,
    required String phoneNumber,
    required UserRole role,
    String? ustaRating,
    String? utrRating,
    SkillDivision? skillDivision,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@JsonEnum()
enum UserRole {
  @JsonValue('admin')
  admin,
  @JsonValue('user')
  user,
}

@JsonEnum()
enum SkillDivision {
  @JsonValue('beginner')
  beginner,
  @JsonValue('intermediate')
  intermediate,
  @JsonValue('advanced')
  advanced,
}