import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'firebase_options.dart';
// import 'shared/services/notification_service.dart';  // Temporarily disabled
import 'shared/services/proposal_cleanup_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Connect to Firebase Emulators in debug mode
  // Set to true to use local emulators, false for production Firebase
  const useEmulators = bool.fromEnvironment('USE_EMULATORS', defaultValue: false);
  if (kDebugMode && useEmulators) {
    await _connectToEmulators();
  }

  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize notifications
  // await NotificationService.initialize();  // Temporarily disabled
  
  runApp(
    const ProviderScope(
      child: PickleConnectApp(),
    ),
  );
}

class PickleConnectApp extends ConsumerWidget {
  const PickleConnectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    // Run cleanup on app startup
    ref.read(proposalCleanupServiceProvider).runStartupCleanup();

    return MaterialApp.router(
      title: 'Pickle Connect',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}

/// Connect to Firebase Emulators for local development
Future<void> _connectToEmulators() async {
  const host = 'localhost';

  // Auth emulator
  await FirebaseAuth.instance.useAuthEmulator(host, 9099);

  // Firestore emulator
  FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);

  debugPrint('🔧 Connected to Firebase Emulators');
}