import * as admin from "firebase-admin";
import { onCall, HttpsError } from "firebase-functions/v2/https";

const db = admin.firestore();

interface MigrationResult {
  proposalsUpdated: number;
  proposalsSkipped: number;
  errors: string[];
}

/**
 * Adds matchType: 'singles' and playerIds: [] to all existing proposal documents
 * that are missing these fields. This ensures backward compatibility after
 * introducing the doubles feature.
 *
 * Callable by admin users only.
 */
export const migrateProposalsDoublesFields = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Must be authenticated to run migrations");
  }

  const userDoc = await db.collection("users").doc(request.auth.uid).get();
  const userData = userDoc.data();

  if (!userData || userData.role !== "admin") {
    throw new HttpsError("permission-denied", "Only admins can run migrations");
  }

  const result: MigrationResult = {
    proposalsUpdated: 0,
    proposalsSkipped: 0,
    errors: [],
  };

  console.log("Starting proposals doubles fields migration...");
  const proposalsSnapshot = await db.collection("proposals").get();

  for (const doc of proposalsSnapshot.docs) {
    try {
      const data = doc.data();
      const updates: Record<string, unknown> = {};

      // Add matchType if missing
      if (!data.matchType) {
        updates.matchType = "singles";
      }

      // Add playerIds if missing
      if (!data.playerIds) {
        updates.playerIds = [];
      }

      // Add doublesPlayers if missing
      if (!data.doublesPlayers) {
        updates.doublesPlayers = [];
      }

      // Add openSlots if missing
      if (data.openSlots === undefined) {
        updates.openSlots = 0;
      }

      if (Object.keys(updates).length > 0) {
        await doc.ref.update(updates);
        result.proposalsUpdated++;
        console.log(`Migrated proposal ${doc.id}: added ${Object.keys(updates).join(", ")}`);
      } else {
        result.proposalsSkipped++;
      }
    } catch (error) {
      const errorMsg = `Error migrating proposal ${doc.id}: ${error}`;
      console.error(errorMsg);
      result.errors.push(errorMsg);
    }
  }

  console.log(
    `Migration complete. Updated: ${result.proposalsUpdated}, Skipped: ${result.proposalsSkipped}, Errors: ${result.errors.length}`
  );

  return result;
});

/**
 * Dry run version - shows what would be migrated without making changes
 */
export const migrateProposalsDoublesFieldsDryRun = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Must be authenticated to run migrations");
  }

  const userDoc = await db.collection("users").doc(request.auth.uid).get();
  const userData = userDoc.data();

  if (!userData || userData.role !== "admin") {
    throw new HttpsError("permission-denied", "Only admins can run migrations");
  }

  const proposalsToMigrate: Array<{ id: string; missingFields: string[] }> = [];

  const proposalsSnapshot = await db.collection("proposals").get();
  for (const doc of proposalsSnapshot.docs) {
    const data = doc.data();
    const missingFields: string[] = [];

    if (!data.matchType) missingFields.push("matchType");
    if (!data.playerIds) missingFields.push("playerIds");
    if (!data.doublesPlayers) missingFields.push("doublesPlayers");
    if (data.openSlots === undefined) missingFields.push("openSlots");

    if (missingFields.length > 0) {
      proposalsToMigrate.push({ id: doc.id, missingFields });
    }
  }

  return {
    proposalsToMigrate,
    summary: {
      totalProposals: proposalsSnapshot.size,
      proposalsNeedingMigration: proposalsToMigrate.length,
      proposalsAlreadyMigrated: proposalsSnapshot.size - proposalsToMigrate.length,
    },
  };
});
