import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository.dart';

// Auth state provider
final authStateProvider = StreamProvider<AuthUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

// Current user provider
final currentUserProvider = Provider<AuthUser?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Auth loading state
final authLoadingProvider = StateProvider<bool>((ref) => false);

// Auth error provider
final authErrorProvider = StateProvider<String?>((ref) => null);

class AuthNotifier extends StateNotifier<AsyncValue<AuthUser?>> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthNotifier(this._authRepository, this._ref) : super(const AsyncValue.loading()) {
    // Listen to auth state changes
    _authRepository.authStateChanges.listen((user) {
      state = AsyncValue.data(user);
    });
  }

  // Sign in
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _ref.read(authLoadingProvider.notifier).state = true;
      _ref.read(authErrorProvider.notifier).state = null;

      final user = await _authRepository.signInWithEmailPassword(
        email: email,
        password: password,
      );

      if (user != null) {
        state = AsyncValue.data(user);
      }
    } on AuthException catch (e) {
      _ref.read(authErrorProvider.notifier).state = e.message;
      state = AsyncValue.error(e, StackTrace.current);
    } catch (e) {
      _ref.read(authErrorProvider.notifier).state = 'An unexpected error occurred';
      state = AsyncValue.error(e, StackTrace.current);
    } finally {
      _ref.read(authLoadingProvider.notifier).state = false;
    }
  }

  // Sign up
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    String? invitationCode,
  }) async {
    try {
      _ref.read(authLoadingProvider.notifier).state = true;
      _ref.read(authErrorProvider.notifier).state = null;

      // TODO: Validate invitation code before creating account
      
      final user = await _authRepository.createUserWithEmailPassword(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        invitationCode: invitationCode,
      );

      if (user != null) {
        state = AsyncValue.data(user);
      }
    } on AuthException catch (e) {
      _ref.read(authErrorProvider.notifier).state = e.message;
      state = AsyncValue.error(e, StackTrace.current);
    } catch (e) {
      _ref.read(authErrorProvider.notifier).state = 'An unexpected error occurred';
      state = AsyncValue.error(e, StackTrace.current);
    } finally {
      _ref.read(authLoadingProvider.notifier).state = false;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      _ref.read(authLoadingProvider.notifier).state = true;
      _ref.read(authErrorProvider.notifier).state = null;

      await _authRepository.sendPasswordResetEmail(email);
      
      // Success - you might want to show a success message
    } on AuthException catch (e) {
      _ref.read(authErrorProvider.notifier).state = e.message;
    } catch (e) {
      _ref.read(authErrorProvider.notifier).state = 'Failed to send password reset email';
    } finally {
      _ref.read(authLoadingProvider.notifier).state = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await _authRepository.sendEmailVerification();
    } catch (e) {
      _ref.read(authErrorProvider.notifier).state = 'Failed to send verification email';
    }
  }
}

// Auth notifier provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthUser?>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository, ref);
});