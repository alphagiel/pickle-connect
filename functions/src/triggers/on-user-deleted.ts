import * as functions from "firebase-functions";
import { getEmailService } from "../services/email";
import { accountDeletedEmail, accountDeletedEmailSubject } from "../templates";

/**
 * Firestore trigger: Send farewell email when a user document is deleted
 */
export const onUserDeleted = functions
  .runWith({ secrets: ["RESEND_API_KEY"] })
  .firestore.document("users/{userId}")
  .onDelete(async (snapshot, context) => {
    const userId = context.params.userId;
    const userData = snapshot.data();

    console.log(`[onUserDeleted] User deleted: ${userId}`);

    if (!userData.email) {
      console.log(`[onUserDeleted] User ${userId} has no email, skipping`);
      return;
    }

    const emailService = getEmailService(process.env.RESEND_API_KEY);

    const html = accountDeletedEmail({
      displayName: userData.displayName || "Pickleballer",
    });

    const result = await emailService.send({
      to: userData.email,
      subject: accountDeletedEmailSubject(),
      html,
    });

    if (result.success) {
      console.log(`[onUserDeleted] Farewell email sent to ${userData.email}`);
    } else {
      console.error(`[onUserDeleted] Failed to send farewell email: ${result.error}`);
    }
  });
