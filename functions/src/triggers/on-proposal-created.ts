import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { getEmailService } from "../services/email";
import { newProposalEmail, newProposalEmailSubject, proposalLiveConfirmationEmail, proposalLiveConfirmationEmailSubject } from "../templates";
import { getProposalUrl, getPreferencesUrl, formatDateTime } from "../config";

/**
 * Firestore trigger: Send notification emails when a new proposal is created
 * Emails are sent to all users in the same skill bracket (except the creator)
 */
export const onProposalCreated = functions.firestore
  .document("proposals/{proposalId}")
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
    const emailService = getEmailService(process.env.SENDGRID_API_KEY);

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

    let emailsSent = 0;
    let emailsSkipped = 0;

    for (const userDoc of usersSnapshot.docs) {
      const userData = userDoc.data();

      // Skip the creator
      if (userDoc.id === proposalData.creatorId) {
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

    console.log(`[onProposalCreated] Sent ${emailsSent} emails, skipped ${emailsSkipped}`);

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
