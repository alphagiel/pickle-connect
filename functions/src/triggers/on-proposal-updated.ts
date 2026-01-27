import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { getEmailService } from "../services/email";
import {
  proposalAcceptedEmail,
  proposalAcceptedEmailSubject,
  proposalUnacceptedEmail,
  proposalUnacceptedEmailSubject,
  proposalCancelledEmail,
  proposalCancelledEmailSubject,
  matchResultEmail,
  matchResultEmailSubject,
} from "../templates";
import { getProposalUrl, getPreferencesUrl, formatDateTime } from "../config";

interface GameScore {
  creatorScore: number;
  opponentScore: number;
}

interface Scores {
  games: GameScore[];
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

    // Handle proposal accepted
    if (statusChanged && afterData.status === "accepted" && afterData.acceptedBy) {
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

    // Handle proposal cancelled (status changed to cancelled)
    if (
      statusChanged &&
      afterData.status === "cancelled" &&
      beforeData.acceptedBy
    ) {
      await handleProposalCancelled(
        db,
        emailService,
        proposalId,
        afterData,
        beforeData.acceptedBy
      );
    }

    // Handle scores added
    if (scoresAdded) {
      await handleMatchResultRecorded(
        db,
        emailService,
        proposalId,
        afterData
      );
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

  // Get the creator's user document
  const creatorDoc = await db.collection("users").doc(proposalData.creatorId).get();
  if (!creatorDoc.exists) {
    console.log(`[onProposalUpdated] Creator ${proposalData.creatorId} not found`);
    return;
  }

  const creatorData = creatorDoc.data()!;

  // Check email preferences
  const emailPrefs = creatorData.emailNotifications;
  if (emailPrefs && emailPrefs.proposalUnaccepted === false) {
    console.log(`[onProposalUpdated] Creator has proposal unaccepted emails disabled`);
    return;
  }

  if (!creatorData.email) {
    console.log(`[onProposalUpdated] Creator has no email`);
    return;
  }

  const proposalDateTime = proposalData.dateTime?.toDate
    ? proposalData.dateTime.toDate()
    : new Date(proposalData.dateTime);

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
    console.log(`[onProposalUpdated] Proposal unaccepted email sent to ${creatorData.email}`);
  } else {
    console.error(`[onProposalUpdated] Failed to send proposal unaccepted email: ${result.error}`);
  }
}

async function handleProposalCancelled(
  db: admin.firestore.Firestore,
  emailService: ReturnType<typeof getEmailService>,
  proposalId: string,
  proposalData: admin.firestore.DocumentData,
  acceptedBy: { userId: string; displayName: string }
): Promise<void> {
  console.log(`[onProposalUpdated] Proposal ${proposalId} was cancelled`);

  // Get the accepter's user document to notify them
  const accepterDoc = await db.collection("users").doc(acceptedBy.userId).get();
  if (!accepterDoc.exists) {
    console.log(`[onProposalUpdated] Accepter ${acceptedBy.userId} not found`);
    return;
  }

  const accepterData = accepterDoc.data()!;

  // Check email preferences
  const emailPrefs = accepterData.emailNotifications;
  if (emailPrefs && emailPrefs.proposalCancelled === false) {
    console.log(`[onProposalUpdated] Accepter has proposal cancelled emails disabled`);
    return;
  }

  if (!accepterData.email) {
    console.log(`[onProposalUpdated] Accepter has no email`);
    return;
  }

  const proposalDateTime = proposalData.dateTime?.toDate
    ? proposalData.dateTime.toDate()
    : new Date(proposalData.dateTime);

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
    console.log(`[onProposalUpdated] Proposal cancelled email sent to ${accepterData.email}`);
  } else {
    console.error(`[onProposalUpdated] Failed to send proposal cancelled email: ${result.error}`);
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
}
