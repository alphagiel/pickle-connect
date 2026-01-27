import * as admin from "firebase-admin";

// Initialize Firebase Admin SDK
admin.initializeApp();

// Export all triggers
export { onUserCreated, onProposalCreated, onProposalUpdated, onProposalDeleted } from "./triggers";
