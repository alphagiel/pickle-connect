# Test Scripts

Integration tests for the Pickle Connect proposal lifecycle, running against Firebase Emulators via direct HTTP/REST calls (no Flutter dependency).

## Prerequisites

Firebase Emulators must be running:

```bash
firebase emulators:start
```

Default emulator ports:
- Auth: `localhost:9099`
- Firestore: `localhost:8080`
- Emulator UI: `localhost:4000`

## Test Scripts

### Singles

| Script | Description | Checks |
|--------|-------------|--------|
| `test_singles_happy_path.dart` | Full lifecycle: create → accept → score → confirm → standings | ~21 |
| `test_singles_edge_cases.dart` | 6 scenarios: cancel open, cancel accepted, unaccept, score rejection, partial confirm then reject, opponent wins | ~46 |

### Doubles

| Script | Description | Checks |
|--------|-------------|--------|
| `test_doubles_happy_path.dart` | Full lifecycle: create → join requests → approve teams → score → confirm → standings for all 4 players | ~29 |
| `test_doubles_edge_cases.dart` | 6 scenarios: cancel, decline request, player leaves, partner invite flow, score rejection, team 2 wins | ~47 |

## Running Tests

```bash
# Singles
dart run scripts/test_singles_happy_path.dart
dart run scripts/test_singles_edge_cases.dart

# Doubles
dart run scripts/test_doubles_happy_path.dart
dart run scripts/test_doubles_edge_cases.dart
```

### Flags

| Flag | Description |
|------|-------------|
| `--no-cleanup` | Keep test data in the emulator after the run. Useful for inspecting data in the Emulator UI or logging into the app as a test user. |

```bash
# Run and preserve data for inspection
dart run scripts/test_doubles_happy_path.dart --no-cleanup
```

When using `--no-cleanup`, you can:
- Browse Firestore data at `http://localhost:4000/firestore`
- View Auth users at `http://localhost:4000/auth`
- Log into the Flutter app (`flutter run -d chrome`) with test user credentials (password: `TestPass123!`)

## Other Scripts

| Script | Description |
|--------|-------------|
| `seed_users.dart` | Seeds the emulator with sample pickleball users (requires Flutter, uses Firebase SDK directly) |
| `create_test_users.dart` | Creates test users via REST API |

## Architecture

All test scripts share `test_helpers.dart`, which provides:

- **HTTP helpers** — Generic `request()` for GET/POST/PATCH/DELETE
- **Auth helpers** — `createAuthUser()`, `signIn()` against the Auth emulator
- **Firestore REST helpers** — `fsCreate()`, `fsGet()`, `fsUpdate()`, `fsDelete()`, `fsCommit()` with value encoding/decoding
- **Singles helpers** — `createSinglesProposal()`, `acceptProposal()`, `submitScores()`, `confirmScores()`, `cancelProposal()`, `clearScores()`
- **Doubles helpers** — `createDoublesProposal()`, `requestJoinDoubles()`, `approveDoublesPlayer()`, `declineDoublesPlayer()`, `leaveDoublesProposal()`, `invitePartner()`, `confirmPartnerInvite()`
- **Test utilities** — `check()` for assertions, `waitForStandings()` for Cloud Function polling, `parseCleanupFlag()`

### Key Implementation Detail

Firestore REST API doesn't support `arrayUnion`/`arrayRemove` for complex objects (maps). The doubles helpers work around this by reading the document, modifying the `doublesPlayers` array in Dart, and writing the full array back via `fsUpdate()`. Only `playerIds` (array of strings) and `scoreConfirmedBy` can use `fsCommit` transforms.
