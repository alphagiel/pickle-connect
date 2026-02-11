import { baseTemplate, actionButton } from "./base";

interface DoublesScoresConfirmedEmailData {
  recipientName: string;
  confirmerName: string;
  location: string;
  dateTime: string;
  proposalUrl: string;
  preferencesUrl: string;
}

export function doublesScoresConfirmedEmail(data: DoublesScoresConfirmedEmailData): string {
  const content = `
<h2 style="margin: 0 0 16px 0; color: #333333; font-size: 20px; font-weight: 600;">
  Doubles Match Scores Confirmed
</h2>

<p style="margin: 0 0 16px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  Hey ${data.recipientName}, <strong>${data.confirmerName}</strong> has confirmed the scores for your doubles match.
</p>

<table role="presentation" style="width: 100%; margin: 24px 0; background-color: #e8f5e9; border-radius: 8px; border: 1px solid #c8e6c9;">
  <tr>
    <td style="padding: 20px;">
      <p style="margin: 0 0 12px 0; color: #333333; font-size: 16px;">
        <strong>Confirmed by:</strong> ${data.confirmerName}
      </p>
      <p style="margin: 0 0 12px 0; color: #333333; font-size: 16px;">
        <strong>Location:</strong> ${data.location}
      </p>
      <p style="margin: 0; color: #333333; font-size: 16px;">
        <strong>Date:</strong> ${data.dateTime}
      </p>
    </td>
  </tr>
</table>

<p style="margin: 0 0 24px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  If you haven't confirmed the scores yet, please open the app to review and confirm.
</p>

${actionButton("View Match Details", data.proposalUrl)}

<p style="margin: 0; color: #888888; font-size: 14px;">
  If the button doesn't work, copy and paste this link: ${data.proposalUrl}
</p>
`.trim();

  return baseTemplate(content, data.preferencesUrl);
}

export function doublesScoresConfirmedEmailSubject(confirmerName: string): string {
  return `${confirmerName} confirmed the doubles match scores`;
}
