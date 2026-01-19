import * as sgMail from "@sendgrid/mail";
import {
  IEmailService,
  EmailMessage,
  BatchEmailMessage,
  EmailResult,
} from "./email-service.interface";

/**
 * SendGrid email service for production
 */
export class SendGridService implements IEmailService {
  private from: { email: string; name: string };

  constructor(apiKey: string) {
    sgMail.setApiKey(apiKey);

    this.from = {
      email: process.env.EMAIL_FROM || "noreply@pickleconnect.app",
      name: process.env.EMAIL_FROM_NAME || "Pickle Connect",
    };
  }

  async send(message: EmailMessage): Promise<EmailResult> {
    try {
      const [response] = await sgMail.send({
        to: message.to,
        from: this.from,
        subject: message.subject,
        html: message.html,
        text: message.text || this.htmlToText(message.html),
      });

      console.log(`[SendGrid] Email sent to ${message.to}: ${response.statusCode}`);

      return {
        success: true,
        messageId: response.headers["x-message-id"] as string,
      };
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : "Unknown error";
      console.error(`[SendGrid] Failed to send email to ${message.to}:`, errorMessage);

      return {
        success: false,
        error: errorMessage,
      };
    }
  }

  async sendBatch(message: BatchEmailMessage): Promise<EmailResult[]> {
    const results: EmailResult[] = [];

    // SendGrid supports batch sending, but for personalization we send individually
    for (const recipient of message.to) {
      const result = await this.send({
        to: recipient,
        subject: message.subject,
        html: message.html,
        text: message.text,
      });
      results.push(result);
    }

    return results;
  }

  private htmlToText(html: string): string {
    return html
      .replace(/<[^>]*>/g, "")
      .replace(/\s+/g, " ")
      .trim();
  }
}
