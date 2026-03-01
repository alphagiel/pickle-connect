# Pickle Connect

## Architecture
Flutter mobile app (iOS, live on App Store) for competitive pickleball.

**Structure:** Feature-based in `lib/`
```
lib/
├── core/        # Shared utilities & services
├── features/    # auth, doubles, profile, proposals, singles, standings
├── shared/      # Shared widgets, models, extensions
└── main.dart
```

## Tech Stack
- Flutter 3.10+, Dart 3.0+
- State: Riverpod (flutter_riverpod)
- Backend: Firebase (Firestore, Cloud Functions, Auth)
- API: Dio + Retrofit
- Models: Freezed + JSON Serializable (requires code generation)
- Navigation: GoRouter
- Local storage: Hive + Shared Preferences
- Notifications: Firebase Messaging, Resend (email)

## Common Commands
```
flutter pub get                    # Install dependencies
flutter test                       # Run tests
flutter analyze                    # Lint
dart format lib/ test/             # Format code
flutter packages pub run build_runner build --delete-conflicting-outputs  # Code gen
flutter run -d <device-id>        # Run app
flutter run -d <device-id> --dart-define=USE_EMULATORS=false  # Run with prod Firebase
flutter build ipa --release        # Build for App Store
```

## Conventions
- Always run build_runner after modifying `@freezed` models
- Use `ref.watch()` for reactive state, `ref.invalidate()` to refresh cached data
- Debug mode connects to local Firebase Emulators by default (`USE_EMULATORS=true`)
- Environment variables in `.env`, loaded via flutter_dotenv
- Tests use mocktail for mocking
