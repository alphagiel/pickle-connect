/// Shared test helpers for Firebase Emulator integration tests.
///
/// Provides HTTP, Auth, and Firestore REST API helpers used across test scripts.

import 'dart:convert';
import 'dart:io';

const projectId = 'myapp1-c6012';
const authHost = 'http://localhost:9099';
const firestoreHost = 'http://localhost:8080';

// Firestore REST base
String get fsBase =>
    '$firestoreHost/v1/projects/$projectId/databases/(default)/documents';

// Current auth token for Firestore requests
String? authToken;

// ─── CLI flags ───────────────────────────────────────

/// Parse `--no-cleanup` flag from command-line args.
/// Returns true if cleanup should run (default), false if `--no-cleanup` passed.
bool parseCleanupFlag(List<String> args) {
  return !args.contains('--no-cleanup');
}

// ─── Test results tracking ───────────────────────────

int testPassed = 0;
int testFailed = 0;
final List<String> testFailures = [];

void resetTestResults() {
  testPassed = 0;
  testFailed = 0;
  testFailures.clear();
}

void check(String label, bool condition) {
  if (condition) {
    testPassed++;
    print('  [PASS] $label');
  } else {
    testFailed++;
    testFailures.add(label);
    print('  [FAIL] $label');
  }
}

// ─── HTTP helpers ─────────────────────────────────────

final httpClient = HttpClient();

Future<Map<String, dynamic>> request(
  String method,
  String url, {
  Map<String, dynamic>? body,
}) async {
  final uri = Uri.parse(url);
  late HttpClientRequest req;
  switch (method) {
    case 'GET':
      req = await httpClient.getUrl(uri);
      break;
    case 'POST':
      req = await httpClient.postUrl(uri);
      break;
    case 'PATCH':
      req = await httpClient.patchUrl(uri);
      break;
    case 'DELETE':
      req = await httpClient.deleteUrl(uri);
      break;
    default:
      throw ArgumentError('Unsupported method: $method');
  }
  req.headers.contentType = ContentType.json;
  if (authToken != null) {
    req.headers.set('Authorization', 'Bearer $authToken');
  }
  if (body != null) {
    req.write(jsonEncode(body));
  }
  final resp = await req.close();
  final respBody = await resp.transform(utf8.decoder).join();
  if (resp.statusCode >= 400) {
    throw HttpException(
      '$method $url → ${resp.statusCode}: $respBody',
    );
  }
  if (respBody.isEmpty) return {};
  return jsonDecode(respBody) as Map<String, dynamic>;
}

// ─── Auth Emulator helpers ────────────────────────────

/// Creates a user in the Auth emulator and sets authToken.
Future<Map<String, dynamic>> createAuthUser(
    String email, String password, String displayName) async {
  authToken = null;
  final signUp = await request(
    'POST',
    '$authHost/identitytoolkit.googleapis.com/v1/accounts:signUp?key=fake-api-key',
    body: {
      'email': email,
      'password': password,
      'displayName': displayName,
      'returnSecureToken': true,
    },
  );
  authToken = signUp['idToken'] as String?;
  return signUp;
}

/// Sign in as an existing user and set authToken.
Future<void> signIn(String email, String password) async {
  authToken = null;
  final resp = await request(
    'POST',
    '$authHost/identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=fake-api-key',
    body: {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    },
  );
  authToken = resp['idToken'] as String?;
}

// ─── Firestore REST helpers ───────────────────────────

/// Encode a Dart value into a Firestore REST "Value" object.
Map<String, dynamic> fsValue(dynamic v) {
  if (v == null) return {'nullValue': null};
  if (v is String) return {'stringValue': v};
  if (v is int) return {'integerValue': '$v'};
  if (v is double) return {'doubleValue': v};
  if (v is bool) return {'booleanValue': v};
  if (v is DateTime) return {'timestampValue': v.toUtc().toIso8601String()};
  if (v is List) {
    if (v.isEmpty) {
      return {
        'arrayValue': <String, dynamic>{}
      };
    }
    return {
      'arrayValue': {
        'values': v.map((e) => fsValue(e)).toList(),
      }
    };
  }
  if (v is Map) {
    return {
      'mapValue': {
        'fields': v.map((k, val) => MapEntry(k as String, fsValue(val))),
      }
    };
  }
  return {'stringValue': v.toString()};
}

/// Decode a Firestore REST "Value" object into a Dart value.
dynamic fsDecodeValue(Map<String, dynamic> v) {
  if (v.containsKey('stringValue')) return v['stringValue'];
  if (v.containsKey('integerValue')) return int.parse(v['integerValue']);
  if (v.containsKey('doubleValue')) return (v['doubleValue'] as num).toDouble();
  if (v.containsKey('booleanValue')) return v['booleanValue'];
  if (v.containsKey('nullValue')) return null;
  if (v.containsKey('timestampValue')) return v['timestampValue'];
  if (v.containsKey('arrayValue')) {
    final arr = v['arrayValue']['values'] as List<dynamic>? ?? [];
    return arr
        .map((e) => fsDecodeValue(e as Map<String, dynamic>))
        .toList();
  }
  if (v.containsKey('mapValue')) {
    final fields =
        v['mapValue']['fields'] as Map<String, dynamic>? ?? {};
    return fields.map(
        (k, val) => MapEntry(k, fsDecodeValue(val as Map<String, dynamic>)));
  }
  return v.toString();
}

/// Decode a full Firestore document response into a flat map.
Map<String, dynamic> decodeDoc(Map<String, dynamic> doc) {
  final fields = doc['fields'] as Map<String, dynamic>? ?? {};
  return fields.map(
      (k, v) => MapEntry(k, fsDecodeValue(v as Map<String, dynamic>)));
}

/// Build Firestore fields map from a flat Dart map.
Map<String, dynamic> encodeFields(Map<String, dynamic> data) {
  return data.map((k, v) => MapEntry(k, fsValue(v)));
}

/// Create a document with auto-generated ID (POST to collection).
Future<Map<String, dynamic>> fsCreate(
    String collection, Map<String, dynamic> data) async {
  return await request('POST', '$fsBase/$collection', body: {
    'fields': encodeFields(data),
  });
}

/// Create or overwrite a document at a specific path (PATCH).
Future<Map<String, dynamic>> fsSet(
    String docPath, Map<String, dynamic> data) async {
  return await request('PATCH', '$fsBase/$docPath', body: {
    'fields': encodeFields(data),
  });
}

/// Update specific fields on an existing document using updateMask.
Future<Map<String, dynamic>> fsUpdate(
    String docPath, Map<String, dynamic> data) async {
  final mask = data.keys.map((k) => 'updateMask.fieldPaths=$k').join('&');
  return await request('PATCH', '$fsBase/$docPath?$mask', body: {
    'fields': encodeFields(data),
  });
}

/// Update fields and optionally delete other fields.
/// [data] contains fields to set; [deleteFields] lists field paths to remove.
Future<Map<String, dynamic>> fsUpdateWithDeletes(
    String docPath,
    Map<String, dynamic> data,
    List<String> deleteFields,
) async {
  final allFields = [...data.keys, ...deleteFields];
  final mask = allFields.map((k) => 'updateMask.fieldPaths=$k').join('&');
  // Fields in deleteFields are in the mask but NOT in the body → Firestore deletes them
  return await request('PATCH', '$fsBase/$docPath?$mask', body: {
    'fields': encodeFields(data),
  });
}

/// Get a document. Returns null if not found.
Future<Map<String, dynamic>?> fsGet(String docPath) async {
  try {
    return await request('GET', '$fsBase/$docPath');
  } on HttpException catch (e) {
    if (e.message.contains('404') || e.message.contains('NOT_FOUND')) {
      return null;
    }
    rethrow;
  }
}

/// Delete a document.
Future<void> fsDelete(String docPath) async {
  try {
    await request('DELETE', '$fsBase/$docPath');
  } catch (_) {}
}

/// Commit a Firestore transaction with writes (used for arrayUnion).
Future<void> fsCommit(List<Map<String, dynamic>> writes) async {
  await request(
    'POST',
    '$firestoreHost/v1/projects/$projectId/databases/(default)/documents:commit',
    body: {'writes': writes},
  );
}

/// Extract the document ID from a Firestore REST response name field.
String docIdFromName(String name) => name.split('/').last;

// ─── Test user helpers ────────────────────────────────

/// Create a test user (Auth + Firestore user doc). Returns uid.
Future<String> createTestUser({
  required String email,
  required String password,
  required String displayName,
  String skillLevel = '3.5',
  String skillBracket = 'Intermediate',
  String zone = 'east_triangle',
  String location = 'Court A',
}) async {
  final auth = await createAuthUser(email, password, displayName);
  final uid = auth['localId'] as String;
  await fsSet('users/$uid', {
    'userId': uid,
    'email': email,
    'displayName': displayName,
    'skillLevel': skillLevel,
    'skillBracket': skillBracket,
    'zone': zone,
    'location': location,
    'matchesPlayed': 0,
    'matchesWon': 0,
    'matchesLost': 0,
    'winRate': 0.0,
    'isActive': true,
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  });
  return uid;
}

/// Create a singles proposal. Returns proposal ID.
Future<String> createSinglesProposal({
  required String creatorId,
  required String creatorName,
  String skillLevel = '3.5',
  String skillBracket = 'Intermediate',
  String zone = 'east_triangle',
  String location = 'Court A',
}) async {
  final tomorrow = DateTime.now().add(const Duration(days: 1));
  final resp = await fsCreate('proposals', {
    'creatorId': creatorId,
    'creatorName': creatorName,
    'skillLevel': skillLevel,
    'skillBracket': skillBracket,
    'location': location,
    'dateTime': tomorrow,
    'status': 'open',
    'matchType': 'singles',
    'zone': zone,
    'scoreConfirmedBy': <String>[],
    'doublesPlayers': <Map<String, dynamic>>[],
    'playerIds': <String>[],
    'openSlots': 0,
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  });
  return docIdFromName(resp['name'] as String);
}

/// Accept a proposal.
Future<void> acceptProposal(
    String proposalId, String acceptorId, String acceptorName) async {
  await fsUpdate('proposals/$proposalId', {
    'status': 'accepted',
    'acceptedBy': {'userId': acceptorId, 'displayName': acceptorName},
    'updatedAt': DateTime.now(),
  });
}

/// Submit scores for a proposal.
Future<void> submitScores(
    String proposalId, List<Map<String, int>> games) async {
  await fsUpdate('proposals/$proposalId', {
    'scores': {'games': games},
    'status': 'completed',
    'updatedAt': DateTime.now(),
  });
}

/// Confirm scores for a user (arrayUnion on scoreConfirmedBy).
Future<void> confirmScores(String proposalId, String userId) async {
  final proposalDocPath =
      'projects/$projectId/databases/(default)/documents/proposals/$proposalId';
  await fsCommit([
    {
      'transform': {
        'document': proposalDocPath,
        'fieldTransforms': [
          {
            'fieldPath': 'scoreConfirmedBy',
            'appendMissingElements': {
              'values': [
                {'stringValue': userId}
              ]
            }
          }
        ]
      }
    }
  ]);
}

/// Cancel a proposal.
Future<void> cancelProposal(String proposalId) async {
  await fsUpdate('proposals/$proposalId', {
    'status': 'canceled',
    'updatedAt': DateTime.now(),
  });
}

/// Unaccept a proposal (set status back to open, set acceptedBy to null).
Future<void> unacceptProposal(String proposalId) async {
  await fsUpdate('proposals/$proposalId', {
    'status': 'open',
    'acceptedBy': null,
    'updatedAt': DateTime.now(),
  });
}

/// Clear scores (delete scores field, reset scoreConfirmedBy to []).
Future<void> clearScores(String proposalId) async {
  await fsUpdateWithDeletes(
    'proposals/$proposalId',
    {
      'scoreConfirmedBy': <String>[],
      'status': 'accepted',
      'updatedAt': DateTime.now(),
    },
    ['scores'],
  );
}

// ─── Doubles helpers ──────────────────────────────────

/// Create a doubles proposal. Returns proposal ID.
/// Creator is added as first doublesPlayer (confirmed, team 1).
Future<String> createDoublesProposal({
  required String creatorId,
  required String creatorName,
  String skillLevel = '3.5',
  String skillBracket = 'Intermediate',
  String zone = 'east_triangle',
  String location = 'Court A',
}) async {
  final tomorrow = DateTime.now().add(const Duration(days: 1));
  final resp = await fsCreate('proposals', {
    'creatorId': creatorId,
    'creatorName': creatorName,
    'skillLevel': skillLevel,
    'skillBracket': skillBracket,
    'location': location,
    'dateTime': tomorrow,
    'status': 'open',
    'matchType': 'doubles',
    'zone': zone,
    'openSlots': 3,
    'doublesPlayers': [
      {
        'userId': creatorId,
        'displayName': creatorName,
        'status': 'confirmed',
        'team': 1,
      }
    ],
    'playerIds': [creatorId],
    'scoreConfirmedBy': <String>[],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  });
  return docIdFromName(resp['name'] as String);
}

/// Read doublesPlayers array from a proposal doc.
Future<List<Map<String, dynamic>>> _getDoublesPlayers(
    String proposalId) async {
  final doc = await fsGet('proposals/$proposalId');
  if (doc == null) throw StateError('Proposal $proposalId not found');
  final data = decodeDoc(doc);
  final players = data['doublesPlayers'] as List<dynamic>? ?? [];
  return players.cast<Map<String, dynamic>>();
}

/// Add a player to the lobby with status=requested.
Future<void> requestJoinDoubles(
    String proposalId, String userId, String displayName) async {
  final players = await _getDoublesPlayers(proposalId);
  players.add({
    'userId': userId,
    'displayName': displayName,
    'status': 'requested',
  });
  await fsUpdate('proposals/$proposalId', {
    'doublesPlayers': players,
    'playerIds': [...players.map((p) => p['userId'] as String)],
    'updatedAt': DateTime.now(),
  });
}

/// Approve a requested player → confirmed + assign team.
Future<void> approveDoublesPlayer(
    String proposalId, String userId, int team) async {
  final players = await _getDoublesPlayers(proposalId);
  final idx = players.indexWhere((p) => p['userId'] == userId);
  if (idx == -1) throw StateError('Player $userId not in doublesPlayers');
  players[idx] = {
    ...players[idx],
    'status': 'confirmed',
    'team': team,
  };
  // Count confirmed to calculate openSlots
  final confirmed = players.where((p) => p['status'] == 'confirmed').length;
  await fsUpdate('proposals/$proposalId', {
    'doublesPlayers': players,
    'openSlots': 4 - confirmed,
    'updatedAt': DateTime.now(),
  });
}

/// Decline a requested player (remove from lobby).
Future<void> declineDoublesPlayer(String proposalId, String userId) async {
  final players = await _getDoublesPlayers(proposalId);
  players.removeWhere((p) => p['userId'] == userId);
  await fsUpdate('proposals/$proposalId', {
    'doublesPlayers': players,
    'playerIds': [...players.map((p) => p['userId'] as String)],
    'updatedAt': DateTime.now(),
  });
}

/// Confirmed player leaves the match.
Future<void> leaveDoublesProposal(String proposalId, String userId) async {
  final players = await _getDoublesPlayers(proposalId);
  players.removeWhere((p) => p['userId'] == userId);
  final confirmed = players.where((p) => p['status'] == 'confirmed').length;
  await fsUpdate('proposals/$proposalId', {
    'doublesPlayers': players,
    'playerIds': [...players.map((p) => p['userId'] as String)],
    'openSlots': 4 - confirmed,
    'updatedAt': DateTime.now(),
  });
}

/// Invite a partner (add with status=invited, team assignment).
Future<void> invitePartner(String proposalId, String userId,
    String displayName, String invitedBy, int team) async {
  final players = await _getDoublesPlayers(proposalId);
  players.add({
    'userId': userId,
    'displayName': displayName,
    'status': 'invited',
    'team': team,
    'invitedBy': invitedBy,
  });
  await fsUpdate('proposals/$proposalId', {
    'doublesPlayers': players,
    'playerIds': [...players.map((p) => p['userId'] as String)],
    'updatedAt': DateTime.now(),
  });
}

/// Partner confirms invite (status: invited → confirmed).
Future<void> confirmPartnerInvite(String proposalId, String userId) async {
  final players = await _getDoublesPlayers(proposalId);
  final idx = players.indexWhere((p) => p['userId'] == userId);
  if (idx == -1) throw StateError('Player $userId not in doublesPlayers');
  players[idx] = {
    ...players[idx],
    'status': 'confirmed',
  };
  final confirmed = players.where((p) => p['status'] == 'confirmed').length;
  await fsUpdate('proposals/$proposalId', {
    'doublesPlayers': players,
    'openSlots': 4 - confirmed,
    'updatedAt': DateTime.now(),
  });
}

/// Wait for standings doc to appear. Returns true if found.
Future<bool> waitForStandings(String standingsPath, String userId,
    {int maxAttempts = 6, int delaySeconds = 3}) async {
  for (var attempt = 1; attempt <= maxAttempts; attempt++) {
    await Future.delayed(Duration(seconds: delaySeconds));
    print('  Checking standings (attempt $attempt/$maxAttempts)...');
    final doc = await fsGet('$standingsPath/$userId');
    if (doc != null) {
      print('  Standings found!');
      return true;
    }
  }
  print('  WARNING: Standings not found after ${maxAttempts * delaySeconds}s');
  return false;
}
