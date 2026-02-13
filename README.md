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
* **Production:** Resend (3,000 emails/month free tier)

---

## Architecture

```text
Firestore Write
   ↓
Cloud Function Trigger
   ↓
Email Service Abstraction
   ↓
Mailpit (dev) / Resend (prod)
```

---

## Email Events & Triggers

| Event                 | Recipients                  | Firestore Trigger                          |
| --------------------- | --------------------------- | ------------------------------------------ |
| Welcome email         | New user                    | `users/{userId}` created                   |
| Account deleted       | Deleted user                | `users/{userId}` deleted                   |
| New proposal          | Users in same skill bracket | `proposals/{id}` created (`status = open`) |
| Proposal accepted     | Proposal creator            | `proposals/{id}` status → `accepted`       |
| Proposal unaccepted   | Proposal creator            | `proposals/{id}` status → `open`           |
| Proposal cancelled    | Accepter + creator          | `proposals/{id}` status → `canceled`       |
| Match result recorded | Both players                | `proposals/{id}` `scores` added            |
| Doubles partner invite | Invited player             | `proposals/{id}` player added as `invited` |
| Doubles join request  | Proposal creator            | `proposals/{id}` player added as `requested` |
| Doubles partner confirmed | Creator                 | `proposals/{id}` player status → `confirmed` |
| Doubles player approved | Approved player           | `proposals/{id}` player status → `confirmed` |
| Doubles lobby full    | All 4 confirmed players     | `proposals/{id}` 4th player confirmed      |
| Doubles player declined | Declined player           | `proposals/{id}` player removed (was `requested`) |
| Doubles player left   | Creator                     | `proposals/{id}` player removed (was `confirmed`) |
| Doubles cancelled     | All lobby players           | `proposals/{id}` status → `canceled` (doubles) |
| Doubles scores confirmed | Other team players       | `proposals/{id}` `scoreConfirmedBy` grows  |
| Doubles match result  | All 4 players               | `proposals/{id}` `scores` added (doubles)  |

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
│   │   ├── resend.service.ts
│   │   └── email-factory.ts
│   ├── triggers/
│   │   ├── on-user-created.ts
│   │   ├── on-user-deleted.ts
│   │   ├── on-proposal-created.ts
│   │   ├── on-proposal-updated.ts
│   │   └── on-proposal-deleted.ts
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
* **ResendService:** `resend` npm package (production)
* Factory auto-selects service based on environment

### Phase 4 — Firestore Triggers

* `onUserCreated` — welcome email
* `onUserDeleted` — farewell/account deleted email
* `onProposalCreated` — broadcast + creator confirmation + doubles partner invites
* `onProposalUpdated` — accepted, unaccepted, cancelled, scores, doubles lifecycle
* `onProposalDeleted` — notify accepter of cancellation

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
* **Production:** Firebase secrets (`RESEND_API_KEY`)

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

* Resend account created (free tier: 3,000 emails/month)
* Currently sending from `onboarding@resend.dev` (Resend default sender)
* API key set as Firebase secret:

```bash
firebase functions:secrets:set RESEND_API_KEY
```

* Deploy:

```bash
cd functions && npm run build && firebase deploy --only functions
```

### TODO: Custom Email Domain

To send from a branded address (e.g. `noreply@yourdomain.com`):

1. Buy a domain you own
2. Add it at https://resend.com/domains
3. Add the DNS records Resend provides (TXT for DKIM, MX + TXT for SPF, optional DMARC)
4. Verify in Resend
5. Update `EMAIL_FROM` env var or the default in `resend.service.ts`
6. Redeploy functions

---

## Result

A **production-ready, testable, and extensible email notification system** with:

* Clean service abstraction
* Firestore-driven triggers
* Local + production parity
* Deep linking into the app

