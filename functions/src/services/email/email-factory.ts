import { IEmailService } from "./email-service.interface";
import { MailpitService } from "./mailpit.service";
import { SendGridService } from "./sendgrid.service";

let emailServiceInstance: IEmailService | null = null;

/**
 * Detect if running in Firebase emulator
 */
function isEmulator(): boolean {
  return (
    process.env.FUNCTIONS_EMULATOR === "true" ||
    process.env.FIRESTORE_EMULATOR_HOST !== undefined
  );
}

/**
 * Get the appropriate email service based on environment
 * - Emulator/local: Returns MailpitService
 * - Production: Returns SendGridService
 */
export function getEmailService(sendGridApiKey?: string): IEmailService {
  if (emailServiceInstance) {
    return emailServiceInstance;
  }

  if (isEmulator()) {
    console.log("[EmailFactory] Using Mailpit for local development");
    emailServiceInstance = new MailpitService();
  } else {
    if (!sendGridApiKey) {
      throw new Error("SENDGRID_API_KEY is required in production");
    }
    console.log("[EmailFactory] Using SendGrid for production");
    emailServiceInstance = new SendGridService(sendGridApiKey);
  }

  return emailServiceInstance;
}

/**
 * Reset the email service instance (for testing)
 */
export function resetEmailService(): void {
  emailServiceInstance = null;
}
