# Pickle Connect - Deployment Guide

This document outlines the steps required to deploy Pickle Connect to the App Store (iOS) and Google Play Store (Android).

---

## Current Status

| Platform | Status | Last Updated |
|----------|--------|--------------|
| Android | **Awaiting Google Verification** | Feb 2026 |
| iOS | Configuration Complete | Pending build |

### Google Play Console Progress
- [x] Developer account created
- [x] App created in Play Console
- [x] App Bundle uploaded (9.8 MB)
- [x] Internal testing release configured
- [x] ID documents submitted
- [ ] Identity verification (under review - 2-5 days)
- [ ] Phone verification (waiting for ID approval)
- [ ] Store listing complete
- [ ] Production release

---

## App Identifiers

| Platform | Identifier |
|----------|------------|
| Android | `com.pickleconnect.app` |
| iOS | `com.pickleconnect.app` |

---

## Store Listing Content

### Short Description (80 characters max)
```
Find pickleball players, schedule matches, and track your rankings by skill.
```
(75 characters)

**Alternative options:**
- `Connect with pickleball players at your skill level. Find matches today!` (72 chars)
- `Match with local pickleball players and climb the leaderboard!` (62 chars)

### Full Description (4000 characters max)

```
Pickle Connect is the ultimate app for pickleball players looking to find opponents, schedule matches, and track their competitive journey.

FIND YOUR PERFECT MATCH
Browse match proposals from players in your skill bracket. Whether you're a beginner just learning the game or an advanced player seeking competitive matches, Pickle Connect matches you with players at your level.

SKILL-BASED MATCHMAKING
Players are organized into five skill brackets:
• Beginner (1.0 - 1.5)
• Novice (2.0 - 2.5)
• Intermediate (3.0 - 3.5)
• Advanced (4.0 - 4.5)
• Expert (5.0+)

This ensures every match is competitive and fun, no matter your experience level.

CREATE & ACCEPT MATCH PROPOSALS
• Post your own match proposals with location, date, and time
• Browse available matches filtered by skill level
• Accept proposals to connect with other players
• Manage your upcoming matches in one place

TRACK YOUR MATCHES
• View all your active and upcoming matches in "My Matches"
• Record match scores with best-of-3 game format
• Both players confirm scores for fair, accurate results
• Access your complete match history in "Completed"

CLIMB THE LEADERBOARD
• Compete for top rankings in your skill bracket
• Track wins, losses, and winning streaks
• See how you stack up against other players
• Medals for top 3 players in each bracket
• Rankings update automatically after each match

BUILD YOUR PLAYER PROFILE
• Set your display name and skill level
• Specify your preferred playing location
• Your profile determines which matches you see

WHY PICKLE CONNECT?
• Fair matchmaking based on skill level
• Easy scheduling and coordination
• Transparent scoring system
• Active community of players
• Track your improvement over time

Whether you're looking for a casual rally or intense competition, Pickle Connect helps you find the right opponent and grow your game.

Download now and start connecting with pickleball players in your area!
```
(1,847 characters)

### Release Notes (for internal testing)
```
Initial release of Pickle Connect!

Features:
• Create and browse match proposals
• Skill-based player matching (Beginner to Expert)
• Accept matches and coordinate with opponents
• Score tracking with best-of-3 format
• Seasonal leaderboards by skill bracket
• Player profiles with skill levels
```

---

## Required Store Assets

| Asset | Specification | Status |
|-------|---------------|--------|
| App icon | 512 x 512 PNG | Needed |
| Feature graphic | 1024 x 500 PNG/JPG | Needed |
| Phone screenshots | Min 2, 16:9 or 9:16 | Needed |
| Short description | 80 chars max | ✅ Ready (see above) |
| Full description | 4000 chars max | ✅ Ready (see above) |
| Privacy policy URL | Public URL | Needed |

### Screenshot Suggestions
Capture these screens from the app:
1. **Proposals list** - Show open match proposals
2. **Create proposal** - Match creation form
3. **Match details** - Accepted match with opponent info
4. **Standings/Leaderboard** - Rankings display
5. **Profile** - User profile with skill level

---

## Completed Configuration

### Android (`android/`) - COMPLETE
- [x] `applicationId` set to `com.pickleconnect.app`
- [x] `namespace` set to `com.pickleconnect.app`
- [x] `MainActivity.kt` moved to correct package path
- [x] App label set to "Pickle Connect"
- [x] Deep linking configured (`pickleconnect://` and `https://pickleconnect.app`)
- [x] `google-services.json` configured with correct package name
- [x] Release keystore created (10,000 days validity)
- [x] `key.properties` configured
- [x] `build.gradle.kts` configured for release signing
- [x] Java 17 configured in `gradle.properties`
- [x] Release App Bundle built successfully
- [x] AAB uploaded to Play Console

### iOS (`ios/`) - Configuration Complete
- [x] Bundle identifier set to `com.pickleconnect.app`
- [x] Minimum deployment target set to iOS 13.0
- [x] Display name set to "Pickle Connect"
- [x] Deep linking configured (custom scheme + universal links)
- [x] App icons present (all required sizes)
- [x] Launch screen configured
- [ ] `GoogleService-Info.plist` needs regeneration with correct bundle ID
- [ ] Provisioning profiles needed
- [ ] Release build pending

---

## Android Release Signing

### Keystore Details
| Property | Value |
|----------|-------|
| File | `android/app/pickle-connect-release.jks` |
| Alias | `pickle-connect` |
| Validity | 10,000 days (~27 years) |
| Algorithm | RSA 2048-bit |

### Keystore Certificate Info
```
CN=Alpha De Asis
OU=Development
O=Pickle Connect LLC
L=Clayton
ST=North Carolina
C=US
```

> **IMPORTANT:** The keystore file and `key.properties` are excluded from git.
> Back up `pickle-connect-release.jks` securely - if lost, you cannot update the app on Google Play.

---

## Build Commands

### Development
```bash
flutter run
```

### Release Builds

**Android App Bundle (for Play Store):**
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

**Android APK (for direct installation):**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**iOS:**
```bash
flutter build ipa --release
# Output: build/ios/ipa/pickle_connect.ipa
```

---

## Google Play Console Submission

### Current Status: Awaiting Verification

**Completed:**
1. ✅ Developer account created (`deasisalphagiel@gmail.com`)
2. ✅ App created: "Pickle Connect"
3. ✅ App Bundle uploaded (9.8 MB)
4. ✅ Internal testing release configured
5. ✅ ID documents submitted

**Pending:**
1. ⏳ Identity verification (2-5 business days)
2. ⏳ Phone verification (after ID approved)
3. ⏳ Complete store listing
4. ⏳ Submit for production review

### After Verification Approved

1. **Complete phone verification** via Play Console
2. **Add store listing assets:**
   - Upload app icon (512x512)
   - Upload feature graphic (1024x500)
   - Upload screenshots (min 2)
   - Add short description (copy from above)
   - Add full description (copy from above)
   - Add privacy policy URL
3. **Complete content rating** questionnaire
4. **Complete data safety** form
5. **Promote to production** or start with internal testing

---

## Data Safety Form Answers

For the Google Play data safety questionnaire:

| Question | Answer |
|----------|--------|
| Does your app collect or share user data? | Yes |
| **Data collected:** | |
| - Email address | Yes (for account) |
| - Name | Yes (display name) |
| - User IDs | Yes (Firebase auth) |
| - App activity | Yes (match history) |
| **Data shared with third parties?** | No |
| **Data encrypted in transit?** | Yes (HTTPS/TLS) |
| **Can users request data deletion?** | Yes |

---

## iOS Deployment (In Progress)

### Quick Start Checklist

- [ ] Add iOS app to Firebase Console
- [ ] Download and replace `GoogleService-Info.plist`
- [ ] Register App ID in Apple Developer Portal
- [ ] Create Distribution provisioning profile
- [ ] Build release IPA
- [ ] Upload to App Store Connect
- [ ] Complete App Store listing

---

### Step 1: Firebase Configuration (Do First)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select project: `pickle-connect-89f11`
3. Click **Add app** → Select **iOS**
4. Enter Bundle ID: `com.pickleconnect.app`
5. App nickname: `Pickle Connect iOS` (optional)
6. Skip the App Store ID for now
7. Click **Register app**
8. Download `GoogleService-Info.plist`
9. Replace the file at: `ios/Runner/GoogleService-Info.plist`

---

### Step 2: Apple Developer Portal

Go to [Apple Developer Portal](https://developer.apple.com/account/resources/identifiers)

#### Register App ID
1. **Identifiers** → Click **+** to add new
2. Select **App IDs** → Continue
3. Select **App** → Continue
4. Description: `Pickle Connect`
5. Bundle ID (Explicit): `com.pickleconnect.app`
6. Capabilities: Enable **Push Notifications** if needed
7. Click **Continue** → **Register**

#### Create Provisioning Profile
1. **Profiles** → Click **+** to add new
2. Select **App Store Connect** (under Distribution)
3. Select App ID: `com.pickleconnect.app`
4. Select your Distribution certificate
5. Name: `Pickle Connect Distribution`
6. Download and install the profile

---

### Step 3: Build on Mac

```bash
# Navigate to project
cd /path/to/pickle-connect

# Clean and get dependencies
flutter clean
flutter pub get

# Install CocoaPods dependencies
cd ios && pod install && cd ..

# Build release IPA
flutter build ipa --release
```

Output: `build/ios/ipa/pickle_connect.ipa`

---

### Step 4: Upload to App Store Connect

**Option A: Using Xcode**
1. Open `ios/Runner.xcworkspace` in Xcode
2. Product → Archive
3. Distribute App → App Store Connect

**Option B: Using Transporter**
1. Download Transporter from Mac App Store
2. Sign in with Apple ID
3. Drag and drop the `.ipa` file
4. Click Deliver

**Option C: Using command line**
```bash
xcrun altool --upload-app --type ios --file build/ios/ipa/pickle_connect.ipa --apiKey YOUR_KEY --apiIssuer YOUR_ISSUER
```

---

### Step 5: App Store Connect Setup

Go to [App Store Connect](https://appstoreconnect.apple.com/)

1. **My Apps** → Click **+** → **New App**
2. Fill in details:
   - Platform: iOS
   - Name: `Pickle Connect`
   - Primary Language: English (U.S.)
   - Bundle ID: `com.pickleconnect.app`
   - SKU: `pickleconnect-ios-001`
3. Create the app

#### Required Information
| Field | Value |
|-------|-------|
| Privacy Policy URL | (your privacy policy URL) |
| Category | Sports |
| Age Rating | Complete questionnaire |
| Copyright | 2026 Pickle Connect LLC |

#### Screenshots Required
| Device | Sizes |
|--------|-------|
| iPhone 6.7" | 1290 x 2796 (iPhone 15 Pro Max) |
| iPhone 6.5" | 1284 x 2778 (iPhone 14 Plus) |
| iPhone 5.5" | 1242 x 2208 (iPhone 8 Plus) |
| iPad 12.9" | 2048 x 2732 (iPad Pro) |

#### App Description
Use the same descriptions from the Android store listing (see "Store Listing Content" section above).

---

### Troubleshooting iOS Build

#### Pod Install Fails
```bash
cd ios
pod deintegrate
pod cache clean --all
pod install
```

#### Code Signing Issues
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner target → Signing & Capabilities
3. Select your Team
4. Ensure provisioning profile is correct

#### GoogleService-Info.plist Issues
Ensure the `BUNDLE_ID` in the plist matches `com.pickleconnect.app`:
```bash
grep BUNDLE_ID ios/Runner/GoogleService-Info.plist
```

---

## Pre-Submission Checklist

### Android
- [x] `google-services.json` with correct package name
- [x] Release keystore created and configured
- [x] Release App Bundle built successfully
- [x] AAB uploaded to Play Console
- [x] Internal testing release created
- [ ] Identity verification approved
- [ ] Phone verification completed
- [ ] Privacy policy URL created and hosted
- [ ] Store listing complete (description, screenshots, graphics)
- [ ] Content rating questionnaire completed
- [ ] Data safety form completed
- [ ] Production release submitted

### iOS
- [ ] `GoogleService-Info.plist` with correct bundle ID
- [ ] App ID registered in Apple Developer Portal
- [ ] Provisioning profiles created
- [ ] APNs certificate uploaded to Firebase
- [ ] Release IPA built successfully
- [ ] Tested on physical iOS device
- [ ] Privacy policy URL added to App Store Connect
- [ ] App Store listing complete
- [ ] Screenshots for all required device sizes

### Both Platforms
- [ ] Privacy policy hosted at public URL
- [ ] Firebase project configured for production
- [ ] Push notifications tested
- [ ] Deep linking tested
- [ ] All features tested in release mode

---

## Environment Configuration

### Firebase
Release builds automatically skip emulator connections due to `kDebugMode` check in `main.dart`.

### Java Version
Android builds require Java 17, configured in `android/gradle.properties`:
```properties
org.gradle.java.home=C:\\Program Files\\Java\\jdk-17.0.5
```

---

## Versioning

Update version in `pubspec.yaml` before each release:

```yaml
version: 1.0.0+1  # format: major.minor.patch+buildNumber
```

- Increment `buildNumber` for every upload
- Follow semantic versioning for version string

---

## Troubleshooting

### Build Fails with Java Version Error
```properties
org.gradle.java.home=C:\\Program Files\\Java\\jdk-17.0.5
```

### Keystore Not Found
```properties
storeFile=pickle-connect-release.jks
```
Path is relative to `android/app/`.

### Firebase Configuration Issues
Ensure package name matches in `google-services.json`:
```json
"package_name": "com.pickleconnect.app"
```

---

## Security Notes

**Files excluded from git:**
- `android/key.properties`
- `android/**/*.jks`
- `android/**/*.keystore`
- `.env` files

**Backup securely:**
- `pickle-connect-release.jks` - Required for all future updates
- `key.properties` - Contains keystore passwords

---

## Support

For issues with this deployment guide, contact the development team.
