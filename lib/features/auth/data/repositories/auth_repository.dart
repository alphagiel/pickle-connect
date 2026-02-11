import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

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

        // Reload the user to get updated display name
        await credential.user!.reload();

        // Debug: Check the display name after update
        print('=== Signup Debug ===');
        print('Full name provided: $fullName');
        print('User displayName after update: ${credential.user!.displayName}');

        // Create user profile in Firestore
        await _createUserProfile(credential.user!, fullName, email);

        return AuthUser.fromFirebaseUser(credential.user!);
      }
      
      return null;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuthException(e);
    }
  }

  // Send password reset email via custom Cloud Function (uses Mailpit in dev)
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      final functions = FirebaseFunctions.instance;
      final callable = functions.httpsCallable('requestPasswordReset');
      await callable.call({'email': email});
    } on FirebaseFunctionsException catch (e) {
      throw AuthException(
        message: e.message ?? 'Failed to send password reset email',
        code: e.code,
      );
    } catch (e) {
      throw AuthException(
        message: 'Failed to send password reset email',
        code: 'unknown',
      );
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

  // Re-authenticate user with password (required before account deletion)
  Future<void> reauthenticateWithPassword(String password) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null || user.email == null) {
        throw AuthException(message: 'No user is currently signed in.', code: 'no-user');
      }
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuthException(e);
    }
  }

  // Delete the Firebase Auth account
  Future<void> deleteFirebaseAuthAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthException(message: 'No user is currently signed in.', code: 'no-user');
      }
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuthException(e);
    }
  }

  // Create user profile in Firestore
  Future<void> _createUserProfile(User user, String fullName, String email) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final userData = {
        'userId': user.uid,
        'displayName': fullName,
        'email': email,
        'skillLevel': 'Intermediate', // Default skill level
        'location': 'Unknown', // Default location
        'profileImageURL': null,
        'matchesPlayed': 0,
        'matchesWon': 0,
        'matchesLost': 0,
        'winRate': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await firestore.collection('users').doc(user.uid).set(userData);
      print('User profile created in Firestore for user: ${user.uid}');
    } catch (e) {
      print('Error creating user profile in Firestore: $e');
      // Don't throw here - we still want the auth to succeed even if Firestore fails
    }
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
      skillBracket: skillLevel.bracket,
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