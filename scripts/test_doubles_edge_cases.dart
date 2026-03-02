/// Doubles Edge Case Test Script
///
/// Tests edge cases in the doubles proposal lifecycle against Firebase Emulators:
///   1. Cancel Doubles Proposal
///   2. Decline Join Request
///   3. Player Leaves After Confirmed
///   4. Partner Invite Flow
///   5. Doubles Score Rejection
///   6. Team 2 Wins
///
/// Prerequisites:
///   1. Firebase Emulators running: firebase emulators:start
///
/// Run with: dart run scripts/test_doubles_edge_cases.dart
/// Flags:  --no-cleanup  Keep test data in emulator after run

import 'dart:io';

import 'test_helpers.dart';

bool _cleanup = true;

// ─── Scenario runner ──────────────────────────────────

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

// ─── Helper: create 4 users and fill a doubles lobby ──

/// Creates 4 users, a doubles proposal, and fills the lobby.
/// Returns (proposalId, [aliceUid, bobUid, charlieUid, dianaUid], [emails]).
Future<({String proposalId, List<String> uids, List<String> emails})>
    createFilledDoublesLobby(String prefix) async {
  final aliceEmail = _uniqueEmail('$prefix.alice');
  final bobEmail = _uniqueEmail('$prefix.bob');
  final charlieEmail = _uniqueEmail('$prefix.charlie');
  final dianaEmail = _uniqueEmail('$prefix.diana');

  final aliceUid = await createTestUser(
      email: aliceEmail, password: _password, displayName: 'Alice $prefix');
  final bobUid = await createTestUser(
      email: bobEmail, password: _password, displayName: 'Bob $prefix');
  final charlieUid = await createTestUser(
      email: charlieEmail,
      password: _password,
      displayName: 'Charlie $prefix');
  final dianaUid = await createTestUser(
      email: dianaEmail, password: _password, displayName: 'Diana $prefix');

  // Alice creates proposal
  await signIn(aliceEmail, _password);
  final proposalId = await createDoublesProposal(
      creatorId: aliceUid, creatorName: 'Alice $prefix');

  // Bob, Charlie, Diana request to join
  await signIn(bobEmail, _password);
  await requestJoinDoubles(proposalId, bobUid, 'Bob $prefix');
  await signIn(charlieEmail, _password);
  await requestJoinDoubles(proposalId, charlieUid, 'Charlie $prefix');
  await signIn(dianaEmail, _password);
  await requestJoinDoubles(proposalId, dianaUid, 'Diana $prefix');

  // Alice approves all: Bob→team2, Charlie→team1, Diana→team2
  await signIn(aliceEmail, _password);
  await approveDoublesPlayer(proposalId, bobUid, 2);
  await approveDoublesPlayer(proposalId, charlieUid, 1);
  await approveDoublesPlayer(proposalId, dianaUid, 2);

  return (
    proposalId: proposalId,
    uids: [aliceUid, bobUid, charlieUid, dianaUid],
    emails: [aliceEmail, bobEmail, charlieEmail, dianaEmail],
  );
}

/// Cleanup helper for doubles tests.
Future<void> cleanupDoubles(
    String? proposalId, List<String?> uids, List<String> emails) async {
  if (!_cleanup) return;
  try {
    if (uids.isNotEmpty && uids[0] != null) {
      await signIn(emails[0], _password);
      if (proposalId != null) await fsDelete('proposals/$proposalId');
    }
    for (var i = 0; i < uids.length; i++) {
      if (uids[i] != null) {
        await signIn(emails[i], _password);
        await fsDelete('users/${uids[i]}');
      }
    }
  } catch (e) {
    print('  Cleanup error (non-fatal): $e');
  }
}

// ─── Scenario 1: Cancel Doubles Proposal ──────────────

Future<void> testCancelDoubles() async {
  final aliceEmail = _uniqueEmail('cancel.alice');
  final bobEmail = _uniqueEmail('cancel.bob');
  String? aliceUid;
  String? bobUid;
  String? proposalId;

  try {
    print('  Creating users...');
    aliceUid = await createTestUser(
        email: aliceEmail, password: _password, displayName: 'Alice Cancel');
    bobUid = await createTestUser(
        email: bobEmail, password: _password, displayName: 'Bob Cancel');

    // Create proposal, Bob joins and is approved
    print('  Creating doubles proposal...');
    await signIn(aliceEmail, _password);
    proposalId = await createDoublesProposal(
        creatorId: aliceUid, creatorName: 'Alice Cancel');

    print('  Bob requests to join...');
    await signIn(bobEmail, _password);
    await requestJoinDoubles(proposalId, bobUid, 'Bob Cancel');

    print('  Alice approves Bob...');
    await signIn(aliceEmail, _password);
    await approveDoublesPlayer(proposalId, bobUid, 2);

    // Cancel
    print('  Canceling proposal...');
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
      final players = (data['doublesPlayers'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      check('DoublesPlayers preserved (2)', players.length == 2);
      check('PlayerIds preserved',
          (data['playerIds'] as List<dynamic>).length == 2);
    }
  } finally {
    await cleanupDoubles(
        proposalId, [aliceUid, bobUid], [aliceEmail, bobEmail]);
  }
}

// ─── Scenario 2: Decline Join Request ─────────────────

Future<void> testDeclineRequest() async {
  final aliceEmail = _uniqueEmail('decline.alice');
  final bobEmail = _uniqueEmail('decline.bob');
  String? aliceUid;
  String? bobUid;
  String? proposalId;

  try {
    print('  Creating users...');
    aliceUid = await createTestUser(
        email: aliceEmail, password: _password, displayName: 'Alice Decline');
    bobUid = await createTestUser(
        email: bobEmail, password: _password, displayName: 'Bob Decline');

    // Create proposal
    print('  Creating doubles proposal...');
    await signIn(aliceEmail, _password);
    proposalId = await createDoublesProposal(
        creatorId: aliceUid, creatorName: 'Alice Decline');

    // Bob requests
    print('  Bob requests to join...');
    await signIn(bobEmail, _password);
    await requestJoinDoubles(proposalId, bobUid, 'Bob Decline');

    // Alice declines Bob
    print('  Alice declines Bob...');
    await signIn(aliceEmail, _password);
    await declineDoublesPlayer(proposalId, bobUid);
    await Future.delayed(const Duration(seconds: 2));

    // Verify
    print('  Verifying...');
    final doc = await fsGet('proposals/$proposalId');
    check('Proposal exists', doc != null);
    if (doc != null) {
      final data = decodeDoc(doc);
      final players = (data['doublesPlayers'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      check('Bob removed from doublesPlayers', players.length == 1);
      check(
          'Only Alice remains',
          players[0]['userId'] == aliceUid);
      final playerIds = data['playerIds'] as List<dynamic>;
      check('Bob removed from playerIds', !playerIds.contains(bobUid));
      check('Alice still in playerIds', playerIds.contains(aliceUid));
      check('Status still open', data['status'] == 'open');
    }
  } finally {
    await cleanupDoubles(
        proposalId, [aliceUid, bobUid], [aliceEmail, bobEmail]);
  }
}

// ─── Scenario 3: Player Leaves After Confirmed ────────

Future<void> testPlayerLeaves() async {
  String? proposalId;
  List<String> uids = [];
  List<String> emails = [];

  try {
    print('  Creating filled doubles lobby...');
    final lobby = await createFilledDoublesLobby('leaves');
    proposalId = lobby.proposalId;
    uids = lobby.uids;
    emails = lobby.emails;

    // Verify lobby is full
    final fullDoc = await fsGet('proposals/$proposalId');
    if (fullDoc != null) {
      final data = decodeDoc(fullDoc);
      check('Lobby full (openSlots=0)', data['openSlots'] == 0);
    }

    // Charlie (team 1) leaves
    print('  Charlie leaves...');
    await signIn(emails[2], _password); // charlie
    await leaveDoublesProposal(proposalId, uids[2]);

    // Verify
    print('  Verifying...');
    final doc = await fsGet('proposals/$proposalId');
    check('Proposal exists', doc != null);
    if (doc != null) {
      final data = decodeDoc(doc);
      final players = (data['doublesPlayers'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      check('3 players remain', players.length == 3);
      check('Charlie removed',
          !players.any((p) => p['userId'] == uids[2]));
      check('OpenSlots incremented to 1', data['openSlots'] == 1);
      final playerIds = data['playerIds'] as List<dynamic>;
      check('Charlie removed from playerIds',
          !playerIds.contains(uids[2]));
      check('Alice still in playerIds', playerIds.contains(uids[0]));
      check('Bob still in playerIds', playerIds.contains(uids[1]));
      check('Diana still in playerIds', playerIds.contains(uids[3]));
    }
  } finally {
    await cleanupDoubles(proposalId, uids, emails);
  }
}

// ─── Scenario 4: Partner Invite Flow ──────────────────

Future<void> testPartnerInvite() async {
  final aliceEmail = _uniqueEmail('invite.alice');
  final bobEmail = _uniqueEmail('invite.bob');
  final charlieEmail = _uniqueEmail('invite.charlie');
  final dianaEmail = _uniqueEmail('invite.diana');
  String? aliceUid;
  String? bobUid;
  String? charlieUid;
  String? dianaUid;
  String? proposalId;

  try {
    print('  Creating users...');
    aliceUid = await createTestUser(
        email: aliceEmail, password: _password, displayName: 'Alice Invite');
    bobUid = await createTestUser(
        email: bobEmail, password: _password, displayName: 'Bob Invite');
    charlieUid = await createTestUser(
        email: charlieEmail,
        password: _password,
        displayName: 'Charlie Invite');
    dianaUid = await createTestUser(
        email: dianaEmail, password: _password, displayName: 'Diana Invite');

    // Alice creates proposal
    print('  Alice creates doubles proposal...');
    await signIn(aliceEmail, _password);
    proposalId = await createDoublesProposal(
        creatorId: aliceUid, creatorName: 'Alice Invite');

    // Alice invites Bob as partner on team 1
    print('  Alice invites Bob (team 1 partner)...');
    await invitePartner(
        proposalId, bobUid, 'Bob Invite', 'Alice Invite', 1);

    // Verify Bob is invited
    final afterInvite = await fsGet('proposals/$proposalId');
    if (afterInvite != null) {
      final data = decodeDoc(afterInvite);
      final players = (data['doublesPlayers'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      final bob = players.firstWhere((p) => p['userId'] == bobUid);
      check('Bob status is invited', bob['status'] == 'invited');
      check('Bob assigned team 1', bob['team'] == 1);
      check('Bob invitedBy is Alice', bob['invitedBy'] == 'Alice Invite');
    }

    // Bob confirms invite
    print('  Bob confirms invite...');
    await signIn(bobEmail, _password);
    await confirmPartnerInvite(proposalId, bobUid);

    // Verify Bob is now confirmed
    final afterConfirm = await fsGet('proposals/$proposalId');
    if (afterConfirm != null) {
      final data = decodeDoc(afterConfirm);
      final players = (data['doublesPlayers'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      final bob = players.firstWhere((p) => p['userId'] == bobUid);
      check('Bob status is confirmed after invite', bob['status'] == 'confirmed');
      check('Bob still on team 1', bob['team'] == 1);
      check('OpenSlots = 2', data['openSlots'] == 2);
    }

    // Charlie and Diana join via request path
    print('  Charlie and Diana request to join...');
    await signIn(charlieEmail, _password);
    await requestJoinDoubles(proposalId, charlieUid, 'Charlie Invite');
    await signIn(dianaEmail, _password);
    await requestJoinDoubles(proposalId, dianaUid, 'Diana Invite');

    await signIn(aliceEmail, _password);
    await approveDoublesPlayer(proposalId, charlieUid, 2);
    await approveDoublesPlayer(proposalId, dianaUid, 2);

    // Verify full lobby with correct teams
    final fullDoc = await fsGet('proposals/$proposalId');
    if (fullDoc != null) {
      final data = decodeDoc(fullDoc);
      check('OpenSlots = 0 (full)', data['openSlots'] == 0);
      final players = (data['doublesPlayers'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      final team1 = players.where((p) => p['team'] == 1).toList();
      final team2 = players.where((p) => p['team'] == 2).toList();
      check('Team 1 = Alice + Bob (invite path)',
          team1.length == 2);
      check('Team 2 = Charlie + Diana (request path)',
          team2.length == 2);
    }

    // Score and confirm
    print('  Submitting scores (Team 1 wins 2-0)...');
    await signIn(aliceEmail, _password);
    await submitScores(proposalId, [
      {'creatorScore': 11, 'opponentScore': 5},
      {'creatorScore': 11, 'opponentScore': 8},
    ]);

    print('  Confirming scores...');
    await confirmScores(proposalId, aliceUid);
    await signIn(charlieEmail, _password);
    await confirmScores(proposalId, charlieUid);

    // Wait for standings
    print('  Waiting for standings...');
    const standingsPath =
        'doubles_standings/east_triangle_Intermediate/players';
    final found = await waitForStandings(standingsPath, aliceUid);

    if (found) {
      final aliceStanding = await fsGet('$standingsPath/$aliceUid');
      if (aliceStanding != null) {
        final d = decodeDoc(aliceStanding);
        check('Alice (invite path) matchesWon = 1', d['matchesWon'] == 1);
      } else {
        check('Alice standing exists', false);
      }

      final bobStanding = await fsGet('$standingsPath/$bobUid');
      if (bobStanding != null) {
        final d = decodeDoc(bobStanding);
        check('Bob (invited partner) matchesWon = 1', d['matchesWon'] == 1);
      } else {
        check('Bob standing exists', false);
      }
    }
  } finally {
    await cleanupDoubles(proposalId, [aliceUid, bobUid, charlieUid, dianaUid],
        [aliceEmail, bobEmail, charlieEmail, dianaEmail]);
  }
}

// ─── Scenario 5: Doubles Score Rejection ──────────────

Future<void> testScoreRejection() async {
  String? proposalId;
  List<String> uids = [];
  List<String> emails = [];

  try {
    print('  Creating filled doubles lobby...');
    final lobby = await createFilledDoublesLobby('scorerej');
    proposalId = lobby.proposalId;
    uids = lobby.uids;
    emails = lobby.emails;

    // Submit wrong scores
    print('  Submitting initial scores (wrong)...');
    await signIn(emails[0], _password);
    await submitScores(proposalId, [
      {'creatorScore': 11, 'opponentScore': 3},
      {'creatorScore': 11, 'opponentScore': 2},
    ]);
    await Future.delayed(const Duration(seconds: 2));

    // Reject scores (clearScores)
    print('  Rejecting scores...');
    await signIn(emails[1], _password);
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
      check('ScoreConfirmedBy reset to empty', confirmedBy.isEmpty);
      check('Status back to accepted', data['status'] == 'accepted');
    }

    // Re-record correct scores
    print('  Re-recording correct scores (Team 1 wins 2-0)...');
    await signIn(emails[0], _password);
    await submitScores(proposalId, [
      {'creatorScore': 11, 'opponentScore': 7},
      {'creatorScore': 11, 'opponentScore': 9},
    ]);
    await Future.delayed(const Duration(seconds: 1));

    // Both confirm
    print('  Confirming scores...');
    await confirmScores(proposalId, uids[0]);
    await signIn(emails[1], _password);
    await confirmScores(proposalId, uids[1]);

    // Wait for standings
    print('  Waiting for standings...');
    const standingsPath =
        'doubles_standings/east_triangle_Intermediate/players';
    final found = await waitForStandings(standingsPath, uids[0]);

    // Verify only 1 match counted
    if (found) {
      print('  Verifying standings reflect only final scores...');
      final aliceStanding = await fsGet('$standingsPath/${uids[0]}');
      if (aliceStanding != null) {
        final d = decodeDoc(aliceStanding);
        check('Alice matchesPlayed = 1 (not 2)', d['matchesPlayed'] == 1);
        check('Alice matchesWon = 1', d['matchesWon'] == 1);
      } else {
        check('Alice standing exists', false);
      }
    }
  } finally {
    await cleanupDoubles(proposalId, uids, emails);
  }
}

// ─── Scenario 6: Team 2 Wins ─────────────────────────

Future<void> testTeam2Wins() async {
  String? proposalId;
  List<String> uids = [];
  List<String> emails = [];

  try {
    print('  Creating filled doubles lobby...');
    final lobby = await createFilledDoublesLobby('t2wins');
    proposalId = lobby.proposalId;
    uids = lobby.uids;
    emails = lobby.emails;

    // Team 2 wins 2-1
    // creatorScore = Team 1, opponentScore = Team 2
    print('  Submitting scores (Team 2 wins 2-1)...');
    await signIn(emails[0], _password);
    await submitScores(proposalId, [
      {'creatorScore': 7, 'opponentScore': 11}, // Team 2 wins
      {'creatorScore': 11, 'opponentScore': 5}, // Team 1 wins
      {'creatorScore': 8, 'opponentScore': 11}, // Team 2 wins
    ]);
    await Future.delayed(const Duration(seconds: 1));

    // Both confirm
    print('  Confirming scores...');
    await confirmScores(proposalId, uids[0]);
    await signIn(emails[1], _password);
    await confirmScores(proposalId, uids[1]);

    // Wait for standings
    print('  Waiting for standings...');
    const standingsPath =
        'doubles_standings/east_triangle_Intermediate/players';
    final found = await waitForStandings(standingsPath, uids[1]);

    if (found) {
      print('  Verifying Team 2 won, Team 1 lost...');

      // Alice (Team 1 — lost)
      final aliceStanding = await fsGet('$standingsPath/${uids[0]}');
      if (aliceStanding != null) {
        final d = decodeDoc(aliceStanding);
        check('Alice matchesPlayed = 1', d['matchesPlayed'] == 1);
        check('Alice matchesWon = 0 (lost)', d['matchesWon'] == 0);
        check('Alice matchesLost = 1', d['matchesLost'] == 1);
      } else {
        check('Alice standing exists', false);
      }

      // Charlie (Team 1 — lost)
      final charlieStanding = await fsGet('$standingsPath/${uids[2]}');
      if (charlieStanding != null) {
        final d = decodeDoc(charlieStanding);
        check('Charlie matchesWon = 0 (lost)', d['matchesWon'] == 0);
        check('Charlie matchesLost = 1', d['matchesLost'] == 1);
      } else {
        check('Charlie standing exists', false);
      }

      // Bob (Team 2 — won)
      final bobStanding = await fsGet('$standingsPath/${uids[1]}');
      if (bobStanding != null) {
        final d = decodeDoc(bobStanding);
        check('Bob matchesPlayed = 1', d['matchesPlayed'] == 1);
        check('Bob matchesWon = 1 (won)', d['matchesWon'] == 1);
        check('Bob matchesLost = 0', d['matchesLost'] == 0);
      } else {
        check('Bob standing exists', false);
      }

      // Diana (Team 2 — won)
      final dianaStanding = await fsGet('$standingsPath/${uids[3]}');
      if (dianaStanding != null) {
        final d = decodeDoc(dianaStanding);
        check('Diana matchesWon = 1 (won)', d['matchesWon'] == 1);
        check('Diana matchesLost = 0', d['matchesLost'] == 0);
      } else {
        check('Diana standing exists', false);
      }
    }
  } finally {
    await cleanupDoubles(proposalId, uids, emails);
  }
}

// ─── Main ─────────────────────────────────────────────

Future<void> main(List<String> args) async {
  _cleanup = parseCleanupFlag(args);
  final results = <String, bool>{};

  print('==========================================');
  print('  DOUBLES EDGE CASE TESTS');
  print('==========================================');

  results['Cancel Doubles Proposal'] =
      await runScenario('Cancel Doubles Proposal', testCancelDoubles);
  results['Decline Join Request'] =
      await runScenario('Decline Join Request', testDeclineRequest);
  results['Player Leaves After Confirmed'] =
      await runScenario('Player Leaves After Confirmed', testPlayerLeaves);
  results['Partner Invite Flow'] =
      await runScenario('Partner Invite Flow', testPartnerInvite);
  results['Doubles Score Rejection'] =
      await runScenario('Doubles Score Rejection', testScoreRejection);
  results['Team 2 Wins'] =
      await runScenario('Team 2 Wins', testTeam2Wins);

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
