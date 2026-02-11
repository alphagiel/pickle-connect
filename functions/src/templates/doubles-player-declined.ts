import { baseTemplate } from "./base";

interface DoublesPlayerDeclinedEmailData {
  recipientName: string;
  creatorName: string;
  skillLevel: string;
  location: string;
  dateTime: string;
  preferencesUrl: string;
}

export function doublesPlayerDeclinedEmail(data: DoublesPlayerDeclinedEmailData): string {
  const content = `
<h2 style="margin: 0 0 16px 0; color: #333333; font-size: 20px; font-weight: 600;">
  Doubles Match Request Update
</h2>

<p style="margin: 0 0 16px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  Hi ${data.recipientName}, unfortunately your request to join <strong>${data.creatorName}</strong>'s doubles match was not approved.
</p>

<table role="presentation" style="width: 100%; margin: 24px 0; background-color: #fff3e0; border-radius: 8px; border: 1px solid #ffe0b2;">
  <tr>
    <td style="padding: 20px;">
      <p style="margin: 0 0 12px 0; color: #333333; font-size: 16px;">
        <strong>Organizer:</strong> ${data.creatorName}
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
  Don't worry - there are plenty of other doubles matches looking for players! Check the app for more opportunities.
</p>

<p style="margin: 0; color: #888888; font-size: 14px;">
  We hope you find another match soon!
</p>
`.trim();

  return baseTemplate(content, data.preferencesUrl);
}

export function doublesPlayerDeclinedEmailSubject(): string {
  return "Update on your doubles match request";
}
