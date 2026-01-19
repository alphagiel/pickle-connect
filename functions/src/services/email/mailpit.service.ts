import * as nodemailer from "nodemailer";
import {
  IEmailService,
  EmailMessage,
  BatchEmailMessage,
  EmailResult,
} from "./email-service.interface";

/**
 * Mailpit email service for local development
 * Connects to Mailpit SMTP server running in Docker
 */
export class MailpitService implements IEmailService {
  private transporter: nodemailer.Transporter;
  private from: string;

  constructor() {
    const host = process.env.MAILPIT_HOST || "localhost";
    const port = parseInt(process.env.MAILPIT_PORT || "1025", 10);
    const fromEmail = process.env.EMAIL_FROM || "noreply@pickleconnect.local";
    const fromName = process.env.EMAIL_FROM_NAME || "Pickle Connect";

    this.from = `${fromName} <${fromEmail}>`;

    this.transporter = nodemailer.createTransport({
      host,
      port,
      secure: false,
      ignoreTLS: true,
    });
  }

  async send(message: EmailMessage): Promise<EmailResult> {
    try {
      const info = await this.transporter.sendMail({
        from: this.from,
        to: message.to,
        subject: message.subject,
        html: message.html,
        text: message.text || this.htmlToText(message.html),
      });

      console.log(`[Mailpit] Email sent to ${message.to}: ${info.messageId}`);

      return {
        success: true,
        messageId: info.messageId,
      };
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : "Unknown error";
      console.error(`[Mailpit] Failed to send email to ${message.to}:`, errorMessage);

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
