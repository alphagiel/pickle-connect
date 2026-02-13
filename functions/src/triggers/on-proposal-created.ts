import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { getEmailService } from "../services/email";
import {
  newProposalEmail,
  newProposalEmailSubject,
  proposalLiveConfirmationEmail,
  proposalLiveConfirmationEmailSubject,
  doublesNewProposalEmail,
  doublesNewProposalEmailSubject,
  doublesPartnerInviteEmail,
  doublesPartnerInviteEmailSubject,
} from "../templates";
import { getProposalUrl, getPreferencesUrl, formatDateTime } from "../config";

/**
 * Firestore trigger: Send notification emails when a new proposal is created
 * Emails are sent to all users in the same skill bracket (except the creator)
 */
export const onProposalCreated = functions
  .runWith({ secrets: ["RESEND_API_KEY"] })
  .firestore.document("proposals/{proposalId}")
  .onCreate(async (snapshot, context) => {
    const proposalId = context.params.proposalId;
    const proposalData = snapshot.data();

    console.log(`[onProposalCreated] New proposal created: ${proposalId}`);

    // Only send emails for open proposals
    if (proposalData.status !== "open") {
      console.log(`[onProposalCreated] Proposal ${proposalId} is not open, skipping`);
      return;
    }

    const db = admin.firestore();
    const emailService = getEmailService(process.env.RESEND_API_KEY);
    const isDoubles = proposalData.matchType === "doubles";

    // Query users with the same skill level (except the creator)
    const usersSnapshot = await db
      .collection("users")
      .where("skillLevel", "==", proposalData.skillLevel)
      .get();

    if (usersSnapshot.empty) {
      console.log(`[onProposalCreated] No users found with skill level ${proposalData.skillLevel}`);
      return;
    }

    const proposalDateTime = proposalData.dateTime?.toDate
      ? proposalData.dateTime.toDate()
      : new Date(proposalData.dateTime);

    // Build a set of player IDs already in the doubles lobby (creator + invited partners)
    const doublesPlayerIds = new Set<string>();
    if (isDoubles) {
      doublesPlayerIds.add(proposalData.creatorId);
      const doublesPlayers: Array<{ userId: string; status: string; displayName?: string }> =
        proposalData.doublesPlayers || [];
      for (const p of doublesPlayers) {
        doublesPlayerIds.add(p.userId);
      }
    }

    let emailsSent = 0;
    let emailsSkipped = 0;

    // Event #1 (doubles) or existing singles broadcast
    for (const userDoc of usersSnapshot.docs) {
      const userData = userDoc.data();

      // Skip the creator
      if (userDoc.id === proposalData.creatorId) {
        continue;
      }

      // For doubles, also skip players already in the lobby (invited partners)
      if (isDoubles && doublesPlayerIds.has(userDoc.id)) {
        continue;
      }

      // Skip users without email
      if (!userData.email) {
        emailsSkipped++;
        continue;
      }

      // Check email notification preferences
      const emailPrefs = userData.emailNotifications;
      if (emailPrefs && emailPrefs.newProposals === false) {
        emailsSkipped++;
        continue;
      }

      if (isDoubles) {
        // Event #1: Doubles new proposal broadcast
        const html = doublesNewProposalEmail({
          recipientName: userData.displayName || "Pickleballer",
          creatorName: proposalData.creatorName || "A player",
          skillLevel: proposalData.skillLevel,
          location: proposalData.location,
          dateTime: formatDateTime(proposalDateTime),
          proposalUrl: getProposalUrl(proposalId),
          preferencesUrl: getPreferencesUrl(userDoc.id),
        });

        const result = await emailService.send({
          to: userData.email,
          subject: doublesNewProposalEmailSubject(proposalData.creatorName || "A player"),
          html,
        });

        if (result.success) {
          emailsSent++;
        } else {
          console.error(`[onProposalCreated] Failed to send doubles proposal to ${userData.email}: ${result.error}`);
        }
      } else {
        // Singles new proposal broadcast (existing logic)
        const html = newProposalEmail({
          recipientName: userData.displayName || "Pickleballer",
          creatorName: proposalData.creatorName,
          skillLevel: proposalData.skillLevel,
          location: proposalData.location,
          dateTime: formatDateTime(proposalDateTime),
          proposalUrl: getProposalUrl(proposalId),
          preferencesUrl: getPreferencesUrl(userDoc.id),
        });

        const result = await emailService.send({
          to: userData.email,
          subject: newProposalEmailSubject(proposalData.creatorName),
          html,
        });

        if (result.success) {
          emailsSent++;
        } else {
          console.error(`[onProposalCreated] Failed to send to ${userData.email}: ${result.error}`);
        }
      }
    }

    console.log(`[onProposalCreated] Sent ${emailsSent} broadcast emails, skipped ${emailsSkipped}`);

    // Event #2: Send partner invite emails for any doubles players with status "invited"
    if (isDoubles) {
      const doublesPlayers: Array<{ userId: string; status: string; displayName?: string }> =
        proposalData.doublesPlayers || [];
      const invitedPlayers = doublesPlayers.filter((p) => p.status === "invited");

      for (const invited of invitedPlayers) {
        const invitedDoc = await db.collection("users").doc(invited.userId).get();
        if (!invitedDoc.exists) {
          console.log(`[onProposalCreated] Invited partner ${invited.userId} not found`);
          continue;
        }

        const invitedData = invitedDoc.data()!;
        const emailPrefs = invitedData.emailNotifications;
        if (!invitedData.email || (emailPrefs && emailPrefs.doublesUpdates === false)) {
          console.log(`[onProposalCreated] Invited partner has no email or doubles emails disabled`);
          continue;
        }

        const html = doublesPartnerInviteEmail({
          recipientName: invitedData.displayName || "Pickleballer",
          inviterName: proposalData.creatorName || "A player",
          skillLevel: proposalData.skillLevel,
          location: proposalData.location,
          dateTime: formatDateTime(proposalDateTime),
          proposalUrl: getProposalUrl(proposalId),
          preferencesUrl: getPreferencesUrl(invited.userId),
        });

        const result = await emailService.send({
          to: invitedData.email,
          subject: doublesPartnerInviteEmailSubject(proposalData.creatorName || "A player"),
          html,
        });

        if (result.success) {
          console.log(`[onProposalCreated] Partner invite email sent to ${invitedData.email}`);
        } else {
          console.error(`[onProposalCreated] Failed to send partner invite to ${invitedData.email}: ${result.error}`);
        }
      }
    }

    // Send confirmation email to the proposal creator
    const creatorDoc = await db.collection("users").doc(proposalData.creatorId).get();
    if (creatorDoc.exists) {
      const creatorData = creatorDoc.data();
      if (creatorData?.email) {
        const creatorHtml = proposalLiveConfirmationEmail({
          creatorName: proposalData.creatorName || creatorData.displayName || "Pickleballer",
          skillLevel: proposalData.skillLevel,
          location: proposalData.location,
          dateTime: formatDateTime(proposalDateTime),
          proposalUrl: getProposalUrl(proposalId),
          preferencesUrl: getPreferencesUrl(proposalData.creatorId),
        });

        const creatorResult = await emailService.send({
          to: creatorData.email,
          subject: proposalLiveConfirmationEmailSubject(),
          html: creatorHtml,
        });

        if (creatorResult.success) {
          console.log(`[onProposalCreated] Sent confirmation email to creator ${creatorData.email}`);
        } else {
          console.error(`[onProposalCreated] Failed to send confirmation to creator: ${creatorResult.error}`);
        }
      }
    }
  });
