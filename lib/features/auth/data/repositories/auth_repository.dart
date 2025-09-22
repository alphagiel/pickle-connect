import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/user.dart' as app_user;

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance);
});

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository(this._firebaseAuth);

  // Current user stream
  Stream<AuthUser?> get authStateChanges => _firebaseAuth.authStateChanges().map(
        (user) => user != null ? AuthUser.fromFirebaseUser(user) : null,
      );

  // Current user
  AuthUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user != null ? AuthUser.fromFirebaseUser(user) : null;
  }

  // Sign in with email and password
  Future<AuthUser?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      return credential.user != null 
          ? AuthUser.fromFirebaseUser(credential.user!)
          : null;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuthException(e);
    }
  }

  // Create account with email and password
  Future<AuthUser?> createUserWithEmailPassword({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    String? invitationCode,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Update display name
        await credential.user!.updateDisplayName(fullName);
        
        // Send email verification
        await credential.user!.sendEmailVerification();
        
        return AuthUser.fromFirebaseUser(credential.user!);
      }
      
      return null;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuthException(e);
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Reload current user
  Future<void> reload() async {
    await _firebaseAuth.currentUser?.reload();
  }
}

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

  factory AuthUser.fromFirebaseUser(User user) {
    return AuthUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      isEmailVerified: user.emailVerified,
    );
  }

  app_user.User toAppUser({
    required String location,
    required app_user.SkillLevel skillLevel,
    String? profileImageURL,
  }) {
    return app_user.User(
      userId: id,
      displayName: displayName ?? '',
      email: email,
      skillLevel: skillLevel,
      location: location,
      profileImageURL: profileImageURL,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

class AuthException implements Exception {
  final String message;
  final String code;

  AuthException({required this.message, required this.code});

  factory AuthException.fromFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthException(
          message: 'No user found with this email address.',
          code: e.code,
        );
      case 'wrong-password':
        return AuthException(
          message: 'Invalid password.',
          code: e.code,
        );
      case 'email-already-in-use':
        return AuthException(
          message: 'An account already exists with this email address.',
          code: e.code,
        );
      case 'weak-password':
        return AuthException(
          message: 'Password is too weak.',
          code: e.code,
        );
      case 'invalid-email':
        return AuthException(
          message: 'Invalid email address.',
          code: e.code,
        );
      case 'user-disabled':
        return AuthException(
          message: 'This account has been disabled.',
          code: e.code,
        );
      case 'too-many-requests':
        return AuthException(
          message: 'Too many failed attempts. Please try again later.',
          code: e.code,
        );
      default:
        return AuthException(
          message: e.message ?? 'An authentication error occurred.',
          code: e.code,
        );
    }
  }

  @override
  String toString() => message;
}