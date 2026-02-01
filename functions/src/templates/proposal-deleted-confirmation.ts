import { baseTemplate } from "./base";

interface ProposalDeletedConfirmationEmailData {
  recipientName: string;
  skillLevel: string;
  location: string;
  dateTime: string;
  preferencesUrl: string;
}

export function proposalDeletedConfirmationEmail(data: ProposalDeletedConfirmationEmailData): string {
  const content = `
<h2 style="margin: 0 0 16px 0; color: #333333; font-size: 20px; font-weight: 600;">
  Proposal Deleted
</h2>

<p style="margin: 0 0 16px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  Hi ${data.recipientName}, your match proposal has been successfully deleted.
</p>

<table role="presentation" style="width: 100%; margin: 24px 0; background-color: #f5f5f5; border-radius: 8px; border: 1px solid #e0e0e0;">
  <tr>
    <td style="padding: 20px;">
      <p style="margin: 0 0 12px 0; color: #333333; font-size: 16px;">
        <strong>Skill Level:</strong> ${data.skillLevel}
      </p>
      <p style="margin: 0 0 12px 0; color: #333333; font-size: 16px;">
        <strong>Location:</strong> ${data.location}
      </p>
      <p style="margin: 0; color: #333333; font-size: 16px;">
        <strong>When:</strong> ${data.dateTime}
      </p>
    </td>
  </tr>
</table>

<p style="margin: 0 0 24px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  You can create a new proposal anytime from the app.
</p>
`.trim();

  return baseTemplate(content, data.preferencesUrl);
}

export function proposalDeletedConfirmationEmailSubject(): string {
  return "Your proposal has been deleted";
}
