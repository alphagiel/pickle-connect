import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { getEmailService } from "../services/email";
import { proposalCancelledEmail, proposalCancelledEmailSubject } from "../templates";
import { getPreferencesUrl, formatDateTime } from "../config";

/**
 * Firestore trigger: Handle proposal deletion
 * - If proposal had an accepter, notify them that it was cancelled
 */
export const onProposalDeleted = functions
  .runWith({ secrets: ["RESEND_API_KEY"] })
  .firestore.document("proposals/{proposalId}")
  .onDelete(async (snapshot, context) => {
    const proposalId = context.params.proposalId;
    const proposalData = snapshot.data();

    console.log(`[onProposalDeleted] Proposal deleted: ${proposalId}`);

    // Only notify if there was an accepter
    if (!proposalData.acceptedBy) {
      console.log(`[onProposalDeleted] No accepter to notify`);
      return;
    }

    const db = admin.firestore();
    const emailService = getEmailService(process.env.RESEND_API_KEY);

    // Get the accepter's user document
    const accepterDoc = await db.collection("users").doc(proposalData.acceptedBy.userId).get();
    if (!accepterDoc.exists) {
      console.log(`[onProposalDeleted] Accepter ${proposalData.acceptedBy.userId} not found`);
      return;
    }

    const accepterData = accepterDoc.data()!;

    // Check email preferences
    const emailPrefs = accepterData.emailNotifications;
    if (emailPrefs && emailPrefs.proposalCancelled === false) {
      console.log(`[onProposalDeleted] Accepter has proposal cancelled emails disabled`);
      return;
    }

    if (!accepterData.email) {
      console.log(`[onProposalDeleted] Accepter has no email`);
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
      preferencesUrl: getPreferencesUrl(proposalData.acceptedBy.userId),
    });

    const result = await emailService.send({
      to: accepterData.email,
      subject: proposalCancelledEmailSubject(proposalData.creatorName),
      html,
    });

    if (result.success) {
      console.log(`[onProposalDeleted] Proposal cancelled email sent to ${accepterData.email}`);
    } else {
      console.error(`[onProposalDeleted] Failed to send proposal cancelled email: ${result.error}`);
    }
  });
