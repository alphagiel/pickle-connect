import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

interface ConfirmPasswordResetData {
  token: string;
  newPassword: string;
}

interface ConfirmPasswordResetResult {
  success: boolean;
  message: string;
}

/**
 * Callable function to confirm a password reset using a token
 */
export const confirmPasswordReset = functions.https.onCall(
  async (data: ConfirmPasswordResetData): Promise<ConfirmPasswordResetResult> => {
    const { token, newPassword } = data;

    if (!token || typeof token !== "string") {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Reset token is required"
      );
    }

    if (!newPassword || typeof newPassword !== "string") {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "New password is required"
      );
    }

    if (newPassword.length < 6) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Password must be at least 6 characters"
      );
    }

    console.log(`[confirmPasswordReset] Processing reset token`);

    try {
      const db = admin.firestore();
      const tokenRef = db.collection("password_reset_tokens").doc(token);
      const tokenDoc = await tokenRef.get();

      if (!tokenDoc.exists) {
        console.log(`[confirmPasswordReset] Token not found`);
        throw new functions.https.HttpsError(
          "not-found",
          "Invalid or expired reset link"
        );
      }

      const tokenData = tokenDoc.data()!;

      // Check if token is already used
      if (tokenData.used) {
        console.log(`[confirmPasswordReset] Token already used`);
        throw new functions.https.HttpsError(
          "failed-precondition",
          "This reset link has already been used"
        );
      }

      // Check if token is expired (handle both Timestamp and Date)
      const expiresAt = tokenData.expiresAt.toDate ? tokenData.expiresAt.toDate() : new Date(tokenData.expiresAt);
      if (new Date() > expiresAt) {
        console.log(`[confirmPasswordReset] Token expired`);
        throw new functions.https.HttpsError(
          "failed-precondition",
          "This reset link has expired"
        );
      }

      // Update password in Firebase Auth
      await admin.auth().updateUser(tokenData.userId, {
        password: newPassword,
      });

      console.log(`[confirmPasswordReset] Password updated for user: ${tokenData.userId}`);

      // Mark token as used
      await tokenRef.update({
        used: true,
        usedAt: new Date(),
      });

      return {
        success: true,
        message: "Password has been reset successfully",
      };
    } catch (error) {
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      console.error("[confirmPasswordReset] Error:", error);
      throw new functions.https.HttpsError(
        "internal",
        "An error occurred while resetting your password"
      );
    }
  }
);
