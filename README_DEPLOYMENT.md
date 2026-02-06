# Pickle Connect - Deployment Guide

This document outlines the steps required to deploy Pickle Connect to the App Store (iOS) and Google Play Store (Android).

---

## Completed Configuration

The following items have been configured and are ready:

### App Identifiers
| Platform | Identifier |
|----------|------------|
| Android | `com.pickleconnect.app` |
| iOS | `com.pickleconnect.app` |

### Android (`android/`)
- [x] `applicationId` set to `com.pickleconnect.app`
- [x] `namespace` set to `com.pickleconnect.app`
- [x] `MainActivity.kt` moved to correct package path
- [x] App label set to "Pickle Connect"
- [x] Deep linking configured (`pickleconnect://` and `https://pickleconnect.app`)

### iOS (`ios/`)
- [x] Bundle identifier set to `com.pickleconnect.app`
- [x] Minimum deployment target set to iOS 13.0
- [x] Display name set to "Pickle Connect"
- [x] Deep linking configured (custom scheme + universal links)
- [x] App icons present (all required sizes)
- [x] Launch screen configured

---

## Required Before Submission

### 1. Firebase Configuration (Critical)

Download new config files from [Firebase Console](https://console.firebase.google.com/) with bundle ID `com.pickleconnect.app`:

**Android:**
```
Project Settings → Your Apps → Android → Download google-services.json
Place in: android/app/google-services.json
```

**iOS:**
```
Project Settings → Your Apps → iOS → Download GoogleService-Info.plist
Place in: ios/Runner/GoogleService-Info.plist
```

> **Note:** The existing GoogleService-Info.plist has an incorrect bundle ID from a different project and must be replaced.

---

### 2. Android Release Signing

Create a release keystore and configure signing:

**Generate Keystore:**
```bash
keytool -genkey -v -keystore pickle-connect-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias pickle-connect
```

**Create `android/key.properties`:**
```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=pickle-connect
storeFile=<path-to>/pickle-connect-release.jks
```

**Update `android/app/build.gradle.kts`:**
```kotlin
// Add before android block
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // ...
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

> **Important:** Add `key.properties` and `*.jks` to `.gitignore`

---

### 3. Privacy Policy

Both stores require a privacy policy URL.

**Create and host a privacy policy that covers:**
- Data collected (email, profile info, match history)
- How data is used
- Third-party services (Firebase)
- Data retention and deletion
- Contact information

**Suggested hosting options:**
- GitHub Pages
- Your website
- Notion (public page)

---

### 4. Apple Developer Setup

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

---

### 5. Google Play Console Setup

1. **Create App**
   - Go to [Google Play Console](https://play.google.com/console)
   - Create new app with package name `com.pickleconnect.app`

2. **App Signing**
   - Enroll in Google Play App Signing (recommended)
   - Upload your release keystore

3. **Store Listing**
   - App description
   - Screenshots (phone + tablet)
   - Feature graphic (1024x500)
   - App icon (512x512)

---

## Build Commands

### Development
```bash
flutter run
```

### Release Builds

**Android APK:**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**Android App Bundle (for Play Store):**
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

**iOS:**
```bash
flutter build ipa --release
# Output: build/ios/ipa/pickle_connect.ipa
```

---

## Pre-Submission Checklist

### Android
- [ ] `google-services.json` with correct package name
- [ ] Release keystore created and configured
- [ ] Tested release APK on physical device
- [ ] Privacy policy URL added to Play Console
- [ ] Store listing complete (description, screenshots, graphics)
- [ ] Content rating questionnaire completed
- [ ] Target API level meets Play Store requirements

### iOS
- [ ] `GoogleService-Info.plist` with correct bundle ID
- [ ] App ID registered in Apple Developer Portal
- [ ] Provisioning profiles created
- [ ] APNs certificate uploaded to Firebase
- [ ] Tested on physical iOS device
- [ ] Privacy policy URL added to App Store Connect
- [ ] App Store listing complete
- [ ] Screenshots for all required device sizes

### Both Platforms
- [ ] Firebase project configured for production
- [ ] Push notifications tested
- [ ] Deep linking tested
- [ ] All features tested in release mode
- [ ] No debug/emulator code in release builds

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

---

## Versioning

Update version in `pubspec.yaml` before each release:

```yaml
version: 1.0.0+1  # format: major.minor.patch+buildNumber
```

- Increment `buildNumber` for every upload
- Follow semantic versioning for version string

---

## Support

For issues with this deployment guide, contact the development team.
