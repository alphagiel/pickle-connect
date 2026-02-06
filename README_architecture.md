Here's a high-level architecture diagram for new developers:

  ┌─────────────────────────────────────────────────────────────────────────────┐
  │                           PICKLE CONNECT ARCHITECTURE                        │
  └─────────────────────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────────────────────┐
  │                              PRESENTATION LAYER                              │
  ├─────────────────────────────────────────────────────────────────────────────┤
  │                                                                             │
  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
  │  │    Auth     │  │  Proposals  │  │  Standings  │  │   Profile   │        │
  │  │   Feature   │  │   Feature   │  │   Feature   │  │   Feature   │        │
  │  ├─────────────┤  ├─────────────┤  ├─────────────┤  ├─────────────┤        │
  │  │ LoginPage   │  │ProposalsPage│  │StandingsPage│  │EditProfile  │        │
  │  │ SignupPage  │  │DetailsPage  │  │ StandingCard│  │   Page      │        │
  │  │ ResetPwd    │  │ CreatePage  │  │ SkillTabs   │  │             │        │
  │  │   Page      │  │  EditPage   │  │             │  │             │        │
  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘        │
  │                                                                             │
  │  ┌───────────────────────────────────────────────────────────────────┐     │
  │  │                     MainNavigation (Shell)                         │     │
  │  │  ┌─────────────────────────────────────────────────────────────┐  │     │
  │  │  │  AppBar: Title + Profile Menu (Edit Profile / Logout)       │  │     │
  │  │  ├─────────────────────────────────────────────────────────────┤  │     │
  │  │  │  BottomNav: [Proposals] [Standings]                         │  │     │
  │  │  └─────────────────────────────────────────────────────────────┘  │     │
  │  └───────────────────────────────────────────────────────────────────┘     │
  │                                                                             │
  └─────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
  ┌─────────────────────────────────────────────────────────────────────────────┐
  │                          STATE MANAGEMENT (Riverpod)                         │
  ├─────────────────────────────────────────────────────────────────────────────┤
  │                                                                             │
  │  StreamProviders (Real-time)          StateProviders (UI State)             │
  │  ┌──────────────────────────┐         ┌──────────────────────────┐         │
  │  │ authStateProvider        │         │ selectedSkillLevelProvider│         │
  │  │ currentUserProfileProvider│        │ proposalStatusFilter      │         │
  │  │ openProposalsProvider    │         │ dateFilterProvider        │         │
  │  │ acceptedProposalsProvider│         │ creatorFilterProvider     │         │
  │  │ completedProposalsProvider│        │ editingProposalProvider   │         │
  │  │ standingsProvider        │         └──────────────────────────┘         │
  │  └──────────────────────────┘                                              │
  │                                                                             │
  │  StateNotifierProviders               Regular Providers                     │
  │  ┌──────────────────────────┐         ┌──────────────────────────┐         │
  │  │ authNotifierProvider     │         │ filteredProposalsProvider│         │
  │  │   (manages auth flow)    │         │ proposalActionsProvider  │         │
  │  └──────────────────────────┘         │ routerProvider (GoRouter)│         │
  │                                       └──────────────────────────┘         │
  └─────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
  ┌─────────────────────────────────────────────────────────────────────────────┐
  │                              DATA LAYER                                      │
  ├─────────────────────────────────────────────────────────────────────────────┤
  │                                                                             │
  │  Repositories                          Models (Freezed)                     │
  │  ┌──────────────────────────┐         ┌──────────────────────────┐         │
  │  │ AuthRepository           │         │ User                     │         │
  │  │  - signIn/signUp/signOut │         │  - userId, displayName   │         │
  │  │  - resetPassword         │         │  - skillLevel/Bracket    │         │
  │  │  - emailVerification     │         │  - stats (win/loss)      │         │
  │  ├──────────────────────────┤         ├──────────────────────────┤         │
  │  │ ProposalsRepository      │         │ Proposal                 │         │
  │  │  - CRUD operations       │         │  - creator/acceptor info │         │
  │  │  - accept/unaccept       │         │  - status, scores        │         │
  │  │  - score recording       │         │  - skillBracket, date    │         │
  │  ├──────────────────────────┤         ├──────────────────────────┤         │
  │  │ StandingsRepository      │         │ Standing                 │         │
  │  │  - get by bracket        │         │  - ranking, streak       │         │
  │  │  - user rank calculation │         │  - winRate, points       │         │
  │  ├──────────────────────────┤         └──────────────────────────┘         │
  │  │ UsersRepository          │                                              │
  │  │  - profile CRUD          │                                              │
  │  │  - user search           │                                              │
  │  └──────────────────────────┘                                              │
  │                                                                             │
  └─────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
  ┌─────────────────────────────────────────────────────────────────────────────┐
  │                           FIREBASE BACKEND                                   │
  ├─────────────────────────────────────────────────────────────────────────────┤
  │                                                                             │
  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
  │  │  Firebase Auth  │  │ Cloud Firestore │  │ Cloud Functions │             │
  │  │                 │  │                 │  │                 │             │
  │  │ - Email/Pass    │  │ Collections:    │  │ - Password reset│             │
  │  │ - Session mgmt  │  │ - users/        │  │ - Proposal      │             │
  │  │ - Email verify  │  │ - proposals/    │  │   expiration    │             │
  │  │                 │  │ - standings/    │  │ - Standings     │             │
  │  │                 │  │   {bracket}/    │  │   calculation   │             │
  │  │                 │  │   players/      │  │ - Score confirm │             │
  │  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
  │                                                                             │
  └─────────────────────────────────────────────────────────────────────────────┘


  ┌─────────────────────────────────────────────────────────────────────────────┐
  │                           FOLDER STRUCTURE                                   │
  ├─────────────────────────────────────────────────────────────────────────────┤
  │                                                                             │
  │  lib/                                                                       │
  │  ├── core/                    # Theme & utilities                           │
  │  │   ├── theme/               #   app_theme.dart                            │
  │  │   └── utils/               #   app_router.dart, season_utils.dart        │
  │  │                                                                          │
  │  ├── features/                # Feature modules (clean architecture)        │
  │  │   ├── auth/                #   Auth feature                              │
  │  │   │   ├── data/repositories/                                             │
  │  │   │   ├── domain/entities/                                               │
  │  │   │   └── presentation/pages/, providers/                                │
  │  │   ├── proposals/           #   Match proposals                           │
  │  │   ├── standings/           #   Ladder rankings                           │
  │  │   └── profile/             #   User profile                              │
  │  │                                                                          │
  │  ├── shared/                  # Shared across features                      │
  │  │   ├── models/              #   Freezed models (User, Proposal, etc.)     │
  │  │   ├── providers/           #   Riverpod providers                        │
  │  │   ├── repositories/        #   Firestore repositories                    │
  │  │   ├── services/            #   Business logic                            │
  │  │   └── widgets/             #   Common widgets                            │
  │  │                                                                          │
  │  ├── main.dart                # App entry point                             │
  │  └── firebase_options.dart    # Firebase config                             │
  │                                                                             │
  └─────────────────────────────────────────────────────────────────────────────┘


  ┌─────────────────────────────────────────────────────────────────────────────┐
  │                           DATA FLOW EXAMPLE                                  │
  │                      (Creating & Accepting a Proposal)                       │
  ├─────────────────────────────────────────────────────────────────────────────┤
  │                                                                             │
  │  User 1: Create Proposal                User 2: Accept Proposal             │
  │  ─────────────────────────              ───────────────────────             │
  │          │                                       │                          │
  │          ▼                                       │                          │
  │  ┌───────────────────┐                          │                          │
  │  │ CreateProposalPage│                          │                          │
  │  └─────────┬─────────┘                          │                          │
  │            │                                     │                          │
  │            ▼                                     │                          │
  │  ┌───────────────────┐                          │                          │
  │  │proposalActions    │                          │                          │
  │  │ .createProposal() │                          │                          │
  │  └─────────┬─────────┘                          │                          │
  │            │                                     │                          │
  │            ▼                                     │                          │
  │  ┌───────────────────┐                          │                          │
  │  │ProposalsRepository│                          │                          │
  │  │ .createProposal() │                          │                          │
  │  └─────────┬─────────┘                          │                          │
  │            │                                     │                          │
  │            ▼                                     │                          │
  │  ┌───────────────────┐      Stream Update       │                          │
  │  │    Firestore      │ ─────────────────────────┼───────────┐              │
  │  │ proposals.add()   │                          │           │              │
  │  └───────────────────┘                          │           │              │
  │                                                 │           ▼              │
  │                                        ┌────────┴───────────────┐          │
  │                                        │ openProposalsProvider  │          │
  │                                        │    emits new list      │          │
  │                                        └────────┬───────────────┘          │
  │                                                 │                          │
  │                                                 ▼                          │
  │                                        ┌───────────────────┐               │
  │                                        │  ProposalsPage    │               │
  │                                        │  shows new card   │               │
  │                                        └─────────┬─────────┘               │
  │                                                  │ tap Accept              │
  │                                                  ▼                          │
  │                                        ┌───────────────────┐               │
  │                                        │ acceptProposal()  │               │
  │                                        │  → Firestore      │               │
  │                                        │  status='accepted'│               │
  │                                        └───────────────────┘               │
  │                                                                             │
  └─────────────────────────────────────────────────────────────────────────────┘


  ┌─────────────────────────────────────────────────────────────────────────────┐
  │                           KEY CONCEPTS                                       │
  ├─────────────────────────────────────────────────────────────────────────────┤
  │                                                                             │
  │  SKILL LEVELS & BRACKETS                                                    │
  │  ───────────────────────                                                    │
  │  Skill Levels: 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0+                │
  │                                                                             │
  │  Brackets (for matching):                                                   │
  │    • Beginner    (1.0 - 1.5)                                               │
  │    • Novice      (2.0 - 2.5)                                               │
  │    • Intermediate(3.0 - 3.5)                                               │
  │    • Advanced    (4.0 - 4.5)                                               │
  │    • Expert      (5.0+)                                                    │
  │                                                                             │
  │  PROPOSAL LIFECYCLE                                                         │
  │  ──────────────────                                                         │
  │    open → accepted → completed (with scores)                               │
  │      │                                                                      │
  │      └──→ expired/canceled                                                 │
  │                                                                             │
  │  SCORING                                                                    │
  │  ───────                                                                    │
  │    Best-of-3 games, per-game scoring                                       │
  │    Both players confirm scores for match completion                        │
  │                                                                             │
  └─────────────────────────────────────────────────────────────────────────────┘

  Quick Reference for New Devs
  ┌─────────────┬──────────────────────────────────────┬────────────────────────┐
  │    Layer    │               Location               │        Purpose         │
  ├─────────────┼──────────────────────────────────────┼────────────────────────┤
  │ UI/Pages    │ lib/features/*/presentation/pages/   │ User-facing screens    │
  ├─────────────┼──────────────────────────────────────┼────────────────────────┤
  │ Widgets     │ lib/features/*/presentation/widgets/ │ Reusable UI components │
  ├─────────────┼──────────────────────────────────────┼────────────────────────┤
  │ State       │ lib/shared/providers/                │ Riverpod providers     │
  ├─────────────┼──────────────────────────────────────┼────────────────────────┤
  │ Data Access │ lib/shared/repositories/             │ Firestore queries      │
  ├─────────────┼──────────────────────────────────────┼────────────────────────┤
  │ Models      │ lib/shared/models/                   │ Freezed data classes   │
  ├─────────────┼──────────────────────────────────────┼────────────────────────┤
  │ Routing     │ lib/core/utils/app_router.dart       │ GoRouter config        │
  ├─────────────┼──────────────────────────────────────┼────────────────────────┤
  │ Theme       │ lib/core/theme/                      │ Colors & styling       │
  └─────────────┴──────────────────────────────────────┴────────────────────────┘
  Key patterns:
  - ref.watch(provider) for reactive UI updates
  - ref.read(provider) for one-time actions
  - ref.invalidate(provider) to refresh cached data
  - Run flutter packages pub run build_runner build after modifying Freezed models