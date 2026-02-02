import { baseTemplate, actionButton } from "./base";

interface PasswordResetEmailData {
  displayName: string;
  resetUrl: string;
  expiryMinutes: number;
  preferencesUrl: string;
}

export function passwordResetEmail(data: PasswordResetEmailData): string {
  const content = `
<h2 style="margin: 0 0 16px 0; color: #333333; font-size: 20px; font-weight: 600;">
  Reset Your Password
</h2>

<p style="margin: 0 0 16px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  Hi ${data.displayName},
</p>

<p style="margin: 0 0 16px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  We received a request to reset your Pickle Connect password. Click the button below to create a new password:
</p>

${actionButton("Reset Password", data.resetUrl)}

<p style="margin: 0 0 16px 0; color: #888888; font-size: 14px; line-height: 1.6;">
  This link will expire in ${data.expiryMinutes} minutes.
</p>

<p style="margin: 0 0 16px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  If you didn't request a password reset, you can safely ignore this email. Your password will not be changed.
</p>

<p style="margin: 0; color: #888888; font-size: 14px;">
  If the button doesn't work, copy and paste this link into your browser:<br>
  <span style="color: #4CAF50; word-break: break-all;">${data.resetUrl}</span>
</p>
`.trim();

  return baseTemplate(content, data.preferencesUrl);
}

export function passwordResetEmailSubject(): string {
  return "Reset Your Pickle Connect Password";
}
