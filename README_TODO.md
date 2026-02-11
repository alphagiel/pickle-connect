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
