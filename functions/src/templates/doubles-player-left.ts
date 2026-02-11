import { baseTemplate, actionButton } from "./base";

interface DoublesPlayerLeftEmailData {
  recipientName: string;
  playerName: string;
  skillLevel: string;
  location: string;
  dateTime: string;
  proposalUrl: string;
  preferencesUrl: string;
}

export function doublesPlayerLeftEmail(data: DoublesPlayerLeftEmailData): string {
  const content = `
<h2 style="margin: 0 0 16px 0; color: #333333; font-size: 20px; font-weight: 600;">
  A Player Left Your Doubles Match
</h2>

<p style="margin: 0 0 16px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  Hey ${data.recipientName}, <strong>${data.playerName}</strong> has left your doubles match.
</p>

<table role="presentation" style="width: 100%; margin: 24px 0; background-color: #fff3e0; border-radius: 8px; border: 1px solid #ffe0b2;">
  <tr>
    <td style="padding: 20px;">
      <p style="margin: 0 0 12px 0; color: #333333; font-size: 16px;">
        <strong>Player:</strong> ${data.playerName}
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
  You now have a spot open. Other players can still request to join your match.
</p>

${actionButton("View Doubles Match", data.proposalUrl)}

<p style="margin: 0; color: #888888; font-size: 14px;">
  If the button doesn't work, copy and paste this link: ${data.proposalUrl}
</p>
`.trim();

  return baseTemplate(content, data.preferencesUrl);
}

export function doublesPlayerLeftEmailSubject(playerName: string): string {
  return `${playerName} left your doubles match`;
}
