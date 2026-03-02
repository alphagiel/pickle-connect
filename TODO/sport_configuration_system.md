# Sport Configuration System — Multi-Sport Reusability

## Overview

This document captures the analysis of making Pickle Connect configurable for multiple racket sports (tennis, ping pong, volleyball, badminton, etc.). The core architecture is **~60-70% sport-agnostic** already. The main work involves extracting hardcoded pickleball references into a configurable sport system.

---

## What's Already Sport-Agnostic (No Changes Needed)

- **Match proposal/acceptance workflow** — works for any sport
- **Singles/Doubles match types** — universal across racket sports
- **Zone-based geographic organization** — not tied to any sport
- **Win/loss tracking & standings/rankings** — generic point system
- **Firestore collection names** — `proposals`, `standings`, `users`, `zones` are sport-neutral
- **Authentication, profiles, email notification preferences**
- **Riverpod state management, GoRouter navigation, repository pattern**

---

## What Needs to Change

### Tier 1: Low Effort — Strings & Branding

| Area | Current State | Files | Change Required |
|------|--------------|-------|-----------------|
| App name | "Pickle Connect" hardcoded in ~8 places | `main.dart`, `main_navigation.dart`, `AndroidManifest.xml`, `Info.plist` | Extract to config constant |
| UI copy | "pickleball matches", "pickle ballers", "Find and create pickleball matches" | `signup_page.dart`, `proposals_page.dart` | Move to sport-specific string map |
| Email templates | "pickleball community", "Welcome to Pickle Connect" | `functions/src/templates/welcome.ts`, `new-proposal.ts` | Parameterize with sport name |
| Icons | `Icons.sports_tennis` used everywhere | `login_page.dart`, proposals pages, standings pages | Map icon per sport |
| Theme colors | Green (#2E7D32) — pickleball paddle color | `core/theme/app_theme.dart` | Sport-specific color palette |
| Deep link scheme | `pickleconnect://` | `AndroidManifest.xml`, `Info.plist` | Update if rebranding |
| Notification channel | `tennis_club_channel` (legacy name) | `notification_service.dart` | Rename to generic or sport-specific |

### Tier 2: Medium Effort — Sport-Specific Logic

#### Skill Rating System
- **Current**: PPASWTA pickleball ratings (1.0–5.0+) with pickleball-specific descriptions
- **Files**: `lib/shared/models/user.dart` (lines 85-226) — `SkillLevel` enum, `SkillBracket` enum
- **Descriptions reference**: "dinks", "two-bounce rule", "consistent serves" — all pickleball terms
- **Change**: Create per-sport skill level definitions
  - Tennis: NTRP ratings (1.0–7.0)
  - Ping pong: ITTF ratings or USATT system
  - Volleyball: skill tiers (Recreational, Competitive, Club, etc.)
  - Keep `SkillBracket` groupings (Beginner/Novice/Intermediate/Advanced/Expert) — these are universal

#### Scoring Format
- **Current**: Best-of-3 games, hardcoded in `Scores` class
- **Files**: `lib/shared/models/proposal.dart` (lines 152-193)
- **Match complete**: `creatorGamesWon >= 2 || opponentGamesWon >= 2`
- **No score validation** — just stores raw integers
- **Change**: Make configurable per sport:

| Sport | Format | Points to Win | Win By | Games/Sets |
|-------|--------|---------------|--------|------------|
| Pickleball | Best of 3 games | 11 points | 2 | 2-3 games |
| Tennis | Best of 3 sets | 6 games (tiebreak at 6-6) | 2 games | 2-3 sets |
| Ping Pong | Best of 5 games | 11 points | 2 | 3-5 games |
| Volleyball | Best of 3 or 5 sets | 25 points (15 in final) | 2 | 2-3 or 3-5 sets |
| Badminton | Best of 3 games | 21 points | 2 | 2-3 games |

#### Score Entry UI
- **Current**: Simple integer inputs for each game
- **Change**: Sport-aware labels ("Set 1" vs "Game 1"), validation rules, tiebreak handling for tennis

### Tier 3: Higher Effort — Architecture Changes

#### Sport Configuration Provider
Create a central config system injected via Riverpod:

```dart
// Proposed: lib/core/config/sport_config.dart

enum SportType { pickleball, tennis, pingPong, volleyball, badminton }

abstract class SportConfig {
  String get displayName;           // "Tennis", "Pickleball"
  String get tagline;               // "Find your match, play your game"
  IconData get icon;                // Icons.sports_tennis
  Color get primaryColor;           // Theme primary
  Color get secondaryColor;         // Theme secondary

  // Skill system
  List<SkillLevel> get skillLevels;
  String skillDescription(SkillLevel level);
  Map<SkillLevel, SkillBracket> get bracketMapping;

  // Scoring
  int get gamesPerMatch;            // Best-of-N
  int get pointsToWinGame;          // 11, 21, 25
  bool get winByTwo;
  bool get hasTiebreaks;            // Tennis-specific
  String get gameLabel;             // "Game", "Set"
  String get matchLabel;            // "Match"

  // UI
  String get locationLabel;         // "Court", "Table", "Venue"
  String get playerNoun;            // "Player", "Paddler"
}
```

#### Firestore Multi-Sport Support
Two approaches:

**Option A: Sport field on documents (recommended for single-app)**
- Add `sport: String` field to `proposals`, `standings`, `users`
- Filter queries by sport: `where('sport', isEqualTo: currentSport)`
- Standings paths: `standings/{sport}_{zone}_{bracket}/players/{userId}`
- Pros: Single Firebase project, shared user accounts across sports
- Cons: Larger collections, need compound indexes

**Option B: Separate Firebase projects per sport (white-label)**
- Each sport gets its own Firebase project + app bundle
- Pros: Clean separation, independent scaling
- Cons: More infrastructure, no cross-sport user accounts

#### User Model Changes
- Add `preferredSport: SportType` or support multiple sports per user
- Sport-specific stats: `Map<SportType, SportStats>` or separate stat fields per sport
- Skill level per sport (a 4.0 pickleball player might be a 3.0 tennis player)

#### Navigation Changes
- Add sport selector on home screen or in profile/settings
- Sport context flows through all pages via Riverpod provider
- Bottom nav stays the same (Singles | Doubles | Profile)

---

## Hardcoded Reference Inventory

### Dart Files with "pickle" or "pickleball" references:
- `lib/main.dart` — app title
- `lib/shared/widgets/main_navigation.dart` — nav bar title
- `lib/features/auth/presentation/pages/signup_page.dart` — onboarding copy
- `lib/features/auth/presentation/pages/login_page.dart` — logo comment
- `lib/features/proposals/presentation/pages/proposals_page.dart` — page subtitle
- `lib/shared/models/user.dart` — skill level descriptions

### Config/Platform files:
- `android/app/src/main/AndroidManifest.xml` — app label, deep link scheme
- `ios/Runner/Info.plist` — display name, deep link scheme
- `pubspec.yaml` — package name, description
- `lib/firebase_options.dart` — bundle IDs (`com.tennisclub.pickleconnect`)

### Firebase Functions (TypeScript):
- `functions/src/templates/welcome.ts` — welcome email
- `functions/src/templates/new-proposal.ts` — notification email (mostly generic)

### Notification:
- `lib/shared/services/notification_service.dart` — channel ID/description

---

## Implementation Estimate

| Approach | Effort | Description |
|----------|--------|-------------|
| **Single-sport rebrand** (e.g., rebrand to Tennis Connect) | ~2-3 days | Replace strings, update skill descriptions, adjust scoring labels |
| **Multi-sport selector** (user picks sport in-app) | ~1-2 weeks | SportConfig system, sport field in Firestore, per-sport standings, UI sport picker |
| **White-labeled platform** (separate apps per sport) | ~3-4 weeks | Separate Firebase projects, build flavors, dynamic theming, sport-specific onboarding |

## Recommended Path

1. **Start with SportConfig abstraction** — even before adding new sports, extract all hardcoded values into a `PickleballConfig` class that implements `SportConfig`. This is a refactor-only step with zero behavior change.
2. **Add sport selector** — let users pick their sport, store in profile.
3. **Add new sport configs** — `TennisConfig`, `PingPongConfig`, etc., one at a time.
4. **Update Firestore** — add sport field to proposals/standings, update queries.
5. **Update Cloud Functions** — parameterize email templates, standings calculations.

This incremental approach lets the app stay functional at every step while gradually becoming multi-sport capable.
