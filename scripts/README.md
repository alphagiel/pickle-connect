# Scripts Directory

This directory contains utility scripts for the Pickle Connect app development.

## Available Scripts

### `seed_users.dart` 
Seeds Firebase with 10 dummy pickleball users for testing.

**Prerequisites:**
1. Add `cloud_firestore: ^4.13.6` to `pubspec.yaml` dev_dependencies
2. Run `flutter pub get`

**Usage:**
```bash
# From project root
export PATH="$PATH:/Users/alphagiel/development/flutter/bin"
dart scripts/seed_users.dart
```

**What it creates:**
- 10 Firebase Auth users (email/password)
- 10 Firestore user profiles with:
  - Personal info (name, phone, email)
  - Skill ratings (USTA, UTR)
  - Playing preferences (Singles/Doubles)
  - Location (Clayton/Smithfield)
  - Match statistics (initialized to 0)

**Default password:** `password123` for all users

**Sample users created:**
- alice.smith@email.com (Intermediate, Singles, Clayton)
- bob.johnson@email.com (Advanced, Doubles, Smithfield)
- carol.williams@email.com (Beginner, Singles, Clayton)
- david.brown@email.com (Intermediate, Doubles, Smithfield)
- emma.davis@email.com (Advanced, Singles, Clayton)
- frank.miller@email.com (Intermediate, Doubles, Smithfield)
- grace.wilson@email.com (Beginner, Singles, Clayton)
- henry.moore@email.com (Advanced, Doubles, Smithfield)
- iris.taylor@email.com (Intermediate, Singles, Clayton)
- jack.anderson@email.com (Advanced, Doubles, Smithfield)

## Running Scripts

Make sure Flutter is in your PATH:
```bash
export PATH="$PATH:/Users/alphagiel/development/flutter/bin"
```

Run any script with:
```bash
dart scripts/script_name.dart
```