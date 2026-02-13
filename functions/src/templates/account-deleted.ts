import { baseTemplate } from "./base";

interface AccountDeletedEmailData {
  displayName: string;
}

export function accountDeletedEmail(data: AccountDeletedEmailData): string {
  const content = `
<h2 style="margin: 0 0 16px 0; color: #333333; font-size: 20px; font-weight: 600;">
  We're sorry to see you go, ${data.displayName}
</h2>

<p style="margin: 0 0 16px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  Your Pickle Connect account has been deleted. All your data, match history, and preferences have been removed.
</p>

<p style="margin: 0 0 16px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  If this was a mistake or you change your mind, you're always welcome to sign up again and rejoin the community.
</p>

<p style="margin: 0 0 16px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  Thanks for being part of the Pickle Connect community. We hope to see you back on the courts!
</p>

<p style="margin: 0; color: #888888; font-size: 14px;">
  You won't receive any more emails from us.
</p>
`.trim();

  // No preferences URL since the account is deleted
  return baseTemplate(content, "");
}

export function accountDeletedEmailSubject(): string {
  return "Your Pickle Connect account has been deleted";
}
