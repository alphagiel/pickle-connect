# Pickle Connect

A competitive pickleball app for organizing matches, tracking standings, and connecting with players in your community.

**Now live on the [iOS App Store](https://apps.apple.com/app/pickle-connect)!**

## Features

- **Singles & Doubles Matches** — Propose, accept, and score both singles and doubles matches
- **Match Proposals** — Create open proposals by skill bracket; other players can accept or request to join
- **Doubles Lobbies** — Create a doubles match solo or with a partner, then let others request to join
- **Zone-Based Communities** — Players see proposals and standings scoped to their geographic zone
- **Live Standings** — Seasonal ladder rankings with win/loss records and streaks, filterable by skill bracket and zone
- **Player Search** — Real-time search and filtering to find players at your level
- **Email Notifications** — Automated emails for proposals, acceptances, match results, and more
- **Deep Linking** — Tap email links to jump straight into a match in the app

## Tech Stack

- **Frontend:** Flutter (iOS) with Riverpod state management
- **Backend:** Firebase (Firestore, Cloud Functions, Authentication)
- **Email:** Resend (production), Mailpit (local dev)
- **Models:** Freezed + JSON Serializable with code generation

## Roadmap

- [x] Match proposal and challenge system
- [x] Tennis scoring system
- [x] Real-time player search and filtering
- [x] Seasonal ladder rankings with filters
- [x] Singles & Doubles support
- [x] Email notification system
- [x] Zone-based community support
- [x] App Store launch (iOS)
- [ ] Tournament registration system
- [ ] Court booking system enhancement
- [ ] Push notifications
- [ ] Android release (Google Play)

---

## Architecture

```
  ┌─────────────────────────────────────────────────────────────────────┐
  │                        PRESENTATION LAYER                          │
  │                                                                    │
  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐          │
  │  │   Auth   │  │Proposals │  │Standings │  │ Profile  │          │
  │  │ Feature  │  │ Feature  │  │ Feature  │  │ Feature  │          │
  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘          │
  │                                                                    │
  │  MainNavigation (Shell)                                            │
  │    AppBar: Title + Profile Menu (Edit Profile / Logout)            │
  │    BottomNav: [Singles] [Doubles]                                   │
  │    Sub-tabs: Proposals | Rankings                                   │
  └────────────────────────────┬────────────────────────────────────────┘
                               ▼
  ┌─────────────────────────────────────────────────────────────────────┐
  │                    STATE MANAGEMENT (Riverpod)                      │
  │                                                                    │
  │  StreamProviders (Real-time)         StateProviders (UI State)     │
  │  - authStateProvider                 - selectedSkillLevelProvider   │
  │  - currentUserProfileProvider        - proposalStatusFilter         │
  │  - openProposalsProvider             - dateFilterProvider           │
  │  - standingsProvider                 - creatorFilterProvider        │
  │                                                                    │
  │  StateNotifierProviders              Regular Providers              │
  │  - authNotifierProvider              - filteredProposalsProvider    │
  │                                      - routerProvider (GoRouter)    │
  └────────────────────────────┬────────────────────────────────────────┘
                               ▼
  ┌─────────────────────────────────────────────────────────────────────┐
  │                          DATA LAYER                                 │
  │                                                                    │
  │  Repositories                     Models (Freezed)                 │
  │  - AuthRepository                 - User                           │
  │  - ProposalsRepository            - Proposal                       │
  │  - StandingsRepository            - Standing                       │
  │  - DoublesStandingsRepository     - AppZone                        │
  │  - UsersRepository                - DoublesPlayer                  │
  │  - ZonesRepository                - GameScore / Scores             │
  └────────────────────────────┬────────────────────────────────────────┘
                               ▼
  ┌─────────────────────────────────────────────────────────────────────┐
  │                        FIREBASE BACKEND                             │
  │                                                                    │
  │  ┌──────────────┐  ┌───────────────┐  ┌──────────────────┐        │
  │  │ Firebase Auth │  │   Firestore   │  │ Cloud Functions  │        │
  │  │ - Email/Pass  │  │ - users/      │  │ - Email triggers │        │
  │  │ - Session mgmt│  │ - proposals/  │  │ - Standings calc │        │
  │  │              │  │ - standings/  │  │ - Score confirm  │        │
  │  │              │  │ - zones/      │  │ - Expiration     │        │
  │  └──────────────┘  └───────────────┘  └──────────────────┘        │
  └─────────────────────────────────────────────────────────────────────┘
```

### Project Structure

```
lib/
├── core/                    # Theme & utilities
│   ├── theme/               #   app_theme.dart
│   └── utils/               #   app_router.dart, season_utils.dart
├── features/                # Feature modules
│   ├── auth/                #   Login, signup, password reset
│   │   ├── data/repositories/
│   │   ├── domain/entities/
│   │   └── presentation/pages/, providers/
│   ├── doubles/             #   Doubles match pages
│   ├── proposals/           #   Singles match proposals
│   ├── standings/           #   Ladder rankings
│   └── profile/             #   User profile
├── shared/                  # Shared across features
│   ├── models/              #   Freezed models (User, Proposal, etc.)
│   ├── providers/           #   Riverpod providers
│   ├── repositories/        #   Firestore repositories
│   ├── services/            #   Business logic
│   └── widgets/             #   Common widgets
├── main.dart                # App entry point
└── firebase_options.dart    # Firebase config

functions/
├── src/
│   ├── triggers/            # Firestore event triggers
│   ├── templates/           # Email HTML templates
│   ├── services/email/      # Email provider abstraction
│   └── migrations/          # Data migration scripts
```

### Key Concepts

**Skill Levels & Brackets**

| Bracket | Levels |
|---------|--------|
| Beginner | 1.0 - 1.5 |
| Novice | 2.0 - 2.5 |
| Intermediate | 3.0 - 3.5 |
| Advanced | 4.0 - 4.5 |
| Expert | 5.0+ |

**Proposal Lifecycle:** `open → accepted → completed (with scores)` or `open → expired/canceled`

**Scoring:** Best-of-3 games, per-game scoring. Both players confirm scores for match completion.

### Data Flow (Create & Accept a Proposal)

```
User 1: CreateProposalPage
  → proposalActions.createProposal()
  → ProposalsRepository.createProposal()
  → Firestore proposals.add()
  → Stream update emitted
                                    User 2: openProposalsProvider emits new list
                                    → ProposalsPage shows new card
                                    → tap Accept → acceptProposal()
                                    → Firestore status='accepted'
```

### Quick Reference for Developers

| Layer | Location | Purpose |
|-------|----------|---------|
| UI/Pages | `lib/features/*/presentation/pages/` | User-facing screens |
| Widgets | `lib/features/*/presentation/widgets/` | Reusable UI components |
| State | `lib/shared/providers/` | Riverpod providers |
| Data Access | `lib/shared/repositories/` | Firestore queries |
| Models | `lib/shared/models/` | Freezed data classes |
| Routing | `lib/core/utils/app_router.dart` | GoRouter config |
| Theme | `lib/core/theme/` | Colors & styling |

Key Riverpod patterns:
- `ref.watch(provider)` for reactive UI updates
- `ref.read(provider)` for one-time actions
- `ref.invalidate(provider)` to refresh cached data

---

## Getting Started

### Prerequisites

- Flutter SDK
- Firebase CLI (`npm install -g firebase-tools`)
- Java 21+ (for Firebase emulators)
- Docker Desktop (optional, for Mailpit email testing)

### Run Locally (with Firebase Emulators)

```bash
# 1. Install dependencies
flutter pub get

# 2. Start Mailpit (optional, for email testing)
docker compose up -d

# 3. Build Cloud Functions
cd functions && npm run build && cd ..

# 4. Start Firebase emulators
firebase emulators:start --import=./emulator-data --export-on-exit=./emulator-data

# 5. Run the app (in a separate terminal)
flutter run --dart-define=USE_EMULATORS=true
```

### Run Against Production Firebase

```bash
flutter run
```

### Code Generation

After modifying any `@freezed` models:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Quick Reference

| Mode | Command | Backend |
|------|---------|---------|
| Dev | `flutter run --dart-define=USE_EMULATORS=true` | Local emulators |
| Prod | `flutter run` | Live Firebase |

### Local Development URLs

| Service | URL |
|---------|-----|
| Emulator UI | http://127.0.0.1:4000 |
| Firestore | http://127.0.0.1:4000/firestore |
| Auth | http://127.0.0.1:4000/auth |
| Mailpit | http://127.0.0.1:8025 |

### Platform-Specific Setup

**macOS — Install Java 21+ (for Firebase emulators)**
```bash
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 21.0.9-amzn
```

**macOS — Fix Port Conflicts**
```bash
lsof -ti :8080,9000,5001,9099,4000 | xargs kill -TERM 2>/dev/null || true
```

**Windows — Fix Port Conflicts**
```powershell
foreach ($port in @(8080,9000,5001,9099,4000)) {
  Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue |
    ForEach-Object { Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }
}
```

### Preserving Emulator Data

```bash
# Auto-save on exit
firebase emulators:start --import=./emulator-data --export-on-exit=./emulator-data

# Manual export while running
firebase emulators:export ./emulator-data
```

---

## Email Notification System

### Architecture

```text
Firestore Write → Cloud Function Trigger → Email Service Abstraction → Mailpit (dev) / Resend (prod)
```

### Email Service

- Common `send()` / `sendBatch()` interface
- **MailpitService:** Nodemailer → `localhost:1025` (local dev)
- **ResendService:** `resend` npm package (production, 3,000 emails/month free tier)
- Factory auto-selects service based on environment
- Responsive HTML templates with inline CSS, deep links (`pickleconnect://`), and unsubscribe links

### Singles Email Events

| Event | Recipients | Firestore Trigger |
|---|---|---|
| Welcome email | New user | `users/{userId}` created |
| Account deleted | Deleted user | `users/{userId}` deleted |
| New proposal | Users in same skill bracket & zone | `proposals/{id}` created (`status = open`) |
| Proposal accepted | Proposal creator | `proposals/{id}` status → `accepted` |
| Proposal unaccepted | Proposal creator | `proposals/{id}` status → `open` |
| Proposal cancelled | Accepter + creator | `proposals/{id}` status → `canceled` |
| Match result recorded | Both players | `proposals/{id}` `scores` added |

### Doubles Email Events

| Event | Recipients | Firestore Trigger |
|---|---|---|
| Doubles proposal created | Users in same bracket & zone | `proposals/{id}` created (doubles) |
| Partner invited | Invited player | `proposals/{id}` player added as `invited` |
| Partner confirmed | Creator | `proposals/{id}` player status → `confirmed` |
| Join request | Proposal creator | `proposals/{id}` player added as `requested` |
| Player approved | Approved player | `proposals/{id}` player status → `confirmed` |
| Lobby full | All 4 confirmed players | `proposals/{id}` 4th player confirmed |
| Player declined | Declined player | `proposals/{id}` player removed (was `requested`) |
| Player left | Creator | `proposals/{id}` player removed (was `confirmed`) |
| Doubles cancelled | All lobby players | `proposals/{id}` status → `canceled` (doubles) |
| Scores confirmed | Other team players | `proposals/{id}` `scoreConfirmedBy` grows |
| Doubles match result | All 4 players | `proposals/{id}` `scores` added (doubles) |

### Cloud Function Triggers

- `onUserCreated` — welcome email
- `onUserDeleted` — farewell/account deleted email
- `onProposalCreated` — broadcast + creator confirmation + doubles partner invites
- `onProposalUpdated` — accepted, unaccepted, cancelled, scores, doubles lifecycle
- `onProposalDeleted` — notify accepter of cancellation

---

## Doubles Feature

### Data Model

- `MatchType` enum: `singles`, `doubles`
- `DoublesPlayerStatus` enum: `confirmed`, `invited`, `requested`
- `DoublesPlayer` freezed class: `userId`, `displayName`, `team`, `status`, `invitedBy`
- `Proposal` extended with: `matchType`, `doublesPlayers`, `openSlots`, `playerIds`
- `playerIds` is a denormalized `List<String>` for Firestore `array-contains` queries
- `@JsonSerializable(explicitToJson: true)` on `Proposal` and `Scores` for nested object serialization

### Scoring

- Reuses existing `GameScore`/`Scores` model (Team 1 = creatorScore, Team 2 = opponentScore)
- Singles: 2 individual confirmations needed
- Doubles: at least 1 player from each team must confirm

---

## Zone-Based Communities

Players only see proposals and standings within their geographic zone. Zones are stored in Firestore (not hardcoded) so new communities can be added without app updates.

### Zone Interaction Model

- **Home zone locked for playing:** Users pick a home zone at signup. They can only create proposals and be ranked in their home zone.
- **Browse other zones:** Standings page has a zone dropdown so any user can VIEW other zones' leaderboards (read-only).
- **Proposals locked to home zone:** Users only see and create proposals in their home zone.
- **Zone change via Edit Profile:** Changing home zone resets standings in the old zone.

### Firestore Structure

```
zones/
  east_triangle   → { displayName, description, cities[], region, active, createdAt }
  west_triangle   → { ... }

users/{uid}       → { ..., zone: "east_triangle" }
proposals/{id}    → { ..., zone: "east_triangle" }

standings/{zone}_{bracket}/players/{uid}          → { ... }
doubles_standings/{zone}_{bracket}/players/{uid}  → { ... }
```

### Scalability

- Zones live in Firestore `zones/` collection — add new zones without app updates
- Each zone doc has: `id`, `displayName`, `description`, `cities[]`, `region`, `active`, `createdAt`
- To onboard a new community: create a Firestore doc → it appears in all dropdowns instantly

---

## Deployment

Bundle ID (both platforms): `com.pickleconnect.app`

| Platform | Status |
|----------|--------|
| iOS | Live on App Store |
| Android | Awaiting Google Play verification |

### Build Commands

```bash
# iOS
flutter build ipa --release
# -> build/ios/ipa/pickle_connect.ipa

# Android (Play Store)
flutter build appbundle --release
# -> build/app/outputs/bundle/release/app-release.aab

# Android (direct install)
flutter build apk --release
# -> build/app/outputs/flutter-apk/app-release.apk
```

### Deploy Cloud Functions

```bash
cd functions && npm run build && firebase deploy --only functions
```

### Firebase Secrets

```bash
firebase functions:secrets:set RESEND_API_KEY
```

### iOS Deployment

**Upload to App Store Connect:**
- **Xcode:** Open `ios/Runner.xcworkspace` → Product → Archive → Distribute
- **Transporter:** Drag and drop the `.ipa` file
- **CLI:** `xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey YOUR_KEY --apiIssuer YOUR_ISSUER`

**App Store Connect details:**
- Name: `Pickle Connect`
- Bundle ID: `com.pickleconnect.app`
- SKU: `pickleconnect-ios-001`
- Category: Sports

**Screenshot sizes:**

| Device | Size |
|--------|------|
| iPhone 6.7" | 1290 x 2796 |
| iPhone 6.5" | 1284 x 2778 |
| iPhone 5.5" | 1242 x 2208 |
| iPad Pro 13" | 2064 x 2752 |
| iPad Pro 11" | 1668 x 2388 |

### Android Deployment

**Release signing:**

| Property | Value |
|----------|-------|
| Keystore | `android/app/pickle-connect-release.jks` |
| Alias | `pickle-connect` |

> **Critical:** If you lose `pickle-connect-release.jks`, you can never update this app on Google Play. Back it up.

**Pending steps (after Google verification):**
1. Complete phone verification in Play Console
2. Upload store assets (icon 512x512, feature graphic 1024x500, min 2 screenshots)
3. Add privacy policy URL
4. Fill out content rating + data safety forms
5. Submit production release

**Data Safety Form:**

| Question | Answer |
|----------|--------|
| Collects user data? | Yes |
| Email address | Yes (account) |
| Name | Yes (display name) |
| User IDs | Yes (Firebase auth) |
| App activity | Yes (match history) |
| Shared with third parties? | No |
| Encrypted in transit? | Yes (HTTPS/TLS) |
| Users can request deletion? | Yes |

### Store Listing Content

**Short Description (80 chars max):**
```
Find pickleball players, schedule matches, and track your rankings by skill.
```

**Full Description:**
```
Pickle Connect is the ultimate app for pickleball players looking to find
opponents, schedule matches, and track their competitive journey.

FIND YOUR PERFECT MATCH
Browse match proposals from players in your skill bracket. Whether you're a
beginner or an advanced player, Pickle Connect matches you with players at
your level.

SKILL-BASED MATCHMAKING
Players are organized into five skill brackets: Beginner (1.0-1.5),
Novice (2.0-2.5), Intermediate (3.0-3.5), Advanced (4.0-4.5), Expert (5.0+)

CREATE & ACCEPT MATCH PROPOSALS
Post match proposals with location, date, and time. Browse available matches
filtered by skill level. Accept proposals to connect with other players.

TRACK YOUR MATCHES
Record match scores with best-of-3 game format. Both players confirm scores
for fair results. Access your complete match history.

CLIMB THE LEADERBOARD
Compete for top rankings in your skill bracket. Track wins, losses, and
winning streaks. Medals for top 3 players in each bracket.

Download now and start connecting with pickleball players in your area!
```

### iPad Simulator (for App Store Screenshots)

```bash
xcrun simctl list devices iPad available
xcrun simctl boot <DEVICE-UUID>
open -a Simulator
flutter run -d <DEVICE-UUID> --dart-define=USE_EMULATORS=true
xcrun simctl io booted screenshot ~/Desktop/ipad_screenshot.png
```

---

## Known Build Issues

### Firebase SDK + Xcode version mismatch

Firebase SDK 10.25.0 does NOT build on Xcode 16+. Three errors that all have the same root cause:

1. **`unsupported option '-G'`** — BoringSSL-GRPC 0.0.32 compiler flag issue
2. **`template argument list expected`** — gRPC-Core/C++ 1.62.5 stricter C++ compliance
3. **`non-modular header inside framework module`** — firebase_messaging 14.x header import

**Fix:** Upgrade all Firebase packages together:

| Package | Old (broken) | New (working) |
|---------|-------------|---------------|
| firebase_core | ^2.24.2 | ^4.4.0 |
| firebase_auth | ^4.15.3 | ^6.1.4 |
| cloud_firestore | ^4.13.6 | ^6.1.2 |
| cloud_functions | ^4.5.8 | ^6.0.6 |
| firebase_messaging | ^14.7.10 | ^16.1.1 |

### iOS deployment target must be 16.0+

Firebase SDK 12.x requires iOS 16.0 minimum. Update in three places:
1. `ios/Podfile` line 2: `platform :ios, '16.0'`
2. `ios/Podfile` post_install: `config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'`
3. `ios/Runner.xcodeproj/project.pbxproj`: All `IPHONEOS_DEPLOYMENT_TARGET` entries

### Other gotchas

- **Podfile needs static linkage:** Use `use_frameworks! :linkage => :static`. Firebase with dynamic frameworks causes header resolution problems.
- **Android needs Java 17:** Set `org.gradle.java.home=/path/to/jdk-17` in `android/gradle.properties`.
- **Keystore and secrets are not in git:** `android/key.properties`, `android/app/pickle-connect-release.jks`, and `.env` are gitignored — back them up separately.
- **When pod install acts weird:** `cd ios && rm -rf Pods Podfile.lock && pod install`

---

## Troubleshooting

- **Build errors:** `flutter clean && flutter pub get`
- **Generated files out of date:** `flutter packages pub run build_runner build --delete-conflicting-outputs`
- **State not updating:** Check if provider is properly watched with `ref.watch()`
- **Port conflicts:** Kill processes on emulator ports (8080, 9000, 5001, 9099, 4000)
- **"Java version before 21":** Firebase emulators require Java 21+
- **Firestore serialization errors:** Ensure `@JsonSerializable(explicitToJson: true)` on models with nested objects
- **"You are not currently authenticated":** Warning only, emulators still work locally. Run `firebase login` if needed.

### Versioning

In `pubspec.yaml`:
```yaml
version: 1.0.0+1  # major.minor.patch+buildNumber
```
Bump `buildNumber` for every upload. Both stores reject duplicate build numbers.
