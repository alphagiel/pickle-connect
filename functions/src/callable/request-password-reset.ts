import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as crypto from "crypto";
import { getEmailService } from "../services/email";
import { passwordResetEmail, passwordResetEmailSubject } from "../templates";
import {
  getPasswordResetUrl,
  getPreferencesUrl,
  PASSWORD_RESET_EXPIRY_MINUTES,
} from "../config";

interface RequestPasswordResetData {
  email: string;
}

interface RequestPasswordResetResult {
  success: boolean;
  message: string;
}

/**
 * Callable function to request a password reset email
 * This bypasses Firebase Auth's built-in reset to use our email service (Mailpit in dev)
 */
export const requestPasswordReset = functions.https.onCall(
  async (data: RequestPasswordResetData): Promise<RequestPasswordResetResult> => {
    const { email } = data;

    if (!email || typeof email !== "string") {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Email address is required"
      );
    }

    const normalizedEmail = email.toLowerCase().trim();

    console.log(`[requestPasswordReset] Request for: ${normalizedEmail}`);

    try {
      // Look up user by email in Firebase Auth
      let userRecord: admin.auth.UserRecord;
      try {
        userRecord = await admin.auth().getUserByEmail(normalizedEmail);
      } catch {
        // Don't reveal if email exists or not (security best practice)
        console.log(`[requestPasswordReset] User not found: ${normalizedEmail}`);
        return {
          success: true,
          message: "If an account exists with this email, a reset link has been sent.",
        };
      }

      // Look up user profile in Firestore for display name
      const userDoc = await admin
        .firestore()
        .collection("users")
        .doc(userRecord.uid)
        .get();

      const displayName =
        userDoc.data()?.displayName ||
        userRecord.displayName ||
        "Pickleballer";

      // Generate secure token
      const token = crypto.randomBytes(32).toString("hex");
      const expiresAt = new Date(
        Date.now() + PASSWORD_RESET_EXPIRY_MINUTES * 60 * 1000
      );

      // Store token in Firestore
      await admin
        .firestore()
        .collection("password_reset_tokens")
        .doc(token)
        .set({
          userId: userRecord.uid,
          email: normalizedEmail,
          createdAt: new Date(),
          expiresAt: expiresAt,
          used: false,
        });

      console.log(`[requestPasswordReset] Token created for user: ${userRecord.uid}`);

      // Send email
      const emailService = getEmailService(process.env.RESEND_API_KEY);
      const resetUrl = getPasswordResetUrl(token);

      const html = passwordResetEmail({
        displayName,
        resetUrl,
        expiryMinutes: PASSWORD_RESET_EXPIRY_MINUTES,
        preferencesUrl: getPreferencesUrl(userRecord.uid),
      });

      const result = await emailService.send({
        to: normalizedEmail,
        subject: passwordResetEmailSubject(),
        html,
      });

      if (result.success) {
        console.log(`[requestPasswordReset] Email sent to: ${normalizedEmail}`);
      } else {
        console.error(`[requestPasswordReset] Failed to send email: ${result.error}`);
        throw new functions.https.HttpsError(
          "internal",
          "Failed to send password reset email"
        );
      }

      return {
        success: true,
        message: "If an account exists with this email, a reset link has been sent.",
      };
    } catch (error) {
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      console.error("[requestPasswordReset] Error:", error);
      throw new functions.https.HttpsError(
        "internal",
        "An error occurred while processing your request"
      );
    }
  }
);
