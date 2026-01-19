import { baseTemplate, actionButton } from "./base";

interface ProposalUnacceptedEmailData {
  creatorName: string;
  unacceptedByName: string;
  skillLevel: string;
  location: string;
  dateTime: string;
  proposalUrl: string;
  preferencesUrl: string;
}

export function proposalUnacceptedEmail(data: ProposalUnacceptedEmailData): string {
  const content = `
<h2 style="margin: 0 0 16px 0; color: #333333; font-size: 20px; font-weight: 600;">
  Match Proposal Update
</h2>

<p style="margin: 0 0 16px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  Hi ${data.creatorName}, <strong>${data.unacceptedByName}</strong> is no longer able to play and has unaccepted your match proposal.
</p>

<table role="presentation" style="width: 100%; margin: 24px 0; background-color: #fff3e0; border-radius: 8px; border: 1px solid #ffe0b2;">
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
  Your proposal is now open again and other players can accept it.
</p>

${actionButton("View Proposal", data.proposalUrl)}

<p style="margin: 0; color: #888888; font-size: 14px;">
  If the button doesn't work, copy and paste this link: ${data.proposalUrl}
</p>
`.trim();

  return baseTemplate(content, data.preferencesUrl);
}

export function proposalUnacceptedEmailSubject(): string {
  return "Your match proposal is open again";
}
