import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Creates 4 test users for app testing
///
/// Run with: dart scripts/create_test_users.dart
///
/// Test Users:
///   1. test.player1@pickle.test / TestPass123!
///   2. test.player2@pickle.test / TestPass123!
///   3. test.player3@pickle.test / TestPass123!
///   4. test.player4@pickle.test / TestPass123!

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY']!,
      authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN']!,
      projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
      messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
      appId: dotenv.env['FIREBASE_APP_ID']!,
    ),
  );

  print('==========================================');
  print('   PICKLE CONNECT - Test User Setup');
  print('==========================================\n');

  await createTestUsers();

  print('\n==========================================');
  print('   Test Users Ready!');
  print('==========================================');
  print('\nYou can now log in with any of these accounts:');
  print('  Email: test.player1@pickle.test');
  print('  Email: test.player2@pickle.test');
  print('  Email: test.player3@pickle.test');
  print('  Email: test.player4@pickle.test');
  print('  Password (all): TestPass123!');
  print('==========================================\n');

  exit(0);
}

Future<void> createTestUsers() async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> testUsers = [
    {
      'email': 'test.player1@pickle.test',
      'password': 'TestPass123!',
      'displayName': 'Player One',
      'skillLevel': 'Beginner',
      'location': 'Court A - Downtown',
    },
    {
      'email': 'test.player2@pickle.test',
      'password': 'TestPass123!',
      'displayName': 'Player Two',
      'skillLevel': 'Intermediate',
      'location': 'Court B - Westside',
    },
    {
      'email': 'test.player3@pickle.test',
      'password': 'TestPass123!',
      'displayName': 'Player Three',
      'skillLevel': 'Intermediate',
      'location': 'Court A - Downtown',
    },
    {
      'email': 'test.player4@pickle.test',
      'password': 'TestPass123!',
      'displayName': 'Player Four',
      'skillLevel': 'Advanced+',
      'location': 'Court C - Eastside',
    },
  ];

  for (int i = 0; i < testUsers.length; i++) {
    final userData = testUsers[i];

    try {
      print('Creating user ${i + 1}/4: ${userData['displayName']}...');

      // Check if user already exists
      try {
        await auth.signInWithEmailAndPassword(
          email: userData['email']!,
          password: userData['password']!,
        );
        print('  -> Already exists, skipping creation');
        await auth.signOut();
        continue;
      } catch (e) {
        // User doesn't exist, proceed with creation
      }

      // Create Firebase Auth user
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: userData['email']!,
        password: userData['password']!,
      );

      final uid = userCredential.user!.uid;

      // Update display name in Auth
      await userCredential.user?.updateDisplayName(userData['displayName']);

      // Create Firestore user profile
      await firestore.collection('users').doc(uid).set({
        'userId': uid,
        'email': userData['email'],
        'displayName': userData['displayName'],
        'skillLevel': userData['skillLevel'],
        'location': userData['location'],
        'matchesPlayed': 0,
        'matchesWon': 0,
        'matchesLost': 0,
        'winRate': 0.0,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('  -> Created successfully (UID: $uid)');

      // Sign out before creating next user
      await auth.signOut();

      // Small delay to avoid rate limiting
      await Future.delayed(Duration(milliseconds: 300));

    } catch (e) {
      print('  -> FAILED: $e');
    }
  }
}
