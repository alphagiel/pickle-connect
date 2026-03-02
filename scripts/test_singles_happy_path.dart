/// Singles Happy Path Test Script
///
/// Exercises the full singles proposal lifecycle against Firebase Emulators:
///   create → accept → score → confirm → complete → standings verified
///
/// Uses direct HTTP calls to emulator REST APIs (no Flutter dependency).
///
/// Prerequisites:
///   1. Firebase Emulators running: firebase emulators:start
///
/// Run with: dart run scripts/test_singles_happy_path.dart
/// Flags:  --no-cleanup  Keep test data in emulator after run

import 'dart:io';

import 'test_helpers.dart';

// ─── Main test ────────────────────────────────────────

Future<void> main(List<String> args) async {
  final cleanup = parseCleanupFlag(args);
  String? aliceUid;
  String? bobUid;
  String? proposalId;
  final now = DateTime.now();
  final aliceEmail = 'alice.test.${now.millisecondsSinceEpoch}@pickle.test';
  final bobEmail = 'bob.test.${now.millisecondsSinceEpoch + 1}@pickle.test';
  const password = 'TestPass123!';

  try {
    print('==========================================');
    print('  SINGLES HAPPY PATH TEST');
    print('==========================================\n');

    // ── Step 1: Create Alice ──────────────────────────
    print('Step 1: Creating Alice...');
    aliceUid = await createTestUser(
      email: aliceEmail,
      password: password,
      displayName: 'Alice Smith',
    );
    print('  Alice created (UID: $aliceUid)');

    // ── Step 2: Create Bob ────────────────────────────
    print('Step 2: Creating Bob...');
    bobUid = await createTestUser(
      email: bobEmail,
      password: password,
      displayName: 'Bob Johnson',
      location: 'Court B',
    );
    print('  Bob created (UID: $bobUid)');

    // ── Step 3: Create singles proposal as Alice ──────
    print('Step 3: Creating singles proposal (as Alice)...');
    await signIn(aliceEmail, password);
    proposalId = await createSinglesProposal(
      creatorId: aliceUid,
      creatorName: 'Alice Smith',
    );
    print('  Proposal created (ID: $proposalId)');

    // ── Step 4: Accept proposal as Bob ────────────────
    print('Step 4: Bob accepts proposal...');
    await signIn(bobEmail, password);
    await acceptProposal(proposalId, bobUid, 'Bob Johnson');
    print('  Proposal accepted');

    // Small delay to let the accepted trigger fire before scores
    await Future.delayed(const Duration(seconds: 1));

    // ── Step 5: Submit scores — Alice wins 2-0 ───────
    print('Step 5: Submitting scores (Alice wins 2-0: 11-7, 11-9)...');
    await signIn(aliceEmail, password);
    await submitScores(proposalId, [
      {'creatorScore': 11, 'opponentScore': 7},
      {'creatorScore': 11, 'opponentScore': 9},
    ]);
    print('  Scores submitted, status set to completed');

    // ── Step 6: Confirm scores ────────────────────────
    print('Step 6: Both players confirm scores...');

    // Alice confirms (already signed in as Alice)
    await confirmScores(proposalId, aliceUid);
    print('  Alice confirmed');

    // Bob confirms
    await signIn(bobEmail, password);
    await confirmScores(proposalId, bobUid);
    print('  Bob confirmed');

    // ── Step 7: Wait for Cloud Function ───────────────
    print('Step 7: Waiting for Cloud Function to process standings...');
    const standingsPath = 'standings/east_triangle_Intermediate/players';
    await waitForStandings(standingsPath, aliceUid);

    // ── Step 8: Verify proposal state ─────────────────
    print('\nStep 8: Verifying proposal state...');
    final proposalDoc = await fsGet('proposals/$proposalId');
    check('Proposal exists', proposalDoc != null);

    if (proposalDoc != null) {
      final data = decodeDoc(proposalDoc);

      check('Status is completed', data['status'] == 'completed');
      check('MatchType is singles', data['matchType'] == 'singles');
      check('CreatorId is Alice', data['creatorId'] == aliceUid);

      final acceptedBy = data['acceptedBy'] as Map<String, dynamic>?;
      check('AcceptedBy is Bob', acceptedBy?['userId'] == bobUid);

      final scores = data['scores'] as Map<String, dynamic>?;
      check('Scores present', scores != null);
      if (scores != null) {
        final games = scores['games'] as List<dynamic>;
        check('Two games played', games.length == 2);
        final g0 = games[0] as Map<String, dynamic>;
        final g1 = games[1] as Map<String, dynamic>;
        check('Game 1: 11-7',
            g0['creatorScore'] == 11 && g0['opponentScore'] == 7);
        check('Game 2: 11-9',
            g1['creatorScore'] == 11 && g1['opponentScore'] == 9);
      }

      final confirmedBy = data['scoreConfirmedBy'] as List<dynamic>? ?? [];
      check('Alice confirmed scores', confirmedBy.contains(aliceUid));
      check('Bob confirmed scores', confirmedBy.contains(bobUid));
    }

    // ── Step 9: Verify standings ──────────────────────
    print('\nStep 9: Verifying standings...');

    final aliceStandingDoc = await fsGet('$standingsPath/$aliceUid');
    if (aliceStandingDoc != null) {
      final d = decodeDoc(aliceStandingDoc);
      check('Alice matchesPlayed = 1', d['matchesPlayed'] == 1);
      check('Alice matchesWon = 1', d['matchesWon'] == 1);
      check('Alice matchesLost = 0', d['matchesLost'] == 0);
      check('Alice winRate = 1.0', d['winRate'] == 1.0);
      check('Alice streak = 1', d['streak'] == 1);
    } else {
      check('Alice standing exists', false);
    }

    final bobStandingDoc = await fsGet('$standingsPath/$bobUid');
    if (bobStandingDoc != null) {
      final d = decodeDoc(bobStandingDoc);
      check('Bob matchesPlayed = 1', d['matchesPlayed'] == 1);
      check('Bob matchesWon = 0', d['matchesWon'] == 0);
      check('Bob matchesLost = 1', d['matchesLost'] == 1);
      check('Bob winRate = 0.0', d['winRate'] == 0.0);
      check('Bob streak = -1', d['streak'] == -1);
    } else {
      check('Bob standing exists', false);
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
          if (proposalId != null) {
            await fsDelete('proposals/$proposalId');
            print('  Deleted proposal');
          }
          await fsDelete('users/$aliceUid');
          print('  Deleted Alice user doc');
        }
        if (bobUid != null) {
          await signIn(bobEmail, password);
          await fsDelete('users/$bobUid');
          print('  Deleted Bob user doc');
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
