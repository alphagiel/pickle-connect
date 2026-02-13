/**
 * Configuration for the Pickle Connect Cloud Functions
 */

/**
 * App Store listing URL
 */
export const APP_STORE_URL = "https://apps.apple.com/app/id6758889208";

/**
 * Get the base URL for the app (deep links)
 */
export function getAppBaseUrl(): string {
  return process.env.FUNCTIONS_EMULATOR === "true"
    ? "http://localhost:5500"
    : "https://pickleconnect.app";
}

/**
 * Get the deep link URL for a proposal
 */
export function getProposalUrl(proposalId: string): string {
  const baseUrl = getAppBaseUrl();
  return `${baseUrl}/proposal/${proposalId}`;
}

/**
 * Get the app URL (App Store link in production, localhost in dev)
 */
export function getAppUrl(): string {
  return process.env.FUNCTIONS_EMULATOR === "true"
    ? "http://localhost:5500"
    : APP_STORE_URL;
}

/**
 * Get the email preferences URL for a user
 */
export function getPreferencesUrl(userId: string): string {
  const baseUrl = getAppBaseUrl();
  return `${baseUrl}/preferences/${userId}`;
}

/**
 * Get the password reset URL with token
 */
export function getPasswordResetUrl(token: string): string {
  const baseUrl = getAppBaseUrl();
  return `${baseUrl}/reset-password?token=${token}`;
}

/**
 * Password reset token expiry time in minutes
 */
export const PASSWORD_RESET_EXPIRY_MINUTES = 60;

/**
 * Format a date for display in emails
 */
export function formatDateTime(date: Date): string {
  return date.toLocaleDateString("en-US", {
    weekday: "long",
    year: "numeric",
    month: "long",
    day: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });
}
