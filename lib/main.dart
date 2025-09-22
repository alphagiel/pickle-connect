import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

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