/**
 * Configuration for the Pickle Connect Cloud Functions
 */

/**
 * Get the base URL for the app (deep links)
 */
export function getAppBaseUrl(): string {
  return process.env.FUNCTIONS_EMULATOR === "true"
    ? "http://localhost:3000"
    : "https://pickleconnect.app";
}

/**
 * Get the deep link URL for a proposal
 */
export function getProposalUrl(proposalId: string): string {
  const baseUrl = getAppBaseUrl();
  // Deep link format that works with app_links
  return `${baseUrl}/proposal/${proposalId}`;
}

/**
 * Get the app URL for deep linking
 */
export function getAppUrl(): string {
  const baseUrl = getAppBaseUrl();
  return baseUrl;
}

/**
 * Get the email preferences URL for a user
 */
export function getPreferencesUrl(userId: string): string {
  const baseUrl = getAppBaseUrl();
  return `${baseUrl}/preferences/${userId}`;
}

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
