/**
 * Email message structure
 */
export interface EmailMessage {
  to: string;
  subject: string;
  html: string;
  text?: string;
}

/**
 * Batch email message with multiple recipients
 */
export interface BatchEmailMessage {
  to: string[];
  subject: string;
  html: string;
  text?: string;
}

/**
 * Result of sending an email
 */
export interface EmailResult {
  success: boolean;
  messageId?: string;
  error?: string;
}

/**
 * Email service interface - abstracts email sending
 */
export interface IEmailService {
  /**
   * Send a single email
   */
  send(message: EmailMessage): Promise<EmailResult>;

  /**
   * Send emails to multiple recipients (each receives individual email)
   */
  sendBatch(message: BatchEmailMessage): Promise<EmailResult[]>;
}
