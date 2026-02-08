import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { getEmailService } from "../services/email";
import {
  proposalAcceptedEmail,
  proposalAcceptedEmailSubject,
  proposalUnacceptedEmail,
  proposalUnacceptedEmailSubject,
  proposalUnacceptedConfirmationEmail,
  proposalUnacceptedConfirmationEmailSubject,
  proposalCancelledEmail,
  proposalCancelledEmailSubject,
  proposalDeletedConfirmationEmail,
  proposalDeletedConfirmationEmailSubject,
  matchResultEmail,
  matchResultEmailSubject,
  doublesMatchResultEmail,
  doublesMatchResultEmailSubject,
} from "../templates";
import { getProposalUrl, getPreferencesUrl, formatDateTime } from "../config";

interface GameScore {
  creatorScore: number;
  opponentScore: number;
}

interface Scores {
  games: GameScore[];
}

interface DoublesPlayer {
  userId: string;
  displayName: string;
  team?: number;
  status: string;
  invitedBy?: string;
}

/**
 * Firestore trigger: Handle proposal updates
 * - Status changed to 'accepted' → Notify creator
 * - Status changed back to 'open' (unaccepted) → Notify creator
 * - Scores added → Notify both players
 */
export const onProposalUpdated = functions.firestore
  .document("proposals/{proposalId}")
  .onUpdate(async (change, context) => {
    const proposalId = context.params.proposalId;
    const beforeData = change.before.data();
    const afterData = change.after.data();

    console.log(`[onProposalUpdated] Proposal updated: ${proposalId}`);

    const db = admin.firestore();
    const emailService = getEmailService(process.env.SENDGRID_API_KEY);

    // Check for status changes
    const statusChanged = beforeData.status !== afterData.status;
    const scoresAdded = !beforeData.scores && afterData.scores;
    const isDoubles = afterData.matchType === "doubles";

    // Handle proposal accepted (singles only - doubles uses different flow)
    if (statusChanged && afterData.status === "accepted" && afterData.acceptedBy && !isDoubles) {
      await handleProposalAccepted(
        db,
        emailService,
        proposalId,
        afterData
      );
    }

    // Handle proposal unaccepted (status changed back to open)
    if (
      statusChanged &&
      beforeData.status === "accepted" &&
      afterData.status === "open" &&
      beforeData.acceptedBy
    ) {
      await handleProposalUnaccepted(
        db,
        emailService,
        proposalId,
        afterData,
        beforeData.acceptedBy
      );
    }

    // Handle proposal cancelled/deleted (status changed to cancelled)
    if (statusChanged && afterData.status === "cancelled") {
      await handleProposalCancelled(
        db,
        emailService,
        proposalId,
        afterData,
        beforeData.acceptedBy || null
      );
    }

    // Handle scores added
    if (scoresAdded) {
      if (isDoubles) {
        await handleDoublesMatchResultRecorded(
          db,
          emailService,
          proposalId,
          afterData
        );
      } else {
        await handleMatchResultRecorded(
          db,
          emailService,
          proposalId,
          afterData
        );
      }
    }
  });

async function handleProposalAccepted(
  db: admin.firestore.Firestore,
  emailService: ReturnType<typeof getEmailService>,
  proposalId: string,
  proposalData: admin.firestore.DocumentData
): Promise<void> {
  console.log(`[onProposalUpdated] Proposal ${proposalId} was accepted`);

  // Get the creator's user document
  const creatorDoc = await db.collection("users").doc(proposalData.creatorId).get();
  if (!creatorDoc.exists) {
    console.log(`[onProposalUpdated] Creator ${proposalData.creatorId} not found`);
    return;
  }

  const creatorData = creatorDoc.data()!;

  // Check email preferences
  const emailPrefs = creatorData.emailNotifications;
  if (emailPrefs && emailPrefs.proposalAccepted === false) {
    console.log(`[onProposalUpdated] Creator has proposal accepted emails disabled`);
    return;
  }

  if (!creatorData.email) {
    console.log(`[onProposalUpdated] Creator has no email`);
    return;
  }

  const proposalDateTime = proposalData.dateTime?.toDate
    ? proposalData.dateTime.toDate()
    : new Date(proposalData.dateTime);

  const html = proposalAcceptedEmail({
    creatorName: creatorData.displayName || "Pickleballer",
    acceptedByName: proposalData.acceptedBy.displayName,
    skillLevel: proposalData.skillLevel,
    location: proposalData.location,
    dateTime: formatDateTime(proposalDateTime),
    proposalUrl: getProposalUrl(proposalId),
    preferencesUrl: getPreferencesUrl(proposalData.creatorId),
  });

  const result = await emailService.send({
    to: creatorData.email,
    subject: proposalAcceptedEmailSubject(proposalData.acceptedBy.displayName),
    html,
  });

  if (result.success) {
    console.log(`[onProposalUpdated] Proposal accepted email sent to ${creatorData.email}`);
  } else {
    console.error(`[onProposalUpdated] Failed to send proposal accepted email: ${result.error}`);
  }
}

async function handleProposalUnaccepted(
  db: admin.firestore.Firestore,
  emailService: ReturnType<typeof getEmailService>,
  proposalId: string,
  proposalData: admin.firestore.DocumentData,
  previousAcceptedBy: { userId: string; displayName: string }
): Promise<void> {
  console.log(`[onProposalUpdated] Proposal ${proposalId} was unaccepted`);

  const proposalDateTime = proposalData.dateTime?.toDate
    ? proposalData.dateTime.toDate()
    : new Date(proposalData.dateTime);

  // Get both user documents
  const creatorDoc = await db.collection("users").doc(proposalData.creatorId).get();
  const accepterDoc = await db.collection("users").doc(previousAcceptedBy.userId).get();

  // Send email to creator
  if (creatorDoc.exists) {
    const creatorData = creatorDoc.data()!;
    const emailPrefs = creatorData.emailNotifications;

    if (creatorData.email && (!emailPrefs || emailPrefs.proposalUnaccepted !== false)) {
      const html = proposalUnacceptedEmail({
        creatorName: creatorData.displayName || "Pickleballer",
        unacceptedByName: previousAcceptedBy.displayName,
        skillLevel: proposalData.skillLevel,
        location: proposalData.location,
        dateTime: formatDateTime(proposalDateTime),
        proposalUrl: getProposalUrl(proposalId),
        preferencesUrl: getPreferencesUrl(proposalData.creatorId),
      });

      const result = await emailService.send({
        to: creatorData.email,
        subject: proposalUnacceptedEmailSubject(),
        html,
      });

      if (result.success) {
        console.log(`[onProposalUpdated] Proposal unaccepted email sent to creator ${creatorData.email}`);
      } else {
        console.error(`[onProposalUpdated] Failed to send proposal unaccepted email to creator: ${result.error}`);
      }
    } else {
      console.log(`[onProposalUpdated] Creator has proposal unaccepted emails disabled or no email`);
    }
  } else {
    console.log(`[onProposalUpdated] Creator ${proposalData.creatorId} not found`);
  }

  // Send confirmation email to the person who unaccepted
  if (accepterDoc.exists) {
    const accepterData = accepterDoc.data()!;
    const emailPrefs = accepterData.emailNotifications;

    if (accepterData.email && (!emailPrefs || emailPrefs.proposalUnaccepted !== false)) {
      const html = proposalUnacceptedConfirmationEmail({
        recipientName: accepterData.displayName || "Pickleballer",
        creatorName: proposalData.creatorName,
        skillLevel: proposalData.skillLevel,
        location: proposalData.location,
        dateTime: formatDateTime(proposalDateTime),
        preferencesUrl: getPreferencesUrl(previousAcceptedBy.userId),
      });

      const result = await emailService.send({
        to: accepterData.email,
        subject: proposalUnacceptedConfirmationEmailSubject(proposalData.creatorName),
        html,
      });

      if (result.success) {
        console.log(`[onProposalUpdated] Proposal unaccepted confirmation email sent to ${accepterData.email}`);
      } else {
        console.error(`[onProposalUpdated] Failed to send proposal unaccepted confirmation email: ${result.error}`);
      }
    } else {
      console.log(`[onProposalUpdated] Accepter has proposal unaccepted emails disabled or no email`);
    }
  } else {
    console.log(`[onProposalUpdated] Accepter ${previousAcceptedBy.userId} not found`);
  }
}

async function handleProposalCancelled(
  db: admin.firestore.Firestore,
  emailService: ReturnType<typeof getEmailService>,
  proposalId: string,
  proposalData: admin.firestore.DocumentData,
  acceptedBy: { userId: string; displayName: string } | null
): Promise<void> {
  console.log(`[onProposalUpdated] Proposal ${proposalId} was cancelled/deleted`);

  const proposalDateTime = proposalData.dateTime?.toDate
    ? proposalData.dateTime.toDate()
    : new Date(proposalData.dateTime);

  // Send confirmation email to the creator (who deleted the proposal)
  const creatorDoc = await db.collection("users").doc(proposalData.creatorId).get();
  if (creatorDoc.exists) {
    const creatorData = creatorDoc.data()!;
    const emailPrefs = creatorData.emailNotifications;

    if (creatorData.email && (!emailPrefs || emailPrefs.proposalCancelled !== false)) {
      const html = proposalDeletedConfirmationEmail({
        recipientName: creatorData.displayName || "Pickleballer",
        skillLevel: proposalData.skillLevel,
        location: proposalData.location,
        dateTime: formatDateTime(proposalDateTime),
        preferencesUrl: getPreferencesUrl(proposalData.creatorId),
      });

      const result = await emailService.send({
        to: creatorData.email,
        subject: proposalDeletedConfirmationEmailSubject(),
        html,
      });

      if (result.success) {
        console.log(`[onProposalUpdated] Proposal deleted confirmation email sent to creator ${creatorData.email}`);
      } else {
        console.error(`[onProposalUpdated] Failed to send proposal deleted confirmation email: ${result.error}`);
      }
    } else {
      console.log(`[onProposalUpdated] Creator has proposal cancelled emails disabled or no email`);
    }
  } else {
    console.log(`[onProposalUpdated] Creator ${proposalData.creatorId} not found`);
  }

  // If there was an accepter, notify them that the match was cancelled
  if (acceptedBy) {
    const accepterDoc = await db.collection("users").doc(acceptedBy.userId).get();
    if (accepterDoc.exists) {
      const accepterData = accepterDoc.data()!;
      const emailPrefs = accepterData.emailNotifications;

      if (accepterData.email && (!emailPrefs || emailPrefs.proposalCancelled !== false)) {
        const html = proposalCancelledEmail({
          recipientName: accepterData.displayName || "Pickleballer",
          creatorName: proposalData.creatorName,
          skillLevel: proposalData.skillLevel,
          location: proposalData.location,
          dateTime: formatDateTime(proposalDateTime),
          preferencesUrl: getPreferencesUrl(acceptedBy.userId),
        });

        const result = await emailService.send({
          to: accepterData.email,
          subject: proposalCancelledEmailSubject(proposalData.creatorName),
          html,
        });

        if (result.success) {
          console.log(`[onProposalUpdated] Proposal cancelled email sent to accepter ${accepterData.email}`);
        } else {
          console.error(`[onProposalUpdated] Failed to send proposal cancelled email: ${result.error}`);
        }
      } else {
        console.log(`[onProposalUpdated] Accepter has proposal cancelled emails disabled or no email`);
      }
    } else {
      console.log(`[onProposalUpdated] Accepter ${acceptedBy.userId} not found`);
    }
  }
}

async function handleMatchResultRecorded(
  db: admin.firestore.Firestore,
  emailService: ReturnType<typeof getEmailService>,
  proposalId: string,
  proposalData: admin.firestore.DocumentData
): Promise<void> {
  console.log(`[onProposalUpdated] Match result recorded for proposal ${proposalId}`);

  const scores: Scores = proposalData.scores;
  if (!scores || !scores.games || scores.games.length === 0) {
    console.log(`[onProposalUpdated] No valid scores found`);
    return;
  }

  // Calculate who won
  const creatorGamesWon = scores.games.filter(
    (g: GameScore) => g.creatorScore > g.opponentScore
  ).length;
  const opponentGamesWon = scores.games.filter(
    (g: GameScore) => g.opponentScore > g.creatorScore
  ).length;
  const creatorWon = creatorGamesWon > opponentGamesWon;

  const matchScore = `${creatorGamesWon}-${opponentGamesWon}`;
  const gameScores = scores.games.map(
    (g: GameScore) => `${g.creatorScore}-${g.opponentScore}`
  );

  const proposalDateTime = proposalData.dateTime?.toDate
    ? proposalData.dateTime.toDate()
    : new Date(proposalData.dateTime);

  // Get both users
  const creatorDoc = await db.collection("users").doc(proposalData.creatorId).get();
  const opponentDoc = proposalData.acceptedBy
    ? await db.collection("users").doc(proposalData.acceptedBy.userId).get()
    : null;

  // Send email to creator
  if (creatorDoc.exists) {
    const creatorData = creatorDoc.data()!;
    const emailPrefs = creatorData.emailNotifications;

    if (creatorData.email && (!emailPrefs || emailPrefs.matchResults !== false)) {
      const opponentName = proposalData.acceptedBy?.displayName || "Opponent";
      const html = matchResultEmail({
        recipientName: creatorData.displayName || "Pickleballer",
        opponentName,
        matchScore: creatorWon ? matchScore : `${opponentGamesWon}-${creatorGamesWon}`,
        isWinner: creatorWon,
        gameScores,
        location: proposalData.location,
        dateTime: formatDateTime(proposalDateTime),
        proposalUrl: getProposalUrl(proposalId),
        preferencesUrl: getPreferencesUrl(proposalData.creatorId),
      });

      const result = await emailService.send({
        to: creatorData.email,
        subject: matchResultEmailSubject(creatorWon, opponentName),
        html,
      });

      if (result.success) {
        console.log(`[onProposalUpdated] Match result email sent to creator ${creatorData.email}`);
      }
    }
  }

  // Send email to opponent
  if (opponentDoc && opponentDoc.exists) {
    const opponentData = opponentDoc.data()!;
    const emailPrefs = opponentData.emailNotifications;

    if (opponentData.email && (!emailPrefs || emailPrefs.matchResults !== false)) {
      // Flip the scores for opponent's perspective
      const opponentWon = !creatorWon;
      const opponentGameScores = scores.games.map(
        (g: GameScore) => `${g.opponentScore}-${g.creatorScore}`
      );

      const html = matchResultEmail({
        recipientName: opponentData.displayName || "Pickleballer",
        opponentName: proposalData.creatorName,
        matchScore: opponentWon
          ? `${opponentGamesWon}-${creatorGamesWon}`
          : `${creatorGamesWon}-${opponentGamesWon}`,
        isWinner: opponentWon,
        gameScores: opponentGameScores,
        location: proposalData.location,
        dateTime: formatDateTime(proposalDateTime),
        proposalUrl: getProposalUrl(proposalId),
        preferencesUrl: getPreferencesUrl(proposalData.acceptedBy.userId),
      });

      const result = await emailService.send({
        to: opponentData.email,
        subject: matchResultEmailSubject(opponentWon, proposalData.creatorName),
        html,
      });

      if (result.success) {
        console.log(`[onProposalUpdated] Match result email sent to opponent ${opponentData.email}`);
      }
    }
  }

  // Update standings for both players
  const skillBracket = proposalData.skillBracket;
  if (!skillBracket) {
    console.log(`[onProposalUpdated] No skill bracket found, skipping standings update`);
    return;
  }

  const creatorId = proposalData.creatorId;
  const opponentId = proposalData.acceptedBy?.userId;

  if (!opponentId) {
    console.log(`[onProposalUpdated] No opponent found, skipping standings update`);
    return;
  }

  // Update creator's standing
  await updatePlayerStanding(
    db,
    "standings",
    skillBracket,
    creatorId,
    creatorDoc.exists ? creatorDoc.data()!.displayName : "Unknown",
    creatorDoc.exists ? creatorDoc.data()!.skillLevel : "3.5",
    creatorWon
  );

  // Update opponent's standing
  await updatePlayerStanding(
    db,
    "standings",
    skillBracket,
    opponentId,
    opponentDoc?.exists ? opponentDoc.data()!.displayName : proposalData.acceptedBy.displayName,
    opponentDoc?.exists ? opponentDoc.data()!.skillLevel : "3.5",
    !creatorWon
  );

  console.log(`[onProposalUpdated] Standings updated for both players`);
}

/**
 * Handle doubles match result: emails all 4 players and updates doubles_standings
 */
async function handleDoublesMatchResultRecorded(
  db: admin.firestore.Firestore,
  emailService: ReturnType<typeof getEmailService>,
  proposalId: string,
  proposalData: admin.firestore.DocumentData
): Promise<void> {
  console.log(`[onProposalUpdated] Doubles match result recorded for proposal ${proposalId}`);

  const scores: Scores = proposalData.scores;
  if (!scores || !scores.games || scores.games.length === 0) {
    console.log(`[onProposalUpdated] No valid scores found`);
    return;
  }

  const doublesPlayers: DoublesPlayer[] = proposalData.doublesPlayers || [];
  const confirmedPlayers = doublesPlayers.filter((p) => p.status === "confirmed");

  if (confirmedPlayers.length < 4) {
    console.log(`[onProposalUpdated] Doubles match does not have 4 confirmed players, skipping`);
    return;
  }

  // Determine teams
  const team1 = confirmedPlayers.filter((p) => p.team === 1);
  const team2 = confirmedPlayers.filter((p) => p.team === 2);

  if (team1.length !== 2 || team2.length !== 2) {
    console.log(`[onProposalUpdated] Invalid team configuration: team1=${team1.length}, team2=${team2.length}`);
    return;
  }

  // Calculate who won (creatorScore = Team 1, opponentScore = Team 2)
  const team1GamesWon = scores.games.filter(
    (g: GameScore) => g.creatorScore > g.opponentScore
  ).length;
  const team2GamesWon = scores.games.filter(
    (g: GameScore) => g.opponentScore > g.creatorScore
  ).length;
  const team1Won = team1GamesWon > team2GamesWon;

  const proposalDateTime = proposalData.dateTime?.toDate
    ? proposalData.dateTime.toDate()
    : new Date(proposalData.dateTime);

  // Fetch all 4 player documents
  const playerDocs = await Promise.all(
    confirmedPlayers.map((p) => db.collection("users").doc(p.userId).get())
  );

  // Send emails to all 4 players
  for (let i = 0; i < confirmedPlayers.length; i++) {
    const player = confirmedPlayers[i];
    const playerDoc = playerDocs[i];

    if (!playerDoc.exists) continue;

    const playerData = playerDoc.data()!;
    const emailPrefs = playerData.emailNotifications;

    if (!playerData.email || (emailPrefs && emailPrefs.matchResults === false)) {
      continue;
    }

    const isOnTeam1 = player.team === 1;
    const playerWon = isOnTeam1 ? team1Won : !team1Won;
    const playerTeam = isOnTeam1 ? team1 : team2;
    const opponentTeam = isOnTeam1 ? team2 : team1;

    // Find partner (other player on same team)
    const partner = playerTeam.find((p) => p.userId !== player.userId);
    const partnerName = partner?.displayName || "Partner";

    // Game scores from this player's team perspective
    const gameScores = isOnTeam1
      ? scores.games.map((g: GameScore) => `${g.creatorScore}-${g.opponentScore}`)
      : scores.games.map((g: GameScore) => `${g.opponentScore}-${g.creatorScore}`);

    const playerGamesWon = isOnTeam1 ? team1GamesWon : team2GamesWon;
    const opponentGamesWon = isOnTeam1 ? team2GamesWon : team1GamesWon;

    const html = doublesMatchResultEmail({
      recipientName: playerData.displayName || "Pickleballer",
      partnerName,
      opponent1Name: opponentTeam[0]?.displayName || "Opponent",
      opponent2Name: opponentTeam[1]?.displayName || "Opponent",
      matchScore: playerWon
        ? `${playerGamesWon}-${opponentGamesWon}`
        : `${opponentGamesWon}-${playerGamesWon}`,
      isWinner: playerWon,
      gameScores,
      location: proposalData.location,
      dateTime: formatDateTime(proposalDateTime),
      proposalUrl: getProposalUrl(proposalId),
      preferencesUrl: getPreferencesUrl(player.userId),
    });

    const result = await emailService.send({
      to: playerData.email,
      subject: doublesMatchResultEmailSubject(playerWon),
      html,
    });

    if (result.success) {
      console.log(`[onProposalUpdated] Doubles result email sent to ${playerData.email}`);
    }
  }

  // Update doubles standings for all 4 players
  const skillBracket = proposalData.skillBracket;
  if (!skillBracket) {
    console.log(`[onProposalUpdated] No skill bracket found, skipping doubles standings update`);
    return;
  }

  for (let i = 0; i < confirmedPlayers.length; i++) {
    const player = confirmedPlayers[i];
    const playerDoc = playerDocs[i];
    const isOnTeam1 = player.team === 1;
    const won = isOnTeam1 ? team1Won : !team1Won;

    await updatePlayerStanding(
      db,
      "doubles_standings",
      skillBracket,
      player.userId,
      playerDoc.exists ? playerDoc.data()!.displayName : player.displayName,
      playerDoc.exists ? playerDoc.data()!.skillLevel : "3.5",
      won
    );

    // Also update user's doubles stats
    if (playerDoc.exists) {
      const userData = playerDoc.data()!;
      const doublesPlayed = (userData.doublesPlayed || 0) + 1;
      const doublesWon = (userData.doublesWon || 0) + (won ? 1 : 0);
      const doublesLost = (userData.doublesLost || 0) + (won ? 0 : 1);
      const doublesWinRate = doublesPlayed > 0 ? doublesWon / doublesPlayed : 0;

      await db.collection("users").doc(player.userId).update({
        doublesPlayed,
        doublesWon,
        doublesLost,
        doublesWinRate,
      });
    }
  }

  console.log(`[onProposalUpdated] Doubles standings updated for all 4 players`);
}

async function updatePlayerStanding(
  db: admin.firestore.Firestore,
  collection: string,
  skillBracket: string,
  playerId: string,
  displayName: string,
  skillLevel: string,
  won: boolean
): Promise<void> {
  const standingRef = db
    .collection(collection)
    .doc(skillBracket)
    .collection("players")
    .doc(playerId);

  const standingDoc = await standingRef.get();

  let matchesPlayed = 1;
  let matchesWon = won ? 1 : 0;
  let matchesLost = won ? 0 : 1;
  let streak = won ? 1 : -1;

  if (standingDoc.exists) {
    const data = standingDoc.data()!;
    matchesPlayed = (data.matchesPlayed || 0) + 1;
    matchesWon = (data.matchesWon || 0) + (won ? 1 : 0);
    matchesLost = (data.matchesLost || 0) + (won ? 0 : 1);

    // Calculate streak: continue if same direction, reset if direction changed
    const currentStreak = data.streak || 0;
    if (won) {
      streak = currentStreak > 0 ? currentStreak + 1 : 1;
    } else {
      streak = currentStreak < 0 ? currentStreak - 1 : -1;
    }
  }

  const winRate = matchesPlayed > 0 ? matchesWon / matchesPlayed : 0;

  await standingRef.set({
    userId: playerId,
    displayName: displayName,
    skillLevel: skillLevel,
    matchesPlayed: matchesPlayed,
    matchesWon: matchesWon,
    matchesLost: matchesLost,
    winRate: winRate,
    streak: streak,
    lastUpdated: new Date(),
  }, { merge: true });

  console.log(`[onProposalUpdated] Updated ${collection} standing for ${displayName}: W${matchesWon}-L${matchesLost}, streak: ${streak > 0 ? '+' : ''}${streak}`);
}
