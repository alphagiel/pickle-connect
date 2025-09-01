class AuthUser {
  final String id;
  final String email;
  final String? displayName;
  final bool isEmailVerified;

  AuthUser({
    required this.id,
    required this.email,
    this.displayName,
    required this.isEmailVerified,
  });
}