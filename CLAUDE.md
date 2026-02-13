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

# Run app
flutter run
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