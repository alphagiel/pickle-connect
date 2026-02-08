# Pickle Connect - TODO

## 2/8/2026 - Doubles Email Notifications

3 email templates exist but are never triggered (orphaned). 6 doubles events have no notification wiring at all.

### Status Key
- WIRED = template exists + trigger handler sends it
- ORPHANED = template exists but no trigger calls it
- MISSING = no template, no trigger

### Doubles Notification TODO List

| # | Event | Template File | Trigger Wired? | Status |
|---|-------|---------------|----------------|--------|
| 1 | **Create Doubles Proposal** — notify users in skill bracket that a doubles match is available | None (on-proposal-created.ts silently skips doubles) | No | MISSING |
| 2 | **Partner Invited** — notify invited partner when creator creates proposal with them | `doubles-partner-invite.ts` | No | ORPHANED |
| 3 | **Partner Confirms Invite** — notify creator that their partner accepted | None | No | MISSING |
| 4 | **Player Requests to Join** — notify creator that someone wants to join their lobby | `doubles-join-request.ts` | No | ORPHANED |
| 5 | **Player Approved** — notify the approved player that they're in | None | No | MISSING |
| 6 | **Lobby Full (4 confirmed)** — notify all 4 players the match is set | `doubles-lobby-full.ts` | No | ORPHANED |
| 7 | **Player Declined** — notify declined player | None | No | MISSING |
| 8 | **Player Left** — notify creator that a slot opened up | None | No | MISSING |
| 9 | **Proposal Canceled** — notify all players in lobby | None | No | MISSING |
| 10 | **Scores Recorded** — notify all 4 players of match result | `doubles-match-result.ts` | Yes (on-proposal-updated.ts) | WIRED |
| 11 | **Scores Confirmed** — notify other team that scores are confirmed | None | No | MISSING |

### Implementation Notes

- All trigger logic goes in `functions/src/triggers/on-proposal-updated.ts` (detects field changes on proposal documents)
- New proposal trigger goes in `functions/src/triggers/on-proposal-created.ts` (currently skips doubles)
- Templates are in `functions/src/templates/doubles-*.ts` and exported from `functions/src/templates/index.ts`
- Templates #2, #4, #6 already exist — just need trigger handlers to call them
- Templates #1, #3, #5, #7, #8, #9, #11 need to be created
- Template #10 is fully working

### Files to Modify
- `functions/src/triggers/on-proposal-created.ts` — handle doubles proposal creation (#1)
- `functions/src/triggers/on-proposal-updated.ts` — detect doublesPlayers array changes for #2-#9, #11
- `functions/src/templates/` — create missing templates

---
