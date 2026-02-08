import { baseTemplate, actionButton } from "./base";

interface DoublesPartnerInviteEmailData {
  recipientName: string;
  inviterName: string;
  skillLevel: string;
  location: string;
  dateTime: string;
  proposalUrl: string;
  preferencesUrl: string;
}

export function doublesPartnerInviteEmail(data: DoublesPartnerInviteEmailData): string {
  const content = `
<h2 style="margin: 0 0 16px 0; color: #333333; font-size: 20px; font-weight: 600;">
  You've Been Invited as a Doubles Partner!
</h2>

<p style="margin: 0 0 16px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  Hey ${data.recipientName}, <strong>${data.inviterName}</strong> wants you as their doubles partner for an upcoming match.
</p>

<table role="presentation" style="width: 100%; margin: 24px 0; background-color: #e8f5e9; border-radius: 8px; border: 1px solid #c8e6c9;">
  <tr>
    <td style="padding: 20px;">
      <p style="margin: 0 0 12px 0; color: #333333; font-size: 16px;">
        <strong>Partner:</strong> ${data.inviterName}
      </p>
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
  Open the app to accept or decline the invitation.
</p>

${actionButton("View Doubles Match", data.proposalUrl)}

<p style="margin: 0; color: #888888; font-size: 14px;">
  If the button doesn't work, copy and paste this link: ${data.proposalUrl}
</p>
`.trim();

  return baseTemplate(content, data.preferencesUrl);
}

export function doublesPartnerInviteEmailSubject(inviterName: string): string {
  return `${inviterName} wants you as a doubles partner!`;
}
