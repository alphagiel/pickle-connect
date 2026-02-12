import * as functions from "firebase-functions";
import { getEmailService } from "../services/email";
import { welcomeEmail, welcomeEmailSubject } from "../templates";
import { getAppUrl, getPreferencesUrl } from "../config";

/**
 * Firestore trigger: Send welcome email when a new user is created
 */
export const onUserCreated = functions.firestore
  .document("users/{userId}")
  .onCreate(async (snapshot, context) => {
    const userId = context.params.userId;
    const userData = snapshot.data();

    console.log(`[onUserCreated] New user created: ${userId}`);

    // Check if user has email
    if (!userData.email) {
      console.log(`[onUserCreated] User ${userId} has no email, skipping`);
      return;
    }

    // Check email notification preferences (defaults to true if not set)
    const emailPrefs = userData.emailNotifications;
    if (emailPrefs && emailPrefs.welcome === false) {
      console.log(`[onUserCreated] User ${userId} has welcome emails disabled`);
      return;
    }

    const emailService = getEmailService(process.env.RESEND_API_KEY);

    const html = welcomeEmail({
      displayName: userData.displayName || "Pickleballer",
      appUrl: getAppUrl(),
      preferencesUrl: getPreferencesUrl(userId),
    });

    const result = await emailService.send({
      to: userData.email,
      subject: welcomeEmailSubject(),
      html,
    });

    if (result.success) {
      console.log(`[onUserCreated] Welcome email sent to ${userData.email}`);
    } else {
      console.error(`[onUserCreated] Failed to send welcome email: ${result.error}`);
    }
  });
