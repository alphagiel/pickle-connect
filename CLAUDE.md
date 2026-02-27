# Claude Development Commands

This file contains helpful commands for Claude when working on the Pickle Connect project.

## Quick Development Commands

### Build and Test
```bash
# Install dependencies
flutter pub get

# Generate code
flutter packages pub run build_runner build --delete-conflicting-outputs

# Analyze code
flutter analyze

# Run tests
flutter test
```

### Running the App

```bash
# List all connected/available devices
flutter devices

# Run on a specific device (use device ID from flutter devices)
flutter run -d <device-id>
```

**Device examples:**
```bash
# iPad Simulator (boot first if needed: xcrun simctl boot <simulator-id>)
flutter run -d <simulator-id>

# Physical iPad via USB/wireless
flutter run -d 00008112-00196156118BC01E

# Chrome (web) — NOTE: Firebase web config is a placeholder, Firestore/Auth won't work
flutter run -d chrome

# macOS desktop
flutter run -d macos
```

**Firebase Emulators vs Production:**

By default, debug mode connects to **local Firebase Emulators** (`USE_EMULATORS=true`). To test against **production Firebase**, pass the flag:

```bash
# Run with production Firebase (required for testing real data, emails, zones, etc.)
flutter run -d <device-id> --dart-define=USE_EMULATORS=false

# Run with local emulators (default in debug mode)
flutter run -d <device-id>
```

**Simulator management:**
```bash
# List available simulators
xcrun simctl list devices available | grep -i ipad

# Boot a simulator
xcrun simctl boot <simulator-id>

# Check which simulators are running
xcrun simctl list devices booted

# Shutdown a simulator
xcrun simctl shutdown <simulator-id>
```

### Build IPA for App Store
```bash
flutter clean && flutter pub get
flutter build ipa --release
# Upload build/ios/ipa/*.ipa via Apple Transporter app
```

### Linting and Formatting
```bash
# Check for linting issues
flutter analyze

# Format code
dart format lib/ test/

# Check for outdated packages
flutter pub outdated
```

### Firebase/Database
```bash
# Seed test users
dart scripts/seed_users.dart

# Check Flutter doctor
flutter doctor
```

### Development Notes
- Always run code generation after modifying models with `@freezed`
- Use `ref.invalidate(provider)` to refresh cached data
- Environment variables are stored in `.env` file
- Firebase configuration uses flutter_dotenv

### Common Issues
1. **Build errors**: Run `flutter clean && flutter pub get`
2. **Generated files**: Run build_runner with `--delete-conflicting-outputs`
3. **State not updating**: Check if provider is properly watched with `ref.watch()`

### Project Priorities
1. ✅ Match proposal and challenge system
2. ✅ Tennis scoring system
3. ✅ Real-time player search and filtering
4. 🔄 Seasonal ladder rankings with filters
5. ⏳ Tournament registration system
6. ⏳ Court booking system enhancement
7. ⏳ Push notifications

### TODO: Custom Email Domain Setup
Currently sending production emails from `onboarding@resend.dev` (Resend default).
To send from a branded address (e.g. `noreply@yourdomain.com`):
1. Buy a domain you own (e.g. `pickleconnectapp.com`, `getpickleconnect.com`, etc.)
2. Go to https://resend.com/domains → Add Domain
3. Add the DNS records Resend provides (TXT for DKIM, MX + TXT for SPF, optional TXT for DMARC) at your domain registrar
4. Wait for DNS propagation and click Verify in Resend
5. Update `EMAIL_FROM` env var in Firebase (or change the default in `resend.service.ts`)
6. Redeploy functions: `cd functions && npm run build && firebase deploy --only functions`

### TODO: Firebase Functions Upgrades
- **Upgrade Node.js runtime to 22**: Node.js 20 will be deprecated on 2026-04-30 and decommissioned on 2026-10-30. Update `engines` in `functions/package.json` and redeploy.
- **Upgrade firebase-functions package**: Run `cd functions && npm install --save firebase-functions@latest` (note: there will be breaking changes)