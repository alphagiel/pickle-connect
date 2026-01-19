# pickle_connect

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

> Run in CHROME
flutter run -d chrome

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Email Notification System — GitHub Summary

## Overview

Implemented a full **email notification system** for **Pickle Connect** using **Firebase Cloud Functions** with **Firestore triggers**.

* **Local development:** Mailpit (Docker)
* **Production:** SendGridS

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

| Terminal | Purpose            | Command                         |
| -------- | ------------------ | ------------------------------- |
| 1        | Firebase emulators | `cd functions && npm run serve` |
| 2        | Flutter app        | `flutter run`                   |
| (opt)    | One-off tasks      | git, build_runner, etc          |

### Quick Start

```bash
docker-compose up -d
cd functions
npm run serve
```

Open:

* Firebase Emulator UI: `http://127.0.0.1:4000`
* Mailpit Inbox: `http://localhost:8025`

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

