# Pickle Connect - TODO

## 2/8/2026 - Doubles Email Notifications — COMPLETED 2/11/2026

All doubles email notifications have been implemented. 7 new email templates were created, trigger handlers were wired in both `on-proposal-created.ts` and `on-proposal-updated.ts`, and a `doublesUpdates` email preference was added to the user model.

### Doubles Notification Status

| # | Event | Template File | Trigger Wired? | Status |
|---|-------|---------------|----------------|--------|
| 1 | **Create Doubles Proposal** — notify users in skill bracket that a doubles match is available | `doubles-new-proposal.ts` | Yes (on-proposal-created.ts) | WIRED |
| 2 | **Partner Invited** — notify invited partner when creator creates proposal with them | `doubles-partner-invite.ts` | Yes (on-proposal-created.ts) | WIRED |
| 3 | **Partner Confirms Invite** — notify creator that their partner accepted | `doubles-partner-confirmed.ts` | Yes (on-proposal-updated.ts) | WIRED |
| 4 | **Player Requests to Join** — notify creator that someone wants to join their lobby | `doubles-join-request.ts` | Yes (on-proposal-updated.ts) | WIRED |
| 5 | **Player Approved** — notify the approved player that they're in | `doubles-player-approved.ts` | Yes (on-proposal-updated.ts) | WIRED |
| 6 | **Lobby Full (4 confirmed)** — notify all 4 players the match is set | `doubles-lobby-full.ts` | Yes (on-proposal-updated.ts) | WIRED |
| 7 | **Player Declined** — notify declined player | `doubles-player-declined.ts` | Yes (on-proposal-updated.ts) | WIRED |
| 8 | **Player Left** — notify creator that a slot opened up | `doubles-player-left.ts` | Yes (on-proposal-updated.ts) | WIRED |
| 9 | **Proposal Canceled** — notify all players in lobby | `doubles-proposal-cancelled.ts` | Yes (on-proposal-updated.ts) | WIRED |
| 10 | **Scores Recorded** — notify all 4 players of match result | `doubles-match-result.ts` | Yes (on-proposal-updated.ts) | WIRED |
| 11 | **Scores Confirmed** — notify other team that scores are confirmed | `doubles-scores-confirmed.ts` | Yes (on-proposal-updated.ts) | WIRED |

---

## 2/11/2026 - Fix App rejection reasons 1 and 2

### App Icon and Ipad Images
 Steps

  1. Get a polished icon designed. The current assets/icons/pickle-connect-icon.png is what Apple flagged. You need a replacement that:
    - Is 1024x1024px, no transparency (iOS rejects alpha — you already have remove_alpha_ios: true)
    - Uses your app's green branding/colors
    - Looks like a finished product icon, not a silhouette placeholder
    - No rounded corners — Apple applies the mask automatically
  2. Options for getting the icon made:
    - Fiverr / 99designs — app icon designers, typically $20–100
    - Canva / Figma — DIY if you're comfortable with design tools
    - AI image generators — can produce a starting point, but you'll likely need to polish in an editor
  3. Once you have the final PNG, replace the file at:
  assets/icons/pickle-connect-icon.png
  4. Regenerate all platform sizes:
  flutter pub run flutter_launcher_icons:main
  5. Rebuild and resubmit.

  ---
  Issue 2: iPad Screenshots (Guideline 2.3.3)

  This is purely an App Store Connect metadata fix — no code changes needed.

  Steps

  1. Launch an iPad simulator (or use a physical iPad):
  # List available simulators
  xcrun simctl list devices

  # Boot a 13-inch iPad Pro simulator
  open -a Simulator
  # Then select Hardware > Device > iPad Pro (13-inch)
  2. Run the app on the iPad simulator:
  flutter run -d <ipad-simulator-id>
  3. Take screenshots of the key screens (the same ones you submitted for iPhone). Use Cmd+S in Simulator to save screenshots.
  4. Upload in App Store Connect:
    - Go to your app > App Store tab > version
    - Scroll to App Preview and Screenshots
    - Click "View All Sizes in Media Manager" (important — don't just drag into the default view)
    - Find the 12.9-inch iPad Pro and 13-inch iPad Pro display sizes
    - Upload the actual iPad screenshots for each size class
    - Remove the stretched iPhone images
  5. Resubmit for review.

  ---
  Summary
  ┌──────────────────┬──────────────────────────────────┬─────────────────────────────────────────────┐
  │      Issue       │          What's Needed           │                 Who Does It                 │
  ├──────────────────┼──────────────────────────────────┼─────────────────────────────────────────────┤
  │ Icon             │ A polished 1024x1024 branded PNG │ You (design), then I regenerate sizes       │
  ├──────────────────┼──────────────────────────────────┼─────────────────────────────────────────────┤
  │ iPad Screenshots │ Real iPad simulator screenshots  │ You (capture + upload to App Store Connect) │
  └──────────────────┴──────────────────────────────────┴─────────────────────────────────────────────┘
  Neither issue requires code changes. The icon is the higher-effort item since it requires design work. Once you have the icon PNG ready, I can run the launcher
  icons generator. For the iPad screenshots, it's a straightforward simulator capture and App Store Connect upload.
