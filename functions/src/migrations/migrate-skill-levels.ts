import * as admin from "firebase-admin";
import { onCall, HttpsError } from "firebase-functions/v2/https";

const db = admin.firestore();

// Valid skill levels in the new 5-tier system
const VALID_SKILL_LEVELS = ["Beginner", "Novice", "Intermediate", "Advanced", "Expert"];

// Mapping from old values to new values
const SKILL_LEVEL_MIGRATION_MAP: Record<string, string> = {
  // Old 3-tier system
  "Advanced+": "Advanced",
  "advancedPlus": "Advanced",

  // Handle display name format (if accidentally stored)
  "Beginner (1.0-2.0)": "Beginner",
  "Novice (2.5)": "Novice",
  "Intermediate (3.0-3.5)": "Intermediate",
  "Advanced (4.0-4.5)": "Advanced",
  "Expert (5.0+)": "Expert",
};

interface MigrationResult {
  usersUpdated: number;
  proposalsUpdated: number;
  errors: string[];
}

/**
 * Migrates skill levels to the new 5-tier system.
 * - Converts old "Advanced+" to "Advanced"
 * - Converts skillLevels array to single skillLevel
 * - Normalizes any display name formats to JSON values
 *
 * Callable by admin users only.
 */
export const migrateSkillLevels = onCall(async (request) => {
  // Check if user is authenticated
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Must be authenticated to run migrations");
  }

  // Check if user is admin
  const userDoc = await db.collection("users").doc(request.auth.uid).get();
  const userData = userDoc.data();

  if (!userData || userData.role !== "admin") {
    throw new HttpsError("permission-denied", "Only admins can run migrations");
  }

  const result: MigrationResult = {
    usersUpdated: 0,
    proposalsUpdated: 0,
    errors: [],
  };

  // Migrate users
  console.log("Starting user skill level migration...");
  const usersSnapshot = await db.collection("users").get();

  for (const doc of usersSnapshot.docs) {
    try {
      const data = doc.data();
      const currentLevel = data.skillLevel;

      if (!currentLevel) {
        // User has no skill level - set to Intermediate as default
        await doc.ref.update({ skillLevel: "Intermediate" });
        result.usersUpdated++;
        console.log(`Set default skill level for user ${doc.id}`);
        continue;
      }

      // Check if migration needed
      if (SKILL_LEVEL_MIGRATION_MAP[currentLevel]) {
        const newLevel = SKILL_LEVEL_MIGRATION_MAP[currentLevel];
        await doc.ref.update({ skillLevel: newLevel });
        result.usersUpdated++;
        console.log(`Migrated user ${doc.id}: ${currentLevel} -> ${newLevel}`);
      } else if (!VALID_SKILL_LEVELS.includes(currentLevel)) {
        // Unknown skill level - log warning and set to Intermediate
        result.errors.push(`User ${doc.id} has unknown skill level: ${currentLevel}`);
        await doc.ref.update({ skillLevel: "Intermediate" });
        result.usersUpdated++;
      }
    } catch (error) {
      const errorMsg = `Error migrating user ${doc.id}: ${error}`;
      console.error(errorMsg);
      result.errors.push(errorMsg);
    }
  }

  // Migrate proposals
  console.log("Starting proposal skill level migration...");
  const proposalsSnapshot = await db.collection("proposals").get();

  for (const doc of proposalsSnapshot.docs) {
    try {
      const data = doc.data();
      const updates: Record<string, unknown> = {};

      // Handle old skillLevels array format
      if (data.skillLevels && !data.skillLevel) {
        const skillLevels = data.skillLevels as string[];
        if (skillLevels.length > 0) {
          let newLevel = skillLevels[0];
          // Also apply migration mapping
          if (SKILL_LEVEL_MIGRATION_MAP[newLevel]) {
            newLevel = SKILL_LEVEL_MIGRATION_MAP[newLevel];
          }
          updates.skillLevel = newLevel;
          console.log(`Migrated proposal ${doc.id} from skillLevels array: ${skillLevels} -> ${newLevel}`);
        }
      }

      // Handle old skill level values
      const currentLevel = data.skillLevel;
      if (currentLevel && SKILL_LEVEL_MIGRATION_MAP[currentLevel]) {
        updates.skillLevel = SKILL_LEVEL_MIGRATION_MAP[currentLevel];
        console.log(`Migrated proposal ${doc.id}: ${currentLevel} -> ${updates.skillLevel}`);
      }

      // Check for invalid skill levels
      const finalLevel = updates.skillLevel || currentLevel;
      if (finalLevel && !VALID_SKILL_LEVELS.includes(finalLevel as string)) {
        result.errors.push(`Proposal ${doc.id} has unknown skill level: ${finalLevel}`);
        updates.skillLevel = "Intermediate"; // Default fallback
      }

      // Apply updates if any
      if (Object.keys(updates).length > 0) {
        await doc.ref.update(updates);
        result.proposalsUpdated++;
      }
    } catch (error) {
      const errorMsg = `Error migrating proposal ${doc.id}: ${error}`;
      console.error(errorMsg);
      result.errors.push(errorMsg);
    }
  }

  console.log(`Migration complete. Users: ${result.usersUpdated}, Proposals: ${result.proposalsUpdated}`);

  return result;
});

/**
 * Dry run version - shows what would be migrated without making changes
 */
export const migrateSkillLevelsDryRun = onCall(async (request) => {
  // Check if user is authenticated
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Must be authenticated to run migrations");
  }

  // Check if user is admin
  const userDoc = await db.collection("users").doc(request.auth.uid).get();
  const userData = userDoc.data();

  if (!userData || userData.role !== "admin") {
    throw new HttpsError("permission-denied", "Only admins can run migrations");
  }

  const usersToMigrate: Array<{id: string; from: string; to: string}> = [];
  const proposalsToMigrate: Array<{id: string; from: string; to: string}> = [];
  const issues: string[] = [];

  // Check users
  const usersSnapshot = await db.collection("users").get();
  for (const doc of usersSnapshot.docs) {
    const data = doc.data();
    const currentLevel = data.skillLevel;

    if (!currentLevel) {
      usersToMigrate.push({ id: doc.id, from: "(none)", to: "Intermediate" });
    } else if (SKILL_LEVEL_MIGRATION_MAP[currentLevel]) {
      usersToMigrate.push({
        id: doc.id,
        from: currentLevel,
        to: SKILL_LEVEL_MIGRATION_MAP[currentLevel]
      });
    } else if (!VALID_SKILL_LEVELS.includes(currentLevel)) {
      issues.push(`User ${doc.id} has unknown skill level: ${currentLevel}`);
    }
  }

  // Check proposals
  const proposalsSnapshot = await db.collection("proposals").get();
  for (const doc of proposalsSnapshot.docs) {
    const data = doc.data();

    if (data.skillLevels && !data.skillLevel) {
      const skillLevels = data.skillLevels as string[];
      if (skillLevels.length > 0) {
        let newLevel = skillLevels[0];
        if (SKILL_LEVEL_MIGRATION_MAP[newLevel]) {
          newLevel = SKILL_LEVEL_MIGRATION_MAP[newLevel];
        }
        proposalsToMigrate.push({
          id: doc.id,
          from: `skillLevels: [${skillLevels.join(", ")}]`,
          to: newLevel
        });
      }
    } else if (data.skillLevel && SKILL_LEVEL_MIGRATION_MAP[data.skillLevel]) {
      proposalsToMigrate.push({
        id: doc.id,
        from: data.skillLevel,
        to: SKILL_LEVEL_MIGRATION_MAP[data.skillLevel]
      });
    } else if (data.skillLevel && !VALID_SKILL_LEVELS.includes(data.skillLevel)) {
      issues.push(`Proposal ${doc.id} has unknown skill level: ${data.skillLevel}`);
    }
  }

  return {
    usersToMigrate,
    proposalsToMigrate,
    issues,
    summary: {
      usersNeedingMigration: usersToMigrate.length,
      proposalsNeedingMigration: proposalsToMigrate.length,
      issuesFound: issues.length,
    },
  };
});
