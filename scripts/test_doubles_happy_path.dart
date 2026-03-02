/// Doubles Happy Path Test Script
///
/// Exercises the full doubles proposal lifecycle against Firebase Emulators:
///   create → join requests → approve teams → score → confirm → standings
///
/// Uses direct HTTP calls to emulator REST APIs (no Flutter dependency).
///
/// Prerequisites:
///   1. Firebase Emulators running: firebase emulators:start
///
/// Run with: dart run scripts/test_doubles_happy_path.dart
/// Flags:  --no-cleanup  Keep test data in emulator after run

import 'dart:io';

import 'test_helpers.dart';

// ─── Main test ────────────────────────────────────────

Future<void> main(List<String> args) async {
  final cleanup = parseCleanupFlag(args);
  String? aliceUid;
  String? bobUid;
  String? charlieUid;
  String? dianaUid;
  String? proposalId;
  final now = DateTime.now();
  final aliceEmail = 'alice.dbl.${now.millisecondsSinceEpoch}@pickle.test';
  final bobEmail = 'bob.dbl.${now.millisecondsSinceEpoch + 1}@pickle.test';
  final charlieEmail =
      'charlie.dbl.${now.millisecondsSinceEpoch + 2}@pickle.test';
  final dianaEmail = 'diana.dbl.${now.millisecondsSinceEpoch + 3}@pickle.test';
  const password = 'TestPass123!';

  try {
    print('==========================================');
    print('  DOUBLES HAPPY PATH TEST');
    print('==========================================\n');

    // ── Step 1: Create Alice (creator) ────────────────
    print('Step 1: Creating Alice...');
    aliceUid = await createTestUser(
      email: aliceEmail,
      password: password,
      displayName: 'Alice Smith',
    );
    print('  Alice created (UID: $aliceUid)');

    // ── Step 2: Create Bob, Charlie, Diana ────────────
    print('Step 2: Creating Bob, Charlie, Diana...');
    bobUid = await createTestUser(
      email: bobEmail,
      password: password,
      displayName: 'Bob Johnson',
    );
    print('  Bob created (UID: $bobUid)');

    charlieUid = await createTestUser(
      email: charlieEmail,
      password: password,
      displayName: 'Charlie Brown',
    );
    print('  Charlie created (UID: $charlieUid)');

    dianaUid = await createTestUser(
      email: dianaEmail,
      password: password,
      displayName: 'Diana Prince',
    );
    print('  Diana created (UID: $dianaUid)');

    // ── Step 3: Alice creates doubles proposal ────────
    print('Step 3: Alice creates doubles proposal...');
    await signIn(aliceEmail, password);
    proposalId = await createDoublesProposal(
      creatorId: aliceUid,
      creatorName: 'Alice Smith',
    );
    print('  Proposal created (ID: $proposalId)');

    // Verify initial state
    final initialDoc = await fsGet('proposals/$proposalId');
    if (initialDoc != null) {
      final data = decodeDoc(initialDoc);
      check('Initial matchType is doubles', data['matchType'] == 'doubles');
      check('Initial openSlots = 3', data['openSlots'] == 3);
      final players = data['doublesPlayers'] as List<dynamic>;
      check('Creator in doublesPlayers', players.length == 1);
      final creator = players[0] as Map<String, dynamic>;
      check('Creator is confirmed', creator['status'] == 'confirmed');
      check('Creator on team 1', creator['team'] == 1);
    }

    // ── Step 4: Bob requests to join ──────────────────
    print('Step 4: Bob requests to join...');
    await signIn(bobEmail, password);
    await requestJoinDoubles(proposalId, bobUid, 'Bob Johnson');

    final afterBobReq = await fsGet('proposals/$proposalId');
    if (afterBobReq != null) {
      final data = decodeDoc(afterBobReq);
      final players = data['doublesPlayers'] as List<dynamic>;
      check('2 players in lobby after Bob request', players.length == 2);
      final bob = (players).cast<Map<String, dynamic>>().firstWhere(
          (p) => p['userId'] == bobUid);
      check('Bob status is requested', bob['status'] == 'requested');
    }

    // ── Step 5: Alice approves Bob → team 2 ──────────
    print('Step 5: Alice approves Bob (team 2)...');
    await signIn(aliceEmail, password);
    await approveDoublesPlayer(proposalId, bobUid, 2);

    final afterBobApprove = await fsGet('proposals/$proposalId');
    if (afterBobApprove != null) {
      final data = decodeDoc(afterBobApprove);
      final players = (data['doublesPlayers'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      final bob = players.firstWhere((p) => p['userId'] == bobUid);
      check('Bob status is confirmed', bob['status'] == 'confirmed');
      check('Bob on team 2', bob['team'] == 2);
      check('OpenSlots = 2 after Bob approved', data['openSlots'] == 2);
    }

    // ── Step 6: Charlie requests to join ──────────────
    print('Step 6: Charlie requests to join...');
    await signIn(charlieEmail, password);
    await requestJoinDoubles(proposalId, charlieUid, 'Charlie Brown');

    // ── Step 7: Alice approves Charlie → team 1 ──────
    print('Step 7: Alice approves Charlie (team 1)...');
    await signIn(aliceEmail, password);
    await approveDoublesPlayer(proposalId, charlieUid, 1);

    final afterCharlie = await fsGet('proposals/$proposalId');
    if (afterCharlie != null) {
      final data = decodeDoc(afterCharlie);
      check('OpenSlots = 1 after Charlie approved', data['openSlots'] == 1);
    }

    // ── Step 8: Diana requests to join ────────────────
    print('Step 8: Diana requests to join...');
    await signIn(dianaEmail, password);
    await requestJoinDoubles(proposalId, dianaUid, 'Diana Prince');

    // ── Step 9: Alice approves Diana → team 2 ────────
    print('Step 9: Alice approves Diana (team 2)...');
    await signIn(aliceEmail, password);
    await approveDoublesPlayer(proposalId, dianaUid, 2);

    final afterDiana = await fsGet('proposals/$proposalId');
    if (afterDiana != null) {
      final data = decodeDoc(afterDiana);
      check('OpenSlots = 0 (lobby full)', data['openSlots'] == 0);
      final players = (data['doublesPlayers'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      final confirmed =
          players.where((p) => p['status'] == 'confirmed').toList();
      check('4 confirmed players', confirmed.length == 4);
    }

    // ── Step 10: Verify team composition ──────────────
    print('\nStep 10: Verifying team composition...');
    final teamDoc = await fsGet('proposals/$proposalId');
    if (teamDoc != null) {
      final data = decodeDoc(teamDoc);
      final players = (data['doublesPlayers'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      final team1 = players
          .where((p) => p['team'] == 1 && p['status'] == 'confirmed')
          .toList();
      final team2 = players
          .where((p) => p['team'] == 2 && p['status'] == 'confirmed')
          .toList();

      check('Team 1 has 2 players', team1.length == 2);
      check('Team 2 has 2 players', team2.length == 2);

      final team1Ids = team1.map((p) => p['userId']).toSet();
      final team2Ids = team2.map((p) => p['userId']).toSet();
      check(
          'Team 1 = Alice + Charlie',
          team1Ids.contains(aliceUid) &&
              team1Ids.contains(charlieUid));
      check(
          'Team 2 = Bob + Diana',
          team2Ids.contains(bobUid) && team2Ids.contains(dianaUid));
    }

    // ── Step 11: Submit scores — Team 1 wins 2-0 ─────
    print('\nStep 11: Submitting scores (Team 1 wins 2-0: 11-7, 11-9)...');
    await signIn(aliceEmail, password);
    await submitScores(proposalId, [
      {'creatorScore': 11, 'opponentScore': 7},
      {'creatorScore': 11, 'opponentScore': 9},
    ]);
    print('  Scores submitted');

    // ── Step 12: Both sides confirm scores ────────────
    print('Step 12: Confirming scores...');

    // Alice confirms (already signed in)
    await confirmScores(proposalId, aliceUid);
    print('  Alice confirmed');

    // Bob confirms (one player from each side is enough per the logic)
    await signIn(bobEmail, password);
    await confirmScores(proposalId, bobUid);
    print('  Bob confirmed');

    // ── Step 13: Wait for Cloud Function ──────────────
    print('\nStep 13: Waiting for Cloud Function to process standings...');
    const standingsPath =
        'doubles_standings/east_triangle_Intermediate/players';
    await waitForStandings(standingsPath, aliceUid);

    // ── Step 14: Verify standings ─────────────────────
    print('\nStep 14: Verifying standings...');

    // Alice (Team 1 — won)
    final aliceStanding = await fsGet('$standingsPath/$aliceUid');
    if (aliceStanding != null) {
      final d = decodeDoc(aliceStanding);
      check('Alice matchesPlayed = 1', d['matchesPlayed'] == 1);
      check('Alice matchesWon = 1', d['matchesWon'] == 1);
      check('Alice matchesLost = 0', d['matchesLost'] == 0);
      check('Alice winRate = 1.0', d['winRate'] == 1.0);
    } else {
      check('Alice standing exists', false);
    }

    // Charlie (Team 1 — won)
    final charlieStanding = await fsGet('$standingsPath/$charlieUid');
    if (charlieStanding != null) {
      final d = decodeDoc(charlieStanding);
      check('Charlie matchesPlayed = 1', d['matchesPlayed'] == 1);
      check('Charlie matchesWon = 1', d['matchesWon'] == 1);
    } else {
      check('Charlie standing exists', false);
    }

    // Bob (Team 2 — lost)
    final bobStanding = await fsGet('$standingsPath/$bobUid');
    if (bobStanding != null) {
      final d = decodeDoc(bobStanding);
      check('Bob matchesPlayed = 1', d['matchesPlayed'] == 1);
      check('Bob matchesWon = 0', d['matchesWon'] == 0);
      check('Bob matchesLost = 1', d['matchesLost'] == 1);
    } else {
      check('Bob standing exists', false);
    }

    // Diana (Team 2 — lost)
    final dianaStanding = await fsGet('$standingsPath/$dianaUid');
    if (dianaStanding != null) {
      final d = decodeDoc(dianaStanding);
      check('Diana matchesPlayed = 1', d['matchesPlayed'] == 1);
      check('Diana matchesWon = 0', d['matchesWon'] == 0);
      check('Diana matchesLost = 1', d['matchesLost'] == 1);
    } else {
      check('Diana standing exists', false);
    }
  } catch (e, stack) {
    print('\n[ERROR] $e');
    print(stack);
    testFailed++;
    testFailures.add('Unhandled exception: $e');
  } finally {
    // ── Cleanup ───────────────────────────────────────
    if (cleanup) {
      print('\nCleaning up...');
      try {
        if (aliceUid != null) {
          await signIn(aliceEmail, password);
          if (proposalId != null) await fsDelete('proposals/$proposalId');
          await fsDelete('users/$aliceUid');
          print('  Deleted Alice');
        }
        for (final entry in [
          (bobUid, bobEmail, 'Bob'),
          (charlieUid, charlieEmail, 'Charlie'),
          (dianaUid, dianaEmail, 'Diana'),
        ]) {
          if (entry.$1 != null) {
            await signIn(entry.$2, password);
            await fsDelete('users/${entry.$1}');
            print('  Deleted ${entry.$3}');
          }
        }
        print('  (Standings docs cleared on emulator restart)');
      } catch (e) {
        print('  Cleanup error (non-fatal): $e');
      }
    } else {
      print('\n  Skipping cleanup (--no-cleanup). Data preserved in emulator.');
    }

    // ── Summary ───────────────────────────────────────
    print('\n==========================================');
    print('  RESULTS: $testPassed passed, $testFailed failed');
    print('==========================================');
    if (testFailures.isNotEmpty) {
      print('\nFailures:');
      for (final f in testFailures) {
        print('  - $f');
      }
    }
    print('');

    httpClient.close();
    exit(testFailed > 0 ? 1 : 0);
  }
}
