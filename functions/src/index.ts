import * as admin from "firebase-admin";

// Initialize Firebase Admin SDK
admin.initializeApp();

// Export all triggers
export { onUserCreated, onUserDeleted, onProposalCreated, onProposalUpdated, onProposalDeleted } from "./triggers";

// Export callable functions
export { requestPasswordReset, confirmPasswordReset } from "./callable";

// Export HTTP endpoints
export { resetPasswordHttp } from "./http/reset-password";

// Export migration functions (admin only)
export { migrateSkillLevels, migrateSkillLevelsDryRun, migrateProposalsDoublesFields, migrateProposalsDoublesFieldsDryRun } from "./migrations";
