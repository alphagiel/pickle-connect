import { baseTemplate } from "./base";

interface ProposalUnacceptedConfirmationEmailData {
  recipientName: string;
  creatorName: string;
  skillLevel: string;
  location: string;
  dateTime: string;
  preferencesUrl: string;
}

export function proposalUnacceptedConfirmationEmail(data: ProposalUnacceptedConfirmationEmailData): string {
  const content = `
<h2 style="margin: 0 0 16px 0; color: #333333; font-size: 20px; font-weight: 600;">
  Match Unaccepted
</h2>

<p style="margin: 0 0 16px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  Hi ${data.recipientName}, you have unaccepted the match with <strong>${data.creatorName}</strong>.
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
  The proposal is now open again for other players to accept.
</p>
`.trim();

  return baseTemplate(content, data.preferencesUrl);
}

export function proposalUnacceptedConfirmationEmailSubject(creatorName: string): string {
  return `You unaccepted the match with ${creatorName}`;
}
