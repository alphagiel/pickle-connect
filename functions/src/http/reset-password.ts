import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

/**
 * HTTP endpoint for confirming a password reset from the static web page.
 * POST /resetPasswordHttp { token, newPassword }
 */
export const resetPasswordHttp = functions.https.onRequest(async (req, res) => {
  // CORS headers
  res.set("Access-Control-Allow-Origin", "https://pickleconnect.club");
  res.set("Access-Control-Allow-Methods", "POST, OPTIONS");
  res.set("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return;
  }

  if (req.method !== "POST") {
    res.status(405).json({ success: false, message: "Method not allowed" });
    return;
  }

  const { token, newPassword } = req.body;

  if (!token || typeof token !== "string") {
    res.status(400).json({ success: false, message: "Reset token is required" });
    return;
  }

  if (!newPassword || typeof newPassword !== "string") {
    res.status(400).json({ success: false, message: "New password is required" });
    return;
  }

  if (newPassword.length < 6) {
    res.status(400).json({ success: false, message: "Password must be at least 6 characters" });
    return;
  }

  console.log("[resetPasswordHttp] Processing reset token");

  try {
    const db = admin.firestore();
    const tokenRef = db.collection("password_reset_tokens").doc(token);
    const tokenDoc = await tokenRef.get();

    if (!tokenDoc.exists) {
      console.log("[resetPasswordHttp] Token not found");
      res.status(404).json({ success: false, message: "Invalid or expired reset link" });
      return;
    }

    const tokenData = tokenDoc.data()!;

    if (tokenData.used) {
      console.log("[resetPasswordHttp] Token already used");
      res.status(400).json({ success: false, message: "This reset link has already been used" });
      return;
    }

    const expiresAt = tokenData.expiresAt.toDate
      ? tokenData.expiresAt.toDate()
      : new Date(tokenData.expiresAt);
    if (new Date() > expiresAt) {
      console.log("[resetPasswordHttp] Token expired");
      res.status(400).json({ success: false, message: "This reset link has expired" });
      return;
    }

    await admin.auth().updateUser(tokenData.userId, {
      password: newPassword,
    });

    console.log(`[resetPasswordHttp] Password updated for user: ${tokenData.userId}`);

    await tokenRef.update({
      used: true,
      usedAt: new Date(),
    });

    res.status(200).json({ success: true, message: "Password has been reset successfully" });
  } catch (error) {
    console.error("[resetPasswordHttp] Error:", error);
    res.status(500).json({ success: false, message: "An error occurred while resetting your password" });
  }
});
