import { baseTemplate, actionButton } from "./base";

interface DoublesLobbyFullEmailData {
  recipientName: string;
  team1Player1: string;
  team1Player2: string;
  team2Player1: string;
  team2Player2: string;
  skillLevel: string;
  location: string;
  dateTime: string;
  proposalUrl: string;
  preferencesUrl: string;
}

export function doublesLobbyFullEmail(data: DoublesLobbyFullEmailData): string {
  const content = `
<h2 style="margin: 0 0 16px 0; color: #333333; font-size: 20px; font-weight: 600;">
  Your Doubles Match Is Set!
</h2>

<p style="margin: 0 0 16px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  Great news, ${data.recipientName}! All 4 players are confirmed for your doubles match.
</p>

<table role="presentation" style="width: 100%; margin: 24px 0; background-color: #e8f5e9; border-radius: 8px; border: 1px solid #c8e6c9;">
  <tr>
    <td style="padding: 20px;">
      <p style="margin: 0 0 16px 0; color: #4CAF50; font-size: 18px; font-weight: 600;">
        Teams
      </p>
      <table role="presentation" style="width: 100%;">
        <tr>
          <td style="padding: 8px 0; vertical-align: top; width: 50%;">
            <p style="margin: 0 0 8px 0; color: #333333; font-size: 14px; font-weight: 600;">Team 1</p>
            <p style="margin: 0 0 4px 0; color: #555555; font-size: 14px;">${data.team1Player1}</p>
            <p style="margin: 0; color: #555555; font-size: 14px;">${data.team1Player2}</p>
          </td>
          <td style="padding: 8px 0; vertical-align: top; width: 50%;">
            <p style="margin: 0 0 8px 0; color: #333333; font-size: 14px; font-weight: 600;">Team 2</p>
            <p style="margin: 0 0 4px 0; color: #555555; font-size: 14px;">${data.team2Player1}</p>
            <p style="margin: 0; color: #555555; font-size: 14px;">${data.team2Player2}</p>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

<table role="presentation" style="width: 100%; margin: 24px 0; background-color: #f9f9f9; border-radius: 8px; border: 1px solid #e0e0e0;">
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
  Don't forget to record your match results afterward!
</p>

${actionButton("View Match Details", data.proposalUrl)}

<p style="margin: 0; color: #888888; font-size: 14px;">
  If the button doesn't work, copy and paste this link: ${data.proposalUrl}
</p>
`.trim();

  return baseTemplate(content, data.preferencesUrl);
}

export function doublesLobbyFullEmailSubject(): string {
  return "Your doubles match is set! All players confirmed";
}
