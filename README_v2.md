# PICKLE CONNECT: Email Notification System — GitHub Summary

## Overview

Implemented a full **email notification system** for **Pickle Connect** using **Firebase Cloud Functions** with **Firestore triggers**.

* **Local development:** Mailpit (Docker)
* **Production:** SendGrid

---

## Architecture

```text
Firestore Write
   ↓
Cloud Function Trigger
   ↓
Email Service Abstraction
   ↓
Mailpit (dev) / SendGrid (prod)
```

---

## Email Events & Triggers

| Event                 | Recipients                  | Firestore Trigger                          |
| --------------------- | --------------------------- | ------------------------------------------ |
| Welcome email         | New user                    | `users/{userId}` created                   |
| New proposal          | Users in same skill bracket | `proposals/{id}` created (`status = open`) |
| Proposal accepted     | Proposal creator            | `proposals/{id}` status → `accepted`       |
| Proposal unaccepted   | Proposal creator            | `proposals/{id}` status → `open`           |
| Match result recorded | Both players                | `proposals/{id}` `scores` added            |

---

## Implementation Phases

### Phase 1 — Mailpit (Local Email Testing)

* Docker-based Mailpit setup
* SMTP: `localhost:1025`
* Web UI: `http://localhost:8025`

### Phase 2 — Firebase Cloud Functions

**Directory structure**

```text
functions/
├── src/
│   ├── index.ts
│   ├── services/email/
│   │   ├── email-service.interface.ts
│   │   ├── mailpit.service.ts
│   │   ├── sendgrid.service.ts
│   │   └── email-factory.ts
│   ├── triggers/
│   │   ├── on-user-created.ts
│   │   ├── on-proposal-created.ts
│   │   └── on-proposal-updated.ts
│   └── templates/
│       ├── welcome.html
│       ├── new-proposal.html
│       ├── proposal-accepted.html
│       ├── proposal-unaccepted.html
│       └── match-result.html
├── .env.local
├── .env.production
└── package.json
```

### Phase 3 — Email Service Abstraction

* Common `send()` / `sendBatch()` interface
* **MailpitService:** Nodemailer (local)
* **SendGridService:** `@sendgrid/mail` (production)
* Factory auto-selects service based on environment

### Phase 4 — Firestore Triggers

* `onUserCreated`
* `onProposalCreated`
* `onProposalUpdated` (status + score detection)

### Phase 5 — User Model Update

Added email notification preferences:

```dart
EmailNotificationPreferences({
  bool welcome = true,
  bool newProposals = true,
  bool proposalAccepted = true,
  bool proposalUnaccepted = true,
  bool matchResults = true,
});
```

### Phase 6 — Email Templates

* Responsive HTML with inline CSS
* Deep links: `pickleconnect://`
* Web URL fallbacks
* Preferences/unsubscribe link in footer

### Phase 7 — Deep Linking

* iOS: URL scheme in `Info.plist`
* Android: intent-filters in `AndroidManifest.xml`
* App route: `/proposal/:proposalId`

### Phase 8 — Environment Configuration

* **Local:** `.env.local` (Mailpit)
* **Production:** Firebase secrets (`SENDGRID_API_KEY`)

---

## Files Created

| Path                            | Purpose                  |
| ------------------------------- | ------------------------ |
| `docker-compose.yml`            | Mailpit container        |
| `functions/`                    | Firebase Cloud Functions |
| `functions/src/services/email/` | Email providers          |
| `functions/src/templates/`      | HTML templates           |
| `functions/src/triggers/`       | Firestore triggers       |

---

## Files Modified

| File                                                | Change                       |
| --------------------------------------------------- | ---------------------------- |
| `lib/shared/models/user.dart`                       | EmailNotificationPreferences |
| `lib/shared/repositories/proposals_repository.dart` | `getProposalById()`          |
| `lib/shared/providers/proposals_providers.dart`     | `proposalByIdProvider`       |
| `lib/core/utils/app_router.dart`                    | Deep link route              |
| `ios/Runner/Info.plist`                             | URL scheme                   |
| `android/app/src/main/AndroidManifest.xml`          | Intent filters               |

---

## Local Development

### Terminals

| Terminal | Purpose            | Command                                              |
| -------- | ------------------ | ---------------------------------------------------- |
| 1        | Firebase emulators | `firebase emulators:start --only auth,functions,firestore` (from project root) |
| 2        | Flutter app        | `flutter run -d chrome --dart-define=USE_EMULATORS=true` |
| (opt)    | One-off tasks      | git, build_runner, etc                               |

### Quick Start

**Note:** Mailpit runs in Docker. Make sure **Docker Desktop is running** first, then run `docker-compose up -d` before accessing http://localhost:8025

```bash
# From project root
docker-compose up -d

# Build functions
cd functions
npm run build

# Start emulators (from project root)
cd ..
firebase emulators:start --only auth,functions,firestore
```

Open:

* Firebase Emulator UI: `http://127.0.0.1:4000`
* Mailpit Inbox: `http://localhost:8025` (requires Docker container running)

---

## Testing

1. Create a user document in Firestore Emulator
2. Verify welcome email in Mailpit
3. Create / accept proposals
4. Confirm notifications are delivered

---

## Production Checklist

* Create SendGrid account (free tier: 100 emails/day)
* Verify sender email/domain
* Set secret:

```bash
firebase functions:secrets:set SENDGRID_API_KEY
```

* Deploy:

```bash
firebase deploy --only functions
```

---

## Result

A **production-ready, testable, and extensible email notification system** with:

* Clean service abstraction
* Firestore-driven triggers
* Local + production parity
* Deep linking into the app

---

## Summary: Local Development with Firestore Emulator & Mailpit

### What We Set Up

1. **Mailpit** (email capture for local dev)
   - SMTP server on port 1025
   - Web UI at http://127.0.0.1:8025

2. **Firebase Emulators**
   - Firestore UI at http://127.0.0.1:4000/firestore/default/data
   - Functions at port 5001

---

### How to Start Everything

**Important:** Mailpit runs in Docker. Start **Docker Desktop** first, then run the commands below before accessing http://localhost:8025

```bash
# 1. Start Mailpit (from project root)
docker-compose up -d

# 2. Build functions (from functions folder)
cd functions
npm run build

# 3. Start Firebase Emulators (from project root)
cd ..
firebase emulators:start --only auth,functions,firestore
```

---

### What We Tested

| Test                                                  | Status            |
| ----------------------------------------------------- | ----------------- |
| Create user → Welcome email                           | ✅ Working        |
| Create open proposal → Notification to matching users | ✅ Working        |
| Accept proposal → Notification to creator             | ⏳ Not yet tested |

---

### Required Fields for Proposals

| Field       | Type      | Example       |
| ----------- | --------- | ------------- |
| status      | string    | open          |
| skillLevel  | number    | 3.5           |
| creatorId   | string    | (user doc ID) |
| creatorName | string    | Creator       |
| location    | string    | Local Courts  |
| dateTime    | timestamp | (any date)    |

Users must have matching skillLevel to receive proposal notifications.

---

### Tomorrow: Continue With

- Test proposal acceptance (change status to accepted + add acceptedBy map in one update)
- Test match result emails (add scores to a proposal)

---

## 1/20/2026

### Development (Local Emulators)

**Terminal 1: Start Mailpit**
```bash
cd C:\Users\lfage\Sandbox\mobile-apps\pickle-connect
docker-compose up -d
```

**Terminal 2: Build Functions & Start Firebase Emulators**
```bash
# First, build the functions (from functions folder)
cd C:\Users\lfage\Sandbox\mobile-apps\pickle-connect\functions
npm run build

# Then start emulators (from project root)
cd C:\Users\lfage\Sandbox\mobile-apps\pickle-connect
firebase emulators:start --only auth,functions,firestore --project myapp1-c6012
```

**Terminal 3: Run Flutter App (with emulators)**
```bash
cd C:\Users\lfage\Sandbox\mobile-apps\pickle-connect
flutter run -d chrome --dart-define=USE_EMULATORS=true
```

### Local URLs

| Service     | URL                                       |
| ----------- | ----------------------------------------- |
| App         | http://localhost:PORT (shown in terminal) |
| Emulator UI | http://127.0.0.1:4000                     |
| Mailpit     | http://127.0.0.1:8025                     |

---

### Production

**Deploy Functions** (one-time or when functions change)

```bash
cd C:\Users\lfage\Sandbox\mobile-apps\pickle-connect\functions
npm run build
firebase deploy --only functions --project myapp1-c6012
```

**Run Flutter App** (production Firebase)

```bash
cd C:\Users\lfage\Sandbox\mobile-apps\pickle-connect
flutter run -d chrome
```

No `--dart-define` flag = uses production Firebase.

---

### Quick Reference

| Mode | Flutter Command                                       | Firebase         |
| ---- | ----------------------------------------------------- | ---------------- |
| Dev  | `flutter run -d chrome --dart-define=USE_EMULATORS=true` | Local emulators  |
| Prod | `flutter run -d chrome`                               | Real Firebase    |

```bash
# Build functions first (from functions folder)
cd functions && npm run build && cd ..

# Start emulators (from project root)
firebase emulators:start --only auth,functions,firestore

# In another terminal, run Flutter
flutter run -d chrome --dart-define=USE_EMULATORS=true
```
