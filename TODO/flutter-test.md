# Flutter Widget Testing — Firebase Initialization Fix

## Current Problem

Widget test `test/widget_test.dart` fails with Firebase error:
```
[core/no-app] No Firebase App '[DEFAULT]' has been created - call Firebase.initializeApp()
```

**Root cause:** `Firebase.initializeApp()` cannot run in pure Dart test environment (no real Firebase).

## Impact

- Basic smoke test "App launches without crashing" is skipped
- No UI widget tests can run until Firebase is mocked

## Solutions

### Option 1: Mock Firebase Core (Recommended)

Create a mock `FirebaseCore` provider to stub `Firebase.initializeApp()`:

1. **Create test helper** `test/helpers/firebase_mocks.dart`:
   ```dart
   import 'package:firebase_core/firebase_core.dart';
   import 'package:mocktail/mocktail.dart';

   class MockFirebaseCore extends Mock implements FirebaseCore {}
   class MockFirebaseApp extends Mock implements FirebaseApp {}
   ```

2. **Set up mock in test**:
   ```dart
   setUpAll(() {
     final mockFirebaseCore = MockFirebaseCore();
     final mockFirebaseApp = MockFirebaseApp();

     when(() => mockFirebaseCore.initializeApp(
       options: any(named: 'options'),
     )).thenAnswer((_) async => mockFirebaseApp);

     // Inject mock via dependency injection
   });
   ```

### Option 2: Skip Firebase Initialization in Test Mode

Modify `main.dart` to conditionally skip Firebase init in tests:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Skip Firebase in test environment
  if (!kTestMode) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
```

### Option 3: Create Test-Specific App Wrapper

Create a `TestPickleConnectApp` that bypasses Firebase dependencies:

```dart
class TestPickleConnectApp extends ConsumerWidget {
  const TestPickleConnectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use mock providers instead of real Firebase ones
    return MaterialApp.router(
      title: 'Pickle Connect (Test)',
      routerConfig: ref.watch(testRouterProvider),
    );
  }
}
```

## Implementation Steps

### Phase 1: Setup Mock Infrastructure

1. **Add test dependencies** (already in `pubspec.yaml`):
   - `mocktail: ^1.0.2` ✓ already present

2. **Create test helpers**:
   - `test/helpers/firebase_mocks.dart` - Firebase mocks
   - `test/helpers/test_providers.dart` - Override providers for tests

3. **Update `test/widget_test.dart`**:
   - Remove `skip` flag
   - Add `setUpAll()` with mock initialization
   - Use `ProviderScope(overrides: [...])` to inject mocks

### Phase 2: Fix Main Initialization

1. **Refactor `main()`** in `lib/main.dart`:
   - Extract Firebase initialization into separate function
   - Add `kTestMode` check from `flutter_test`

2. **Create test-specific entry point**:
   - `test/test_main.dart` - Sets up mocks before running tests

### Phase 3: Add More Widget Tests

Once Firebase is mocked, add tests for:
- Login page validation
- Signup form
- Proposal creation flow
- Navigation between screens

## Files to Modify

| File | Changes Needed |
|------|---------------|
| `test/widget_test.dart` | Remove skip, add mock setup |
| `lib/main.dart` | Add test mode check |
| `test/helpers/firebase_mocks.dart` | Create new file |
| `test/helpers/test_providers.dart` | Create new file |
| `pubspec.yaml` | Verify mocktail is available |

## Testing Strategy

### Script Tests vs Widget Tests

| Type | Location | Purpose | Works? |
|------|----------|---------|--------|
| **Script tests** | `/scripts/` | Run against Firebase emulators | ✓ Works |
| **Widget tests** | `/test/` | Test UI without real Firebase | ✘ Broken |

### Current Test Structure

```
test/
└── widget_test.dart    # Basic smoke test (currently failing)

scripts/
├── test_singles_happy_path.dart      # Works with emulators
└── test_singles_edge_cases.dart      # Works with emulators
```

## Priority

**Medium priority** - Widget tests are valuable for preventing UI regressions but:
- Script tests already validate core logic against emulators
- App is live and functional without widget tests
- Fix requires non-trivial mocking setup

## Estimated Effort

**2–4 hours** for experienced Flutter developer familiar with:
- Mocktail mocking
- Riverpod provider overriding
- Firebase dependency injection

## Related Issues

- 557 lint warnings in codebase (mostly `prefer_const_constructors`, `avoid_print`)
- These should be fixed separately but don't block tests

## Next Actions

1. [ ] Create `test/helpers/firebase_mocks.dart`
2. [ ] Create `test/helpers/test_providers.dart`
3. [ ] Update `test/widget_test.dart` with mock setup
4. [ ] Add conditional Firebase init in `lib/main.dart`
5. [ ] Run `flutter test` to verify fix
6. [ ] Add additional widget tests for key screens