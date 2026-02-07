# Pickle Connect - Deployment Guide

Bundle ID (both platforms): `com.pickleconnect.app`

| Platform | Status | Last Updated |
|----------|--------|--------------|
| Android | Awaiting Google Verification | Feb 2026 |
| iOS | Release IPA built | Feb 2026 |

---

## Build Commands

```bash
# Dev
flutter run

# Android (Play Store)
flutter build appbundle --release
# -> build/app/outputs/bundle/release/app-release.aab

# Android (direct install)
flutter build apk --release
# -> build/app/outputs/flutter-apk/app-release.apk

# iOS
flutter build ipa --release
# -> build/ios/ipa/pickle_connect.ipa
```

---

## Android Deployment

### What's Done
- App created in Play Console
- App Bundle uploaded (9.8 MB)
- Internal testing release configured
- ID documents submitted
- Release keystore created and configured
- `google-services.json` set up

### Still Pending
- Identity verification (2-5 business days)
- Phone verification (after ID approved)
- Store listing (screenshots, descriptions, graphics)
- Content rating questionnaire
- Data safety form
- Production release

### After Google Approves Verification
1. Complete phone verification in Play Console
2. Upload store assets (icon 512x512, feature graphic 1024x500, min 2 screenshots)
3. Add descriptions (see Store Listing section below)
4. Add privacy policy URL
5. Fill out content rating + data safety forms
6. Promote to production or start with internal testing

### Release Signing

| Property | Value |
|----------|-------|
| Keystore | `android/app/pickle-connect-release.jks` |
| Alias | `pickle-connect` |
| Validity | ~27 years |

Certificate:
```
CN=Alpha De Asis, OU=Development, O=Pickle Connect LLC, L=Clayton, ST=North Carolina, C=US
```

> If you lose `pickle-connect-release.jks`, you can never update this app on Google Play. Back it up.

### Data Safety Form Answers

| Question | Answer |
|----------|--------|
| Collects user data? | Yes |
| Email address | Yes (account) |
| Name | Yes (display name) |
| User IDs | Yes (Firebase auth) |
| App activity | Yes (match history) |
| Shared with third parties? | No |
| Encrypted in transit? | Yes (HTTPS/TLS) |
| Users can request deletion? | Yes |

---

## iOS Deployment

### What's Done
- Bundle identifier set
- Display name set to "Pickle Connect"
- Deep linking configured
- Release IPA built successfully (36.5MB)
- Firebase SDK 12.8.0 with iOS 16.0 deployment target
- Podfile using `use_frameworks! :linkage => :static`

### Still Pending
- Register App ID in Apple Developer Portal
- Create Distribution provisioning profile
- Upload to App Store Connect
- Complete App Store listing

### Step by Step

**1. Firebase Setup**
1. Go to Firebase Console -> project `pickle-connect-89f11`
2. Add app -> iOS -> Bundle ID: `com.pickleconnect.app`
3. Download `GoogleService-Info.plist`
4. Replace `ios/Runner/GoogleService-Info.plist`

**2. Apple Developer Portal**
1. Identifiers -> + -> App IDs -> App
2. Bundle ID: `com.pickleconnect.app`, enable Push Notifications
3. Profiles -> + -> App Store Connect (Distribution)
4. Select App ID, select your cert, name it, download it

**3. Build**
```bash
flutter clean && flutter pub get
cd ios && pod install && cd ..
flutter build ipa --release
```

**4. Upload**
- Xcode: Open `ios/Runner.xcworkspace` -> Product -> Archive -> Distribute
- Transporter: Drag and drop the `.ipa` file
- CLI: `xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey YOUR_KEY --apiIssuer YOUR_ISSUER`

**5. App Store Connect**
1. My Apps -> + -> New App
2. Name: `Pickle Connect`, Bundle ID: `com.pickleconnect.app`, SKU: `pickleconnect-ios-001`
3. Category: Sports, Copyright: 2026 Pickle Connect LLC
4. Add privacy policy URL, screenshots, descriptions

Screenshots needed:
| Device | Size |
|--------|------|
| iPhone 6.7" | 1290 x 2796 |
| iPhone 6.5" | 1284 x 2778 |
| iPhone 5.5" | 1242 x 2208 |
| iPad 12.9" | 2048 x 2732 |

---

## What to Watch Out For

These are real problems we hit during deployment. Save yourself the headache.

### Firebase SDK + Xcode version mismatch

This was the big one. Firebase SDK 10.25.0 does NOT build on Xcode 16+ (including Xcode 26.x). You'll get three separate build errors that all look different but have the same root cause: old Firebase.

**Error 1: `unsupported option '-G' for target 'arm64-apple-ios'`**
- Comes from BoringSSL-GRPC 0.0.32
- The pod puts `-GCC_WARN_INHIBIT_ALL_WARNINGS` in per-file compiler flags
- Newer clang reads the `-G` prefix as a separate flag and rejects it
- You can patch it in the Podfile post_install, but upgrading Firebase is the real fix

**Error 2: `A template argument list is expected after a name prefixed by the template keyword`**
- Comes from gRPC-Core and gRPC-C++ 1.62.5 in `basic_seq.h` line 102
- Stricter C++ compiler in new Xcode rejects `Traits::template CallSeqFactory(...)` without `<>`
- Exists in BOTH `gRPC-Core` and `gRPC-C++` pods (easy to miss the second one)
- Again, patchable but upgrading Firebase is cleaner

**Error 3: `Include of non-modular header inside framework module 'firebase_messaging'`**
- Comes from firebase_messaging 14.9.4 doing `#import <Firebase/Firebase.h>`
- Setting `CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES = YES` does NOT fix it on Xcode 26.x
- Switching to `use_frameworks! :linkage => :static` alone does NOT fix it either
- Only fix is upgrading firebase_messaging to 16.x+

**The fix for all three:** Upgrade Firebase packages together.

| Package | Old (broken) | New (working) |
|---------|-------------|---------------|
| firebase_core | ^2.24.2 | ^4.4.0 |
| firebase_auth | ^4.15.3 | ^6.1.4 |
| cloud_firestore | ^4.13.6 | ^6.1.2 |
| cloud_functions | ^4.5.8 | ^6.0.6 |
| firebase_messaging | ^14.7.10 | ^16.1.1 |

This pulls in Firebase iOS SDK 12.8.0 with BoringSSL-GRPC 0.0.37 and gRPC 1.69.0, which all build cleanly.

### iOS deployment target must be 16.0+

Firebase SDK 12.x requires iOS 16.0 minimum. You need to update it in three places or CocoaPods will fail:

1. `ios/Podfile` line 2: `platform :ios, '16.0'`
2. `ios/Podfile` post_install: `config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'`
3. `ios/Runner.xcodeproj/project.pbxproj`: All `IPHONEOS_DEPLOYMENT_TARGET` entries

### Podfile needs static linkage

Use `use_frameworks! :linkage => :static` in the Podfile. Firebase with dynamic frameworks causes header resolution problems.

### Android needs Java 17

Set in `android/gradle.properties`:
```properties
org.gradle.java.home=/path/to/jdk-17
```

### When pod install acts weird
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
```

If that doesn't work:
```bash
pod cache clean --all
pod deintegrate
pod install
```

### Keystore and secrets are not in git

These files are gitignored and must be backed up separately:
- `android/key.properties` (keystore passwords)
- `android/app/pickle-connect-release.jks` (signing key)
- `.env` (environment variables)

---

## Store Listing Content

### Short Description (80 chars max)
```
Find pickleball players, schedule matches, and track your rankings by skill.
```

### Full Description
```
Pickle Connect is the ultimate app for pickleball players looking to find opponents, schedule matches, and track their competitive journey.

FIND YOUR PERFECT MATCH
Browse match proposals from players in your skill bracket. Whether you're a beginner just learning the game or an advanced player seeking competitive matches, Pickle Connect matches you with players at your level.

SKILL-BASED MATCHMAKING
Players are organized into five skill brackets:
- Beginner (1.0 - 1.5)
- Novice (2.0 - 2.5)
- Intermediate (3.0 - 3.5)
- Advanced (4.0 - 4.5)
- Expert (5.0+)

CREATE & ACCEPT MATCH PROPOSALS
- Post your own match proposals with location, date, and time
- Browse available matches filtered by skill level
- Accept proposals to connect with other players

TRACK YOUR MATCHES
- Record match scores with best-of-3 game format
- Both players confirm scores for fair results
- Access your complete match history

CLIMB THE LEADERBOARD
- Compete for top rankings in your skill bracket
- Track wins, losses, and winning streaks
- Medals for top 3 players in each bracket

Download now and start connecting with pickleball players in your area!
```

### Required Assets

| Asset | Spec | Status |
|-------|------|--------|
| App icon | 512 x 512 PNG | Needed |
| Feature graphic | 1024 x 500 PNG/JPG | Needed |
| Phone screenshots | Min 2, 16:9 or 9:16 | Needed |
| Privacy policy URL | Public URL | Needed |

Good screenshots to capture: Proposals list, Create proposal, Match details, Leaderboard, Profile.

---

## Pre-Submission Checklist

### Android
- [x] `google-services.json` with correct package name
- [x] Release keystore created and configured
- [x] Release App Bundle built and uploaded
- [x] Internal testing release created
- [ ] Identity + phone verification approved
- [ ] Privacy policy URL
- [ ] Store listing complete
- [ ] Content rating + data safety forms
- [ ] Production release submitted

### iOS
- [x] Release IPA built successfully
- [ ] `GoogleService-Info.plist` with correct bundle ID
- [ ] App ID registered in Apple Developer Portal
- [ ] Provisioning profiles created
- [ ] Uploaded to App Store Connect
- [ ] App Store listing complete
- [ ] Screenshots for all device sizes

### Both
- [ ] Privacy policy hosted at public URL
- [ ] Push notifications tested
- [ ] Deep linking tested
- [ ] All features tested in release mode

---

## Versioning

In `pubspec.yaml`:
```yaml
version: 1.0.0+1  # major.minor.patch+buildNumber
```
Bump `buildNumber` for every upload. Both stores reject duplicate build numbers.
