import { baseTemplate, actionButton } from "./base";

interface DoublesPartnerConfirmedEmailData {
  recipientName: string;
  partnerName: string;
  skillLevel: string;
  location: string;
  dateTime: string;
  proposalUrl: string;
  preferencesUrl: string;
}

export function doublesPartnerConfirmedEmail(data: DoublesPartnerConfirmedEmailData): string {
  const content = `
<h2 style="margin: 0 0 16px 0; color: #333333; font-size: 20px; font-weight: 600;">
  Your Doubles Partner Confirmed!
</h2>

<p style="margin: 0 0 16px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  Great news, ${data.recipientName}! <strong>${data.partnerName}</strong> has accepted your partner invitation for your doubles match.
</p>

<table role="presentation" style="width: 100%; margin: 24px 0; background-color: #e8f5e9; border-radius: 8px; border: 1px solid #c8e6c9;">
  <tr>
    <td style="padding: 20px;">
      <p style="margin: 0 0 12px 0; color: #333333; font-size: 16px;">
        <strong>Partner:</strong> ${data.partnerName}
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
  You're one step closer to a full lobby. Keep an eye out for more players joining!
</p>

${actionButton("View Doubles Match", data.proposalUrl)}

<p style="margin: 0; color: #888888; font-size: 14px;">
  If the button doesn't work, copy and paste this link: ${data.proposalUrl}
</p>
`.trim();

  return baseTemplate(content, data.preferencesUrl);
}

export function doublesPartnerConfirmedEmailSubject(partnerName: string): string {
  return `${partnerName} confirmed as your doubles partner!`;
}
