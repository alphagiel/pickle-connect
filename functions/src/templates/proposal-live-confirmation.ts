import { baseTemplate, actionButton } from "./base";

interface ProposalLiveConfirmationEmailData {
  creatorName: string;
  skillLevel: string;
  location: string;
  dateTime: string;
  proposalUrl: string;
  preferencesUrl: string;
}

export function proposalLiveConfirmationEmail(data: ProposalLiveConfirmationEmailData): string {
  const content = `
<h2 style="margin: 0 0 16px 0; color: #333333; font-size: 20px; font-weight: 600;">
  Your Match Proposal is Live!
</h2>

<p style="margin: 0 0 16px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  Hey ${data.creatorName}! Your match proposal is now live and everyone in your division has been notified. Good luck finding a match!
</p>

<table role="presentation" style="width: 100%; margin: 24px 0; background-color: #e3f2fd; border-radius: 8px; border: 1px solid #bbdefb;">
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
  We'll notify you as soon as someone accepts your proposal. Keep an eye on your inbox!
</p>

${actionButton("View Your Proposal", data.proposalUrl)}

<p style="margin: 0; color: #888888; font-size: 14px;">
  If the button doesn't work, copy and paste this link: ${data.proposalUrl}
</p>
`.trim();

  return baseTemplate(content, data.preferencesUrl);
}

export function proposalLiveConfirmationEmailSubject(): string {
  return "Your match proposal is now live!";
}
