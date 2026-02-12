import { Resend } from "resend";
import {
  IEmailService,
  EmailMessage,
  BatchEmailMessage,
  EmailResult,
} from "./email-service.interface";

/**
 * Resend email service for production
 */
export class ResendService implements IEmailService {
  private client: Resend;
  private from: string;

  constructor(apiKey: string) {
    this.client = new Resend(apiKey);

    const email = process.env.EMAIL_FROM || "noreply@pickleconnect.app";
    const name = process.env.EMAIL_FROM_NAME || "Pickle Connect";
    this.from = `${name} <${email}>`;
  }

  async send(message: EmailMessage): Promise<EmailResult> {
    try {
      const { data, error } = await this.client.emails.send({
        from: this.from,
        to: message.to,
        subject: message.subject,
        html: message.html,
        text: message.text || this.htmlToText(message.html),
      });

      if (error) {
        console.error(`[Resend] Failed to send email to ${message.to}:`, error.message);
        return {
          success: false,
          error: error.message,
        };
      }

      console.log(`[Resend] Email sent to ${message.to}: ${data?.id}`);

      return {
        success: true,
        messageId: data?.id,
      };
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : "Unknown error";
      console.error(`[Resend] Failed to send email to ${message.to}:`, errorMessage);

      return {
        success: false,
        error: errorMessage,
      };
    }
  }

  async sendBatch(message: BatchEmailMessage): Promise<EmailResult[]> {
    const results: EmailResult[] = [];

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
