import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Add this to your pubspec.yaml under dev_dependencies:
// cloud_firestore: ^4.13.6

Future<void> main() async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBvnbybVtaXQmYM5nkCyGJZWzVxfY1qN1M",
      authDomain: "myapp1-c6012.firebaseapp.com",
      projectId: "myapp1-c6012",
      storageBucket: "myapp1-c6012.appspot.com",
      messagingSenderId: "123456789",
      appId: "1:123456789:web:abcdef123456",
    ),
  );

  print('🏓 Starting to seed pickleball users...\n');

  await seedPickleballUsers();

  print('\n✅ Finished seeding users!');
  exit(0);
}

Future<void> seedPickleballUsers() async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> users = [
    {
      'email': 'alice.smith@email.com',
      'password': 'password123',
      'fullName': 'Alice Smith',
      'phoneNumber': '+1-555-0101',
      'skillLevel': 'Intermediate',
      'ustaRating': '3.5',
      'utrRating': '4.2',
      'preferredPlayStyle': 'Singles',
      'location': 'Clayton',
      'yearsPlaying': 3,
    },
    {
      'email': 'bob.johnson@email.com',
      'password': 'password123',
      'fullName': 'Bob Johnson',
      'phoneNumber': '+1-555-0102',
      'skillLevel': 'Advanced',
      'ustaRating': '4.0',
      'utrRating': '5.1',
      'preferredPlayStyle': 'Doubles',
      'location': 'Smithfield',
      'yearsPlaying': 5,
    },
    {
      'email': 'carol.williams@email.com',
      'password': 'password123',
      'fullName': 'Carol Williams',
      'phoneNumber': '+1-555-0103',
      'skillLevel': 'Beginner',
      'ustaRating': '2.5',
      'utrRating': '2.8',
      'preferredPlayStyle': 'Singles',
      'location': 'Clayton',
      'yearsPlaying': 1,
    },
    {
      'email': 'david.brown@email.com',
      'password': 'password123',
      'fullName': 'David Brown',
      'phoneNumber': '+1-555-0104',
      'skillLevel': 'Intermediate',
      'ustaRating': '3.0',
      'utrRating': '3.7',
      'preferredPlayStyle': 'Doubles',
      'location': 'Smithfield',
      'yearsPlaying': 2,
    },
    {
      'email': 'emma.davis@email.com',
      'password': 'password123',
      'fullName': 'Emma Davis',
      'phoneNumber': '+1-555-0105',
      'skillLevel': 'Advanced',
      'ustaRating': '4.5',
      'utrRating': '6.2',
      'preferredPlayStyle': 'Singles',
      'location': 'Clayton',
      'yearsPlaying': 7,
    },
    {
      'email': 'frank.miller@email.com',
      'password': 'password123',
      'fullName': 'Frank Miller',
      'phoneNumber': '+1-555-0106',
      'skillLevel': 'Intermediate',
      'ustaRating': '3.5',
      'utrRating': '4.5',
      'preferredPlayStyle': 'Doubles',
      'location': 'Smithfield',
      'yearsPlaying': 4,
    },
    {
      'email': 'grace.wilson@email.com',
      'password': 'password123',
      'fullName': 'Grace Wilson',
      'phoneNumber': '+1-555-0107',
      'skillLevel': 'Beginner',
      'ustaRating': '3.0',
      'utrRating': '3.2',
      'preferredPlayStyle': 'Singles',
      'location': 'Clayton',
      'yearsPlaying': 1,
    },
    {
      'email': 'henry.moore@email.com',
      'password': 'password123',
      'fullName': 'Henry Moore',
      'phoneNumber': '+1-555-0108',
      'skillLevel': 'Advanced',
      'ustaRating': '4.0',
      'utrRating': '5.8',
      'preferredPlayStyle': 'Doubles',
      'location': 'Smithfield',
      'yearsPlaying': 6,
    },
    {
      'email': 'iris.taylor@email.com',
      'password': 'password123',
      'fullName': 'Iris Taylor',
      'phoneNumber': '+1-555-0109',
      'skillLevel': 'Intermediate',
      'ustaRating': '3.5',
      'utrRating': '4.0',
      'preferredPlayStyle': 'Singles',
      'location': 'Clayton',
      'yearsPlaying': 3,
    },
    {
      'email': 'jack.anderson@email.com',
      'password': 'password123',
      'fullName': 'Jack Anderson',
      'phoneNumber': '+1-555-0110',
      'skillLevel': 'Advanced',
      'ustaRating': '4.5',
      'utrRating': '6.5',
      'preferredPlayStyle': 'Doubles',
      'location': 'Smithfield',
      'yearsPlaying': 8,
    },
  ];

  for (int i = 0; i < users.length; i++) {
    final userData = users[i];
    
    try {
      print('👤 Creating user ${i + 1}/10: ${userData['fullName']}...');

      // Create Firebase Auth user
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: userData['email']!,
        password: userData['password']!,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(userData['fullName']);

      // Create Firestore user profile
      await firestore.collection('users').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'email': userData['email'],
        'fullName': userData['fullName'],
        'phoneNumber': userData['phoneNumber'],
        'skillLevel': userData['skillLevel'],
        'ustaRating': userData['ustaRating'],
        'utrRating': userData['utrRating'],
        'preferredPlayStyle': userData['preferredPlayStyle'],
        'location': userData['location'],
        'yearsPlaying': userData['yearsPlaying'],
        'isActive': true,
        'role': 'player', // Default role
        'joinDate': FieldValue.serverTimestamp(),
        'lastActive': FieldValue.serverTimestamp(),
        'matchesPlayed': 0,
        'matchesWon': 0,
        'currentStreak': 0,
        'profileComplete': true,
      });

      print('   ✅ ${userData['fullName']} created successfully');
      
      // Small delay to avoid rate limiting
      await Future.delayed(Duration(milliseconds: 500));
      
    } catch (e) {
      print('   ❌ Failed to create ${userData['fullName']}: $e');
    }
  }
}