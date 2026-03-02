/// Singles Edge Case Test Script
///
/// Tests edge cases in the singles proposal lifecycle against Firebase Emulators:
///   1. Cancel Open Proposal
///   2. Cancel Accepted Proposal
///   3. Unaccept Proposal
///   4. Score Rejection (clearScores → re-record → complete)
///   5. Partial Confirm Then Reject
///   6. Opponent Wins (reverse winner)
///
/// Prerequisites:
///   1. Firebase Emulators running: firebase emulators:start
///
/// Run with: dart run scripts/test_singles_edge_cases.dart
/// Flags:  --no-cleanup  Keep test data in emulator after run

import 'dart:io';

import 'test_helpers.dart';

bool _cleanup = true;

// ─── Scenario runner ──────────────────────────────────

/// Runs a scenario function, catching errors. Returns true if all checks passed.
Future<bool> runScenario(
    String name, Future<void> Function() scenario) async {
  print('\n──────────────────────────────────────────');
  print('  SCENARIO: $name');
  print('──────────────────────────────────────────\n');

  final beforePassed = testPassed;
  final beforeFailed = testFailed;

  try {
    await scenario();
  } catch (e, stack) {
    print('\n  [ERROR] $e');
    print(stack);
    testFailed++;
    testFailures.add('$name: Unhandled exception: $e');
  }

  final scenarioPassed = testFailed == beforeFailed;
  final checks = (testPassed - beforePassed) + (testFailed - beforeFailed);
  print(
      '\n  ${scenarioPassed ? "PASSED" : "FAILED"} ($checks checks)\n');
  return scenarioPassed;
}

// ─── Unique email generator ───────────────────────────

int _emailCounter = 0;
String _uniqueEmail(String prefix) {
  _emailCounter++;
  return '$prefix.${DateTime.now().millisecondsSinceEpoch}.$_emailCounter@pickle.test';
}

const _password = 'TestPass123!';

// ─── Scenario 1: Cancel Open Proposal ─────────────────

Future<void> testCancelOpen() async {
  final aliceEmail = _uniqueEmail('alice.cancel.open');
  String? aliceUid;
  String? proposalId;

  try {
    // Create Alice
    print('  Creating Alice...');
    aliceUid = await createTestUser(
        email: aliceEmail, password: _password, displayName: 'Alice Cancel');

    // Create proposal
    print('  Creating open proposal...');
    await signIn(aliceEmail, _password);
    proposalId = await createSinglesProposal(
        creatorId: aliceUid, creatorName: 'Alice Cancel');
    print('  Proposal created: $proposalId');

    // Cancel it
    print('  Canceling proposal...');
    await cancelProposal(proposalId);

    // Wait a moment for Cloud Function trigger
    await Future.delayed(const Duration(seconds: 2));

    // Verify
    print('  Verifying...');
    final doc = await fsGet('proposals/$proposalId');
    check('Proposal exists after cancel', doc != null);
    if (doc != null) {
      final data = decodeDoc(doc);
      check('Status is canceled', data['status'] == 'canceled');
      check('CreatorId preserved', data['creatorId'] == aliceUid);
      check('No acceptedBy', data['acceptedBy'] == null);
    }
  } finally {
    if (_cleanup) {
      if (aliceUid != null) {
        await signIn(aliceEmail, _password);
        if (proposalId != null) await fsDelete('proposals/$proposalId');
        await fsDelete('users/$aliceUid');
      }
    }
  }
}

// ─── Scenario 2: Cancel Accepted Proposal ─────────────

Future<void> testCancelAccepted() async {
  final aliceEmail = _uniqueEmail('alice.cancel.accepted');
  final bobEmail = _uniqueEmail('bob.cancel.accepted');
  String? aliceUid;
  String? bobUid;
  String? proposalId;

  try {
    // Create users
    print('  Creating Alice...');
    aliceUid = await createTestUser(
        email: aliceEmail, password: _password, displayName: 'Alice CancelAcc');
    print('  Creating Bob...');
    bobUid = await createTestUser(
        email: bobEmail, password: _password, displayName: 'Bob CancelAcc');

    // Create proposal as Alice
    print('  Creating proposal as Alice...');
    await signIn(aliceEmail, _password);
    proposalId = await createSinglesProposal(
        creatorId: aliceUid, creatorName: 'Alice CancelAcc');

    // Bob accepts
    print('  Bob accepts...');
    await signIn(bobEmail, _password);
    await acceptProposal(proposalId, bobUid, 'Bob CancelAcc');

    await Future.delayed(const Duration(seconds: 1));

    // Alice cancels
    print('  Alice cancels accepted proposal...');
    await signIn(aliceEmail, _password);
    await cancelProposal(proposalId);

    await Future.delayed(const Duration(seconds: 2));

    // Verify
    print('  Verifying...');
    final doc = await fsGet('proposals/$proposalId');
    check('Proposal exists after cancel', doc != null);
    if (doc != null) {
      final data = decodeDoc(doc);
      check('Status is canceled', data['status'] == 'canceled');
      check('CreatorId preserved', data['creatorId'] == aliceUid);
      // acceptedBy should still be present (cancel doesn't remove it)
      final acceptedBy = data['acceptedBy'] as Map<String, dynamic>?;
      check('AcceptedBy preserved', acceptedBy != null);
      check('AcceptedBy is Bob', acceptedBy?['userId'] == bobUid);
    }
  } finally {
    if (_cleanup) {
      if (aliceUid != null) {
        await signIn(aliceEmail, _password);
        if (proposalId != null) await fsDelete('proposals/$proposalId');
        await fsDelete('users/$aliceUid');
      }
      if (bobUid != null) {
        await signIn(bobEmail, _password);
        await fsDelete('users/$bobUid');
      }
    }
  }
}

// ─── Scenario 3: Unaccept Proposal ────────────────────

Future<void> testUnaccept() async {
  final aliceEmail = _uniqueEmail('alice.unaccept');
  final bobEmail = _uniqueEmail('bob.unaccept');
  String? aliceUid;
  String? bobUid;
  String? proposalId;

  try {
    // Create users
    print('  Creating Alice...');
    aliceUid = await createTestUser(
        email: aliceEmail, password: _password, displayName: 'Alice Unacc');
    print('  Creating Bob...');
    bobUid = await createTestUser(
        email: bobEmail, password: _password, displayName: 'Bob Unacc');

    // Create proposal as Alice
    print('  Creating proposal as Alice...');
    await signIn(aliceEmail, _password);
    proposalId = await createSinglesProposal(
        creatorId: aliceUid, creatorName: 'Alice Unacc');

    // Bob accepts
    print('  Bob accepts...');
    await signIn(bobEmail, _password);
    await acceptProposal(proposalId, bobUid, 'Bob Unacc');

    await Future.delayed(const Duration(seconds: 1));

    // Verify accepted state first
    final acceptedDoc = await fsGet('proposals/$proposalId');
    if (acceptedDoc != null) {
      final acceptedData = decodeDoc(acceptedDoc);
      check('Status is accepted before unaccept',
          acceptedData['status'] == 'accepted');
    }

    // Bob unaccepts
    print('  Bob unaccepts...');
    await unacceptProposal(proposalId);

    await Future.delayed(const Duration(seconds: 2));

    // Verify
    print('  Verifying...');
    final doc = await fsGet('proposals/$proposalId');
    check('Proposal exists after unaccept', doc != null);
    if (doc != null) {
      final data = decodeDoc(doc);
      check('Status reverted to open', data['status'] == 'open');
      check('AcceptedBy is null', data['acceptedBy'] == null);
      check('CreatorId preserved', data['creatorId'] == aliceUid);
    }
  } finally {
    if (_cleanup) {
      if (aliceUid != null) {
        await signIn(aliceEmail, _password);
        if (proposalId != null) await fsDelete('proposals/$proposalId');
        await fsDelete('users/$aliceUid');
      }
      if (bobUid != null) {
        await signIn(bobEmail, _password);
        await fsDelete('users/$bobUid');
      }
    }
  }
}

// ─── Scenario 4: Score Rejection ──────────────────────

Future<void> testScoreRejection() async {
  final aliceEmail = _uniqueEmail('alice.score.reject');
  final bobEmail = _uniqueEmail('bob.score.reject');
  String? aliceUid;
  String? bobUid;
  String? proposalId;

  try {
    // Create users
    print('  Creating Alice...');
    aliceUid = await createTestUser(
        email: aliceEmail, password: _password, displayName: 'Alice ScoreRej');
    print('  Creating Bob...');
    bobUid = await createTestUser(
        email: bobEmail, password: _password, displayName: 'Bob ScoreRej');

    // Create proposal, accept
    print('  Creating proposal as Alice...');
    await signIn(aliceEmail, _password);
    proposalId = await createSinglesProposal(
        creatorId: aliceUid, creatorName: 'Alice ScoreRej');

    print('  Bob accepts...');
    await signIn(bobEmail, _password);
    await acceptProposal(proposalId, bobUid, 'Bob ScoreRej');
    await Future.delayed(const Duration(seconds: 1));

    // Record scores (wrong ones)
    print('  Recording initial scores (Alice wins 2-0: 11-3, 11-5)...');
    await signIn(aliceEmail, _password);
    await submitScores(proposalId, [
      {'creatorScore': 11, 'opponentScore': 3},
      {'creatorScore': 11, 'opponentScore': 5},
    ]);
    await Future.delayed(const Duration(seconds: 2));

    // Bob rejects (clearScores)
    print('  Bob rejects scores (clearScores)...');
    await signIn(bobEmail, _password);
    await clearScores(proposalId);
    await Future.delayed(const Duration(seconds: 1));

    // Verify cleared state
    print('  Verifying cleared state...');
    final clearedDoc = await fsGet('proposals/$proposalId');
    check('Proposal exists after clear', clearedDoc != null);
    if (clearedDoc != null) {
      final data = decodeDoc(clearedDoc);
      check('Scores cleared (null)',
          !data.containsKey('scores') || data['scores'] == null);
      final confirmedBy = data['scoreConfirmedBy'] as List<dynamic>? ?? [];
      check('ScoreConfirmedBy reset to empty', confirmedBy.isEmpty);
      check('Status back to accepted', data['status'] == 'accepted');
    }

    // Re-record correct scores
    print('  Re-recording scores (Alice wins 2-0: 11-7, 11-9)...');
    await signIn(aliceEmail, _password);
    await submitScores(proposalId, [
      {'creatorScore': 11, 'opponentScore': 7},
      {'creatorScore': 11, 'opponentScore': 9},
    ]);
    await Future.delayed(const Duration(seconds: 1));

    // Both confirm
    print('  Alice confirms...');
    await confirmScores(proposalId, aliceUid);
    print('  Bob confirms...');
    await signIn(bobEmail, _password);
    await confirmScores(proposalId, bobUid);

    // Wait for Cloud Function
    print('  Waiting for standings...');
    const standingsPath = 'standings/east_triangle_Intermediate/players';
    final found = await waitForStandings(standingsPath, aliceUid);

    // Verify final state
    print('  Verifying final proposal state...');
    final finalDoc = await fsGet('proposals/$proposalId');
    if (finalDoc != null) {
      final data = decodeDoc(finalDoc);
      check('Final status is completed', data['status'] == 'completed');
      final scores = data['scores'] as Map<String, dynamic>?;
      check('Final scores present', scores != null);
      if (scores != null) {
        final games = scores['games'] as List<dynamic>;
        check('Two games in final scores', games.length == 2);
        final g0 = games[0] as Map<String, dynamic>;
        check('Final game 1: 11-7',
            g0['creatorScore'] == 11 && g0['opponentScore'] == 7);
      }
      final confirmedBy = data['scoreConfirmedBy'] as List<dynamic>? ?? [];
      check('Both confirmed final scores', confirmedBy.length == 2);
    }

    // Verify standings (only 1 match, not 2 — standings now update on confirmation)
    if (found) {
      print('  Verifying standings reflect only final scores...');
      final aliceStanding = await fsGet('$standingsPath/$aliceUid');
      if (aliceStanding != null) {
        final d = decodeDoc(aliceStanding);
        check('Alice matchesPlayed = 1', d['matchesPlayed'] == 1);
        check('Alice matchesWon = 1', d['matchesWon'] == 1);
      } else {
        check('Alice standing exists', false);
      }
    }
  } finally {
    if (_cleanup) {
      if (aliceUid != null) {
        await signIn(aliceEmail, _password);
        if (proposalId != null) await fsDelete('proposals/$proposalId');
        await fsDelete('users/$aliceUid');
      }
      if (bobUid != null) {
        await signIn(bobEmail, _password);
        await fsDelete('users/$bobUid');
      }
    }
  }
}

// ─── Scenario 5: Partial Confirm Then Reject ──────────

Future<void> testPartialConfirmReject() async {
  final aliceEmail = _uniqueEmail('alice.partial.confirm');
  final bobEmail = _uniqueEmail('bob.partial.confirm');
  String? aliceUid;
  String? bobUid;
  String? proposalId;

  try {
    // Create users
    print('  Creating Alice...');
    aliceUid = await createTestUser(
        email: aliceEmail,
        password: _password,
        displayName: 'Alice PartConf');
    print('  Creating Bob...');
    bobUid = await createTestUser(
        email: bobEmail, password: _password, displayName: 'Bob PartConf');

    // Create proposal, accept
    print('  Creating proposal as Alice...');
    await signIn(aliceEmail, _password);
    proposalId = await createSinglesProposal(
        creatorId: aliceUid, creatorName: 'Alice PartConf');

    print('  Bob accepts...');
    await signIn(bobEmail, _password);
    await acceptProposal(proposalId, bobUid, 'Bob PartConf');
    await Future.delayed(const Duration(seconds: 1));

    // Record scores
    print('  Recording scores (Alice wins 2-0: 11-4, 11-6)...');
    await signIn(aliceEmail, _password);
    await submitScores(proposalId, [
      {'creatorScore': 11, 'opponentScore': 4},
      {'creatorScore': 11, 'opponentScore': 6},
    ]);
    await Future.delayed(const Duration(seconds: 1));

    // Alice confirms
    print('  Alice confirms scores...');
    await confirmScores(proposalId, aliceUid);

    // Verify partial confirmation
    final partialDoc = await fsGet('proposals/$proposalId');
    if (partialDoc != null) {
      final data = decodeDoc(partialDoc);
      final confirmedBy = data['scoreConfirmedBy'] as List<dynamic>? ?? [];
      check('Only Alice confirmed so far',
          confirmedBy.length == 1 && confirmedBy.contains(aliceUid));
    }

    // Bob rejects (clearScores) — wipes Alice's confirmation too
    print('  Bob rejects scores (clearScores)...');
    await signIn(bobEmail, _password);
    await clearScores(proposalId);
    await Future.delayed(const Duration(seconds: 1));

    // Verify cleared state
    print('  Verifying cleared state...');
    final clearedDoc = await fsGet('proposals/$proposalId');
    check('Proposal exists after clear', clearedDoc != null);
    if (clearedDoc != null) {
      final data = decodeDoc(clearedDoc);
      check('Scores cleared',
          !data.containsKey('scores') || data['scores'] == null);
      final confirmedBy = data['scoreConfirmedBy'] as List<dynamic>? ?? [];
      check('All confirmations wiped', confirmedBy.isEmpty);
      check('Status back to accepted', data['status'] == 'accepted');
    }

    // Re-record and both confirm
    print('  Re-recording scores (Alice wins 2-1: 11-8, 9-11, 11-6)...');
    await signIn(aliceEmail, _password);
    await submitScores(proposalId, [
      {'creatorScore': 11, 'opponentScore': 8},
      {'creatorScore': 9, 'opponentScore': 11},
      {'creatorScore': 11, 'opponentScore': 6},
    ]);
    await Future.delayed(const Duration(seconds: 1));

    print('  Alice confirms...');
    await confirmScores(proposalId, aliceUid);
    print('  Bob confirms...');
    await signIn(bobEmail, _password);
    await confirmScores(proposalId, bobUid);

    // Wait for Cloud Function
    print('  Waiting for standings...');
    const standingsPath = 'standings/east_triangle_Intermediate/players';
    await waitForStandings(standingsPath, aliceUid);

    // Verify final state
    print('  Verifying final state...');
    final finalDoc = await fsGet('proposals/$proposalId');
    if (finalDoc != null) {
      final data = decodeDoc(finalDoc);
      check('Final status is completed', data['status'] == 'completed');
      final scores = data['scores'] as Map<String, dynamic>?;
      if (scores != null) {
        final games = scores['games'] as List<dynamic>;
        check('Three games in final scores', games.length == 3);
      }
      final confirmedBy = data['scoreConfirmedBy'] as List<dynamic>? ?? [];
      check('Both confirmed final scores', confirmedBy.length == 2);
    }
  } finally {
    if (_cleanup) {
      if (aliceUid != null) {
        await signIn(aliceEmail, _password);
        if (proposalId != null) await fsDelete('proposals/$proposalId');
        await fsDelete('users/$aliceUid');
      }
      if (bobUid != null) {
        await signIn(bobEmail, _password);
        await fsDelete('users/$bobUid');
      }
    }
  }
}

// ─── Scenario 6: Opponent Wins (Reverse Winner) ───────

Future<void> testOpponentWins() async {
  final aliceEmail = _uniqueEmail('alice.opp.wins');
  final bobEmail = _uniqueEmail('bob.opp.wins');
  String? aliceUid;
  String? bobUid;
  String? proposalId;

  try {
    // Create users
    print('  Creating Alice...');
    aliceUid = await createTestUser(
        email: aliceEmail, password: _password, displayName: 'Alice OppWins');
    print('  Creating Bob...');
    bobUid = await createTestUser(
        email: bobEmail, password: _password, displayName: 'Bob OppWins');

    // Create proposal as Alice, Bob accepts
    print('  Creating proposal as Alice...');
    await signIn(aliceEmail, _password);
    proposalId = await createSinglesProposal(
        creatorId: aliceUid, creatorName: 'Alice OppWins');

    print('  Bob accepts...');
    await signIn(bobEmail, _password);
    await acceptProposal(proposalId, bobUid, 'Bob OppWins');
    await Future.delayed(const Duration(seconds: 1));

    // Record scores — Bob (opponent) wins 2-1
    // creatorScore = Alice, opponentScore = Bob
    print('  Recording scores (Bob wins 2-1: 7-11, 11-5, 8-11)...');
    await signIn(aliceEmail, _password);
    await submitScores(proposalId, [
      {'creatorScore': 7, 'opponentScore': 11},  // Bob wins
      {'creatorScore': 11, 'opponentScore': 5},   // Alice wins
      {'creatorScore': 8, 'opponentScore': 11},   // Bob wins
    ]);
    await Future.delayed(const Duration(seconds: 1));

    // Both confirm
    print('  Alice confirms...');
    await confirmScores(proposalId, aliceUid);
    print('  Bob confirms...');
    await signIn(bobEmail, _password);
    await confirmScores(proposalId, bobUid);

    // Wait for Cloud Function
    print('  Waiting for standings...');
    const standingsPath = 'standings/east_triangle_Intermediate/players';
    final found = await waitForStandings(standingsPath, bobUid);

    // Verify proposal state
    print('  Verifying proposal state...');
    final finalDoc = await fsGet('proposals/$proposalId');
    if (finalDoc != null) {
      final data = decodeDoc(finalDoc);
      check('Status is completed', data['status'] == 'completed');

      final scores = data['scores'] as Map<String, dynamic>?;
      check('Scores present', scores != null);
      if (scores != null) {
        final games = scores['games'] as List<dynamic>;
        check('Three games played', games.length == 3);
      }
    }

    // Verify standings — Bob should have won, Alice should have lost
    if (found) {
      print('  Verifying standings (Bob won, Alice lost)...');

      final bobStanding = await fsGet('$standingsPath/$bobUid');
      if (bobStanding != null) {
        final d = decodeDoc(bobStanding);
        check('Bob matchesPlayed = 1', d['matchesPlayed'] == 1);
        check('Bob matchesWon = 1', d['matchesWon'] == 1);
        check('Bob matchesLost = 0', d['matchesLost'] == 0);
        check('Bob winRate = 1.0', d['winRate'] == 1.0);
        check('Bob streak = 1', d['streak'] == 1);
      } else {
        check('Bob standing exists', false);
      }

      final aliceStanding = await fsGet('$standingsPath/$aliceUid');
      if (aliceStanding != null) {
        final d = decodeDoc(aliceStanding);
        check('Alice matchesPlayed = 1', d['matchesPlayed'] == 1);
        check('Alice matchesWon = 0', d['matchesWon'] == 0);
        check('Alice matchesLost = 1', d['matchesLost'] == 1);
        check('Alice winRate = 0.0', d['winRate'] == 0.0);
        check('Alice streak = -1', d['streak'] == -1);
      } else {
        check('Alice standing exists', false);
      }
    }
  } finally {
    if (_cleanup) {
      if (aliceUid != null) {
        await signIn(aliceEmail, _password);
        if (proposalId != null) await fsDelete('proposals/$proposalId');
        await fsDelete('users/$aliceUid');
      }
      if (bobUid != null) {
        await signIn(bobEmail, _password);
        await fsDelete('users/$bobUid');
      }
    }
  }
}

// ─── Main ─────────────────────────────────────────────

Future<void> main(List<String> args) async {
  _cleanup = parseCleanupFlag(args);
  final results = <String, bool>{};

  print('==========================================');
  print('  SINGLES EDGE CASE TESTS');
  print('==========================================');

  results['Cancel Open Proposal'] =
      await runScenario('Cancel Open Proposal', testCancelOpen);
  results['Cancel Accepted Proposal'] =
      await runScenario('Cancel Accepted Proposal', testCancelAccepted);
  results['Unaccept Proposal'] =
      await runScenario('Unaccept Proposal', testUnaccept);
  results['Score Rejection'] =
      await runScenario('Score Rejection', testScoreRejection);
  results['Partial Confirm Then Reject'] =
      await runScenario('Partial Confirm Then Reject', testPartialConfirmReject);
  results['Opponent Wins'] =
      await runScenario('Opponent Wins', testOpponentWins);

  // ── Summary ────────────────────────────────────────
  print('\n==========================================');
  print('  SCENARIO SUMMARY');
  print('==========================================');
  for (final entry in results.entries) {
    print('  ${entry.value ? "[PASS]" : "[FAIL]"} ${entry.key}');
  }

  print('\n==========================================');
  print('  TOTAL: $testPassed passed, $testFailed failed');
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
