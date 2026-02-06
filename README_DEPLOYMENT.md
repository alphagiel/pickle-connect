# Pickle Connect - Deployment Guide

This document outlines the steps required to deploy Pickle Connect to the App Store (iOS) and Google Play Store (Android).

---

## Current Status

| Platform | Status | Last Build |
|----------|--------|------------|
| Android | **Ready for Upload** | `app-release.aab` (43.9MB) |
| iOS | Configuration Complete | Pending build |

---

## Completed Configuration

### App Identifiers
| Platform | Identifier |
|----------|------------|
| Android | `com.pickleconnect.app` |
| iOS | `com.pickleconnect.app` |

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

## Android Release Signing (COMPLETED)

### Keystore Details
| Property | Value |
|----------|-------|
| File | `android/app/pickle-connect-release.jks` |
| Alias | `pickle-connect` |
| Validity | 10,000 days (~27 years) |
| Algorithm | RSA 2048-bit |

### Configuration Files
- `android/key.properties` - Contains keystore credentials
- `android/app/build.gradle.kts` - Configured to use release signing

> **IMPORTANT:** The keystore file and `key.properties` are excluded from git.
> Back up `pickle-connect-release.jks` securely - if lost, you cannot update the app on Google Play.

### Keystore Certificate Info
```
CN=Alpha De Asis
OU=Development
O=Pickle Connect LLC
L=Clayton
ST=North Carolina
C=US
```

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

### Step 1: Access Play Console
Go to [Google Play Console](https://play.google.com/console)

### Step 2: Create App (if not done)
1. Click **Create app**
2. Enter app details:
   - App name: `Pickle Connect`
   - Default language: English (US)
   - App or Game: App
   - Free or Paid: Free
3. Accept declarations and create

### Step 3: Complete Dashboard Requirements
Before you can release, complete these sections:

**App access:**
- Indicate if the app requires login
- Provide test credentials if needed

**Ads:**
- Declare if app contains ads

**Content rating:**
- Complete the questionnaire
- Get age ratings for all regions

**Target audience:**
- Select target age groups
- Confirm compliance with policies

**News apps:**
- Declare if this is a news app

**Data safety:**
- Declare what data is collected
- Explain data usage and sharing

**Government apps:**
- Declare if this is a government app

### Step 4: Set Up Store Listing
Navigate to **Grow** → **Store presence** → **Main store listing**

**Required assets:**
| Asset | Specification |
|-------|---------------|
| App icon | 512 x 512 PNG (32-bit, alpha) |
| Feature graphic | 1024 x 500 PNG or JPG |
| Phone screenshots | Min 2, 16:9 or 9:16 aspect ratio |
| Short description | Max 80 characters |
| Full description | Max 4000 characters |

### Step 5: Upload the App Bundle
1. Go to **Release** → **Production** (or **Testing** → **Internal testing** first)
2. Click **Create new release**
3. Upload `build/app/outputs/bundle/release/app-release.aab`
4. Add release notes
5. Click **Review release**
6. Click **Start rollout to Production**

### Step 6: Submit for Review
- Review typically takes 1-3 days for new apps
- You'll receive email notification when approved

---

## iOS Deployment (Pending)

### Required Before iOS Build

#### 1. Fix Firebase Configuration
The current `GoogleService-Info.plist` has an incorrect bundle ID.

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select project: `pickle-connect-89f11`
3. Add iOS app with bundle ID: `com.pickleconnect.app`
4. Download new `GoogleService-Info.plist`
5. Replace `ios/Runner/GoogleService-Info.plist`

#### 2. Apple Developer Setup
1. **Register App ID**
   - Go to [Apple Developer Portal](https://developer.apple.com/account/resources/identifiers)
   - Register identifier: `com.pickleconnect.app`
   - Enable capabilities: Push Notifications, Associated Domains

2. **Create Provisioning Profiles**
   - Development profile for testing
   - Distribution profile for App Store

3. **APNs Certificate** (for push notifications)
   - Create in Apple Developer Portal
   - Upload to Firebase Console

#### 3. Build and Submit
```bash
flutter build ipa --release
```

Then use Xcode or Transporter to upload to App Store Connect.

---

## Pre-Submission Checklist

### Android
- [x] `google-services.json` with correct package name
- [x] Release keystore created and configured
- [x] Release App Bundle built successfully
- [ ] Tested release APK on physical device
- [ ] Privacy policy URL created and hosted
- [ ] Store listing complete (description, screenshots, graphics)
- [ ] Content rating questionnaire completed
- [ ] Data safety form completed

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

The app uses environment variables to control Firebase emulator usage:

```dart
// In main.dart - emulators only connect in debug mode
if (kDebugMode && useEmulators) {
  // Connect to local emulators
}
```

Release builds automatically skip emulator connections due to `kDebugMode` check.

### Java Version Requirement
Android builds require Java 17. This is configured in `android/gradle.properties`:
```properties
org.gradle.java.home=C:\\Program Files\\Java\\jdk-17.0.5
```

---

## Versioning

Update version in `pubspec.yaml` before each release:

```yaml
version: 1.0.0+1  # format: major.minor.patch+buildNumber
```

- Increment `buildNumber` for every upload to the stores
- Follow semantic versioning for version string
- Google Play and App Store track build numbers independently

---

## Troubleshooting

### Build Fails with Java Version Error
Ensure Java 17 is installed and `gradle.properties` has correct path:
```properties
org.gradle.java.home=C:\\Program Files\\Java\\jdk-17.0.5
```

### Keystore Not Found
Verify `key.properties` has correct path:
```properties
storeFile=pickle-connect-release.jks
```
The path is relative to `android/app/`.

### Firebase Configuration Issues
Ensure package name in `google-services.json` matches `applicationId` in `build.gradle.kts`:
```json
"package_name": "com.pickleconnect.app"
```

---

## Security Notes

**Files excluded from git (in `.gitignore`):**
- `android/key.properties`
- `android/**/*.jks`
- `android/**/*.keystore`
- `.env` files

**Backup these files securely:**
- `pickle-connect-release.jks` - Required for all future app updates
- `key.properties` - Contains keystore passwords

---

## Support

For issues with this deployment guide, contact the development team.
