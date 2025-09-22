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