Here's the full status against the rejection:                                                                                       
  #: 1                                                                                                                                
  Guideline: 2.1                                                                                                                      
  Issue: Placeholder app icon                                                                                                         
  Status: Done (commit 91610020390c)                                                                                                  
  ────────────────────────────────────────                                                                                            
  #: 2
  Guideline: 2.3.3                                                                                                                    
  Issue: iPad screenshots are stretched iPhone images                                                                                 
  Status: Done (you uploaded proper iPad screenshots)                                                                                 
  ────────────────────────────────────────                                                                                            
  #: 3                                                                                                                                
  Guideline: 5.1.1                                                                                                                    
  Issue: Phone number required
  Status: Not an issue — phone number is never collected anywhere in the app. Not in signup, not in profile, not in the user model.
    Apple may have been confused. You should reply in App Store Connect explaining this.
  ────────────────────────────────────────
  #: 4
  Guideline: 5.1.1(v)
  Issue: No account deletion
  Status: Done — full 7-step deletion flow exists in Edit Profile > Danger Zone (re-auth, cancel proposals, anonymize data, delete
    Firestore doc, delete Firebase Auth account)
  ────────────────────────────────────────
  #: 5
  Guideline: 2.1
  Issue: App doesn't load on iPad
  Status: Done (commit 2a936f137917)
  The only action item is Guideline 5.1.1 (phone number) — you need to reply to Apple explaining that the app does NOT require a phone
   number. Here's a suggested response you can paste into App Store Connect:

  ---
  Re: Guideline 5.1.1 — Phone Number

  Thank you for the review. Our app does not require or collect a phone number at any point during registration or use. Account
  creation only requires a name, email, password, and skill level. There is no phone number field in the signup flow, user profile, or
   data model.

  We believe this may have been flagged in error. Please let us know if you need further clarification.

  ---
  Everything else is addressed. You're good to upload build 5 via Transporter and resubmit.

────────────────────────────────────────
## Review Round 2 — February 17, 2026
────────────────────────────────────────
#: 6
Guideline: 2.3.10
Issue: iPad screenshots contain simulator watermarks/artifacts (simulator status bar, Flutter debug banner)
Status: Done — Retook screenshots on real iPad Pro 12.9" (6th gen) in release mode, re-uploaded to App Store Connect, resubmitted for review (Feb 17, 2026)

────────────────────────────────────────
## Feature: Zone-Based Community Support (Firestore-Driven)
Branch: `feat-app-zoning` → PR to `main`
────────────────────────────────────────
**Goal**: Players only see other players, proposals, and standings within their geographic zone. Zones are stored in Firestore (not hardcoded) so new communities can be added without app updates.

### Zone Interaction Model
- **Home zone locked for playing**: Users pick a home zone at signup. They can only create proposals and be ranked in their home zone.
- **Browse other zones**: Standings page has a zone dropdown so any user can VIEW other zones' leaderboards (read-only).
- **Proposals locked to home zone**: Users only see and create proposals in their home zone.
- **Zone change via Edit Profile**: Changing home zone resets standings in the old zone.

### Scalability
- Zones live in Firestore `zones/` collection — add new zones without app updates
- Each zone doc has: `id`, `displayName`, `description`, `cities[]`, `region`, `active`, `createdAt`
- To onboard a new community: create a Firestore doc → it appears in all dropdowns instantly
- Future: admin panel, regional grouping, zone-specific rules

### Initial Zones (seeded to Firestore)
- **east_triangle**: "East Triangle" — Clayton, Garner, Knightdale, South Raleigh
- **west_triangle**: "West Triangle" — Cary, Apex, West Raleigh, Morrisville

### Architecture
```
Firestore:
  zones/
    east_triangle   → { displayName, description, cities[], region, active, createdAt }
    west_triangle   → { ... }

  users/{uid}       → { ..., zone: "east_triangle" }  (string, not enum)
  proposals/{id}    → { ..., zone: "east_triangle" }

  standings/east_triangle_Intermediate/players/{uid} → { ... }
  doubles_standings/east_triangle_Intermediate/players/{uid} → { ... }
```

### Implementation Steps

**Step 1: Zone Model + Firestore Collection** `[x]`
- Create `lib/shared/models/zone.dart` — freezed `AppZone` model class (not enum):
  - Fields: `id`, `displayName`, `description`, `cities` (List<String>), `region`, `active`, `createdAt`
- Create `lib/shared/repositories/zones_repository.dart`:
  - `getActiveZones()` → Stream<List<AppZone>> from `zones/` where `active == true`
  - `getZoneById(String id)` → Future<AppZone?>
- Create `lib/shared/providers/zones_providers.dart`:
  - `activeZonesProvider` → StreamProvider cached list of zones
  - `userZoneProvider` → derives from current user's `zone` field
- Seed initial zone docs to Firestore (`east_triangle`, `west_triangle`)

**Step 2: Update User + Proposal Models** `[x]`
- `user.dart`: Add `required String zone` field (plain string, not enum)
  - `@Default('east_triangle')` for Firestore default
  - Update `_migrateUserJson()` to default missing `zone` to `'east_triangle'`
- `proposal.dart`: Add `required String zone` field
  - Update `_migrateProposalJson()` to default missing `zone` to `'east_triangle'`
- Run `build_runner`

**Step 3: Update Repositories with Zone Filtering** `[x]`
- `proposals_repository.dart`:
  - `getProposalsForBracket(bracket)` → `getProposalsForBracketAndZone(bracket, zone)` — add `.where('zone', isEqualTo: zone)`
  - `getCompletedProposalsByBracket(bracket)` → add zone param + filter
  - `getDoublesProposalsForBracket(bracket)` → add zone param + filter
- `standings_repository.dart`:
  - Change path from `standings/{bracket}/players/` to `standings/{zone}_{bracket}/players/`
  - All methods (`getStandingsForBracket`, `getUserStanding`, `getUserRank`, `removeUserFromStandings`, `anonymizeUserInStandings`) accept `String zone` param
  - `getAllStandings()` → accepts `String zone` param
- `doubles_standings_repository.dart`:
  - Same path change: `doubles_standings/{zone}_{bracket}/players/`
  - All methods accept `String zone` param

**Step 4: Update Providers** `[x]`
- `proposals_providers.dart`:
  - Create `ProposalFilterParams` class with `bracket` + `zone` (String)
  - Update `openProposalsProvider` family from `SkillBracket` → `ProposalFilterParams`
  - Update `completedMatchesByBracketProvider` similarly
  - Update `filteredProposalsProvider` similarly
- `standings_providers.dart`:
  - Create `StandingsFilterParams` class with `bracket` + `zone` (String)
  - Update `standingsProvider` family from `SkillBracket` → `StandingsFilterParams`
  - Update `UserStandingParams` to include `zone`
- `doubles_proposals_providers.dart`:
  - Same zone-scoping pattern for `openDoublesProposalsProvider`

**Step 5: Update UI Pages** `[x]`
- `signup_page.dart`:
  - Fetch zones from `activeZonesProvider`
  - Add `DropdownButtonFormField` after skill level — shows `zone.displayName` + info icon with tooltip listing cities
  - Include `zone: selectedZone.id` when creating User
- `edit_profile_page.dart`:
  - Add zone dropdown (same pattern), initialize from `userProfile.zone`
  - On zone change: remove user from old zone's standings (rankings reset)
  - Include `'zone': selectedZone.id` in update map
- `standings_page.dart`:
  - Add zone dropdown in header area (below subtitle, above bracket tabs)
  - Defaults to user's home zone, switching loads that zone's standings (read-only browsing)
  - Update subtitle to show selected zone name
  - Pass selected zone string to `standingsProvider` and `completedMatchesByBracketProvider`
- `proposals_page.dart`:
  - Read current user's `zone` string
  - Pass zone to `openProposalsProvider` and other providers
- `create_proposal_page.dart` + doubles create page:
  - Auto-set `zone` from user's profile (user doesn't pick zone per-proposal)

**Step 6: Update Cloud Functions** `[x]`
- `on-proposal-updated.ts`:
  - Extract `zone` from proposal data: `const zone = proposalData.zone || 'east_triangle'`
  - Change standings path from `standings/${skillBracket}` to `standings/${zone}_${skillBracket}`
  - Same for `doubles_standings/` path
  - Pass zone to all `updatePlayerStanding` calls
- `on-proposal-created.ts`:
  - Add `.where('zone', '==', proposalData.zone)` to user notification query
  - Players only get notified about proposals in their zone

**Step 7: Firestore Indexes** `[x]`
- Add composite indexes for `proposals` collection:
  - `status ASC + skillBracket ASC + zone ASC`
  - `matchType ASC + status ASC + skillBracket ASC + zone ASC`
- Deploy early: `firebase deploy --only firestore:indexes`

**Step 8: Data Migration** `[x]` *(completed Feb 17, 2026 via Cloud Shell)*
- [x] Seed `zones/east_triangle` and `zones/west_triangle` documents to Firestore
- [x] Backfill `zone: 'east_triangle'` on all existing user docs (15 users)
- [x] Backfill `zone: 'east_triangle'` on all existing proposal docs (10 proposals)
- [x] Copy standings docs from `standings/{bracket}/players/` to `standings/east_triangle_{bracket}/players/` (no existing standings to copy)
- [x] Same for `doubles_standings/` (no existing standings to copy)

**Step 9: Delete Account Cleanup** `[x]`
- Update `_deleteAccount` in `edit_profile_page.dart` to pass user's zone string when anonymizing standings in both `standings_repository` and `doubles_standings_repository`

### Deployment Steps (after PR merge)
1. `firebase deploy --only firestore:indexes` — deploy new composite indexes (takes minutes to build)
2. Seed zone docs to Firestore (see Step 8 above)
3. Run data migration scripts (backfill zone field, copy standings)
4. `cd functions && npm run build && firebase deploy --only functions`
5. Build + deploy app update

### Verification Checklist
- [x] `flutter analyze` — no new errors (pre-existing notification_service errors only)
- [x] TypeScript compiles — `npx tsc --noEmit` passes
- [ ] `flutter test` — all pass
- [ ] Signup: zone dropdown appears, populated from Firestore, info tooltip shows cities
- [ ] Edit profile: zone can be changed, old zone standings cleared
- [ ] Proposals: only same-zone proposals visible, new proposals auto-tagged with zone
- [ ] Standings: leaderboard scoped to zone, header shows zone name, can browse other zones
- [ ] Cloud functions: match completion updates zone-scoped standings path
- [ ] Notifications: only same-zone users notified of new proposals
- [ ] iPad release mode: UI renders correctly