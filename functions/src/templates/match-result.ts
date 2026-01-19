import { baseTemplate, actionButton } from "./base";

interface MatchResultEmailData {
  recipientName: string;
  opponentName: string;
  matchScore: string;
  isWinner: boolean;
  gameScores: string[];
  location: string;
  dateTime: string;
  proposalUrl: string;
  preferencesUrl: string;
}

export function matchResultEmail(data: MatchResultEmailData): string {
  const resultText = data.isWinner ? "You won!" : "Better luck next time!";
  const resultColor = data.isWinner ? "#4CAF50" : "#FF9800";
  const resultBgColor = data.isWinner ? "#e8f5e9" : "#fff3e0";
  const resultBorderColor = data.isWinner ? "#c8e6c9" : "#ffe0b2";

  const gameScoresHtml = data.gameScores
    .map((score, index) => `<li>Game ${index + 1}: ${score}</li>`)
    .join("");

  const content = `
<h2 style="margin: 0 0 16px 0; color: #333333; font-size: 20px; font-weight: 600;">
  Match Result Recorded
</h2>

<p style="margin: 0 0 16px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  Hey ${data.recipientName}, the results for your match against <strong>${data.opponentName}</strong> have been recorded.
</p>

<table role="presentation" style="width: 100%; margin: 24px 0; background-color: ${resultBgColor}; border-radius: 8px; border: 1px solid ${resultBorderColor};">
  <tr>
    <td style="padding: 20px; text-align: center;">
      <p style="margin: 0 0 8px 0; color: ${resultColor}; font-size: 32px; font-weight: 700;">
        ${data.matchScore}
      </p>
      <p style="margin: 0; color: ${resultColor}; font-size: 18px; font-weight: 600;">
        ${resultText}
      </p>
    </td>
  </tr>
</table>

<table role="presentation" style="width: 100%; margin: 24px 0; background-color: #f9f9f9; border-radius: 8px; border: 1px solid #e0e0e0;">
  <tr>
    <td style="padding: 20px;">
      <p style="margin: 0 0 12px 0; color: #333333; font-size: 16px;">
        <strong>Game Scores:</strong>
      </p>
      <ul style="margin: 0 0 12px 0; padding-left: 20px; color: #555555; font-size: 16px; line-height: 1.6;">
        ${gameScoresHtml}
      </ul>
      <p style="margin: 0 0 12px 0; color: #333333; font-size: 16px;">
        <strong>Location:</strong> ${data.location}
      </p>
      <p style="margin: 0; color: #333333; font-size: 16px;">
        <strong>Date:</strong> ${data.dateTime}
      </p>
    </td>
  </tr>
</table>

${actionButton("View Match Details", data.proposalUrl)}

<p style="margin: 0; color: #888888; font-size: 14px;">
  If the button doesn't work, copy and paste this link: ${data.proposalUrl}
</p>
`.trim();

  return baseTemplate(content, data.preferencesUrl);
}

export function matchResultEmailSubject(isWinner: boolean, opponentName: string): string {
  return isWinner
    ? `You won your match against ${opponentName}!`
    : `Match result: ${opponentName}`;
}
