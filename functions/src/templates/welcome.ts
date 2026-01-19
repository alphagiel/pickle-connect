import { baseTemplate, actionButton } from "./base";

interface WelcomeEmailData {
  displayName: string;
  appUrl: string;
  preferencesUrl: string;
}

export function welcomeEmail(data: WelcomeEmailData): string {
  const content = `
<h2 style="margin: 0 0 16px 0; color: #333333; font-size: 20px; font-weight: 600;">
  Welcome to Pickle Connect, ${data.displayName}!
</h2>

<p style="margin: 0 0 16px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  Thanks for joining our pickleball community! You're now ready to find matches, challenge other players, and track your progress.
</p>

<p style="margin: 0 0 24px 0; color: #555555; font-size: 16px; line-height: 1.6;">
  Here's what you can do:
</p>

<ul style="margin: 0 0 24px 0; padding-left: 20px; color: #555555; font-size: 16px; line-height: 1.8;">
  <li>Browse open match proposals in your skill bracket</li>
  <li>Create your own proposals and find opponents</li>
  <li>Record match results and track your stats</li>
  <li>Climb the seasonal rankings ladder</li>
</ul>

${actionButton("Open Pickle Connect", data.appUrl)}

<p style="margin: 0; color: #888888; font-size: 14px;">
  If the button doesn't work, copy and paste this link: ${data.appUrl}
</p>
`.trim();

  return baseTemplate(content, data.preferencesUrl);
}

export function welcomeEmailSubject(): string {
  return "Welcome to Pickle Connect!";
}
