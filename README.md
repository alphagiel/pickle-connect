# Pickle Connect - Flutter Development Guide

A comprehensive pickleball club management app built with Flutter, featuring player scheduling, ladder rankings, and tournament management.

## 🚀 Quick Start for Development

### Prerequisites
- Flutter SDK (installed at `/Users/alphagiel/development/flutter/bin`)
- Chrome browser for web development
- Firebase project (currently using "myapp1-c6012")

### Environment Setup
```bash
# Add Flutter to your PATH (add to ~/.zshrc or ~/.bash_profile)
export PATH="$PATH:/Users/alphagiel/development/flutter/bin"

# Verify Flutter installation
flutter doctor
```

### Running the App
```bash
# Install dependencies
flutter pub get

# Run on Chrome (web development)
flutter run -d chrome --web-port 3000

# Run in release mode (fewer debug messages)
flutter run -d chrome --web-port 3000 --release

# Kill running Flutter processes if port is busy
pkill -f flutter
```

## 🛠️ Development Workflow

### Hot Reload Commands
While `flutter run` is active:
- Press `r` for hot reload (preserves state)
- Press `R` for hot restart (resets state)
- Press `q` to quit

### Debugging Tools
- **Flutter Inspector**: `http://127.0.0.1:9100?uri=<debug_uri>` (shown in terminal)
- **Chrome DevTools**: Right-click → Inspect Element
- **VS Code**: Flutter Inspector panel

### Common Development Commands
```bash
# Format code
flutter format .

# Analyze code for issues
flutter analyze

# Clean build cache
flutter clean && flutter pub get

# Update dependencies
flutter pub upgrade
```

## 📚 Dart/Flutter Basics for Beginners

### Widget Structure
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Title')),
      body: Column(
        children: [
          Text('Hello World'),
          ElevatedButton(
            onPressed: () => print('Clicked'),
            child: Text('Button'),
          ),
        ],
      ),
    );
  }
}
```

### State Management with Riverpod
```dart
// Create a provider
final counterProvider = StateProvider<int>((ref) => 0);

// Use in widget
class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('Count: $count');
  }
}

// Update state
ref.read(counterProvider.notifier).state++;
```

### Navigation with Go Router
```dart
// Navigate to a page
context.go('/courts');

// Navigate with parameters
context.go('/profile/${userId}');

// Go back
context.pop();
```

## 🏗️ Project Architecture

### Current Folder Structure
```
lib/
├── main.dart                    # App entry point with Firebase initialization
├── firebase_options.dart        # Firebase configuration
├── core/
│   ├── theme/                   # App themes (light/dark mode)
│   └── utils/                   # App router with Go Router
├── features/
│   ├── auth/                    # Authentication (login/signup/forgot password)
│   │   ├── data/                # AuthRepository, Firebase integration
│   │   └── presentation/        # LoginPage, SignupPage, AuthProviders
│   └── scheduling/              # Court scheduling
│       └── presentation/        # CourtsPage with carousel interface
├── shared/                      # Shared services (notifications)
└── dummy-data/                  # Sample PlayerProposal data
```

### Key Files You'll Work With
- **Main App**: `lib/main.dart` - App startup and Firebase initialization
- **Courts Page**: `lib/features/scheduling/presentation/pages/courts_page.dart` - Carousel interface
- **Auth System**: `lib/features/auth/` - Complete authentication flow
- **Dummy Data**: `lib/dummy-data/dummy-data.dart` - Sample meetup data
- **Routing**: `lib/core/utils/app_router.dart` - Navigation configuration

### Tech Stack in Use
- **State Management**: Riverpod (reactive state management)
- **Navigation**: Go Router (declarative routing)
- **Backend**: Firebase Auth (user authentication)
- **Local Storage**: Hive (offline data storage)
- **UI Framework**: Material Design
- **Web**: Chrome for development

## 🔧 Troubleshooting Common Issues

### Port Already in Use
```bash
# Kill processes on specific ports
lsof -ti:3000 | xargs kill -9

# Kill all Flutter processes
pkill -f flutter
```

### DebugService Errors
These "DebugService: Error serving requests" messages are harmless debug warnings. Your app still works fine.

### Firebase Issues
- Ensure `GoogleService-Info.plist` is in `ios/Runner/`
- Check `lib/firebase_options.dart` has correct configuration
- Current project: "myapp1-c6012"

### Widget Overflow Errors
- Use `Flexible` or `Expanded` widgets
- Set `mainAxisSize: MainAxisSize.min`
- Test responsive design on different screen sizes

## 🎯 Current Features Working

### Authentication System
- Login page with email/password
- Forgot password functionality  
- User registration with invitation codes
- Firebase Auth integration
- Auto-navigation after login

### Courts/Scheduling Page
- **Carousel Interface**: Swipe between Singles and Doubles
- **Visual Design**: Gradient backgrounds with tennis ball patterns
- **Responsive Layout**: Adapts to different screen sizes
- **Data Tables**: Shows meetup details with action buttons
- **Animation**: Smooth transitions between carousel slides

## 📱 Development Tips

### Making Changes
1. **Edit Files**: Use VS Code or your preferred editor
2. **Hot Reload**: Press `r` in terminal to see changes instantly
3. **Hot Restart**: Press `R` to reset app state
4. **Debug**: Use Flutter Inspector for UI debugging

### Flutter Concepts to Learn
- **Widgets**: Everything is a widget (UI building blocks)
- **State**: StatefulWidget vs StatelessWidget
- **Build Method**: Returns the UI for your widget  
- **Context**: Reference to location in widget tree
- **Async/Await**: For Firebase and API calls

### Riverpod Patterns
```dart
// Watch state (rebuilds when changed)
final user = ref.watch(authStateProvider);

// Read once (doesn't rebuild)
ref.read(authNotifierProvider.notifier).signIn();

// Listen for changes
ref.listen(authErrorProvider, (previous, next) {
  if (next != null) showError(next);
});
```

## 🚧 Next Development Steps
- Add real Firestore database integration
- Build player management system
- Implement ladder rankings
- Create tournament brackets
- Add push notifications

## Features
- **Invite-based Registration**: Admin-controlled player registration with invitation codes
- **Multi-Role Support**: Admin and regular user roles with appropriate permissions
- **Court Scheduling**: Real-time scheduling across 8 courts with conflict detection
- **Ladder System**: USTA/UTR rating integration with seasonal rankings
- **Tournament Management**: Top-8 elimination format with bracket generation
- **Push Notifications**: Real-time updates for matches, tournaments, and bookings

### 🏆 Tennis Club Features
- **Skill Divisions**: Beginner, Intermediate, and Advanced player classifications
- **Seasonal Play**: Organized seasons with leaderboards and statistics
- **Match Reporting**: Easy score entry and automatic ranking updates
- **Player Profiles**: Detailed profiles with ratings and match history

## Architecture

### 🏗️ Clean Architecture
- **Feature-based folder structure** for better organization
- **Separation of concerns** with data, domain, and presentation layers
- **Dependency injection** using Riverpod

### 🔧 Tech Stack
- **Flutter 3.10+** - Cross-platform mobile development
- **Riverpod** - State management and dependency injection
- **Go Router** - Navigation and routing
- **Firebase** - Authentication and push notifications
- **Retrofit + Dio** - HTTP client and API integration
- **Hive** - Local data storage and caching
- **Freezed** - Immutable data classes with code generation

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App-wide constants
│   ├── theme/              # App theming
│   ├── utils/              # Utility functions and routing
│   ├── errors/             # Error handling
│   └── network/            # API client configuration
├── features/
│   ├── auth/               # Authentication & user management
│   ├── players/            # Player profiles and management
│   ├── scheduling/         # Court booking and scheduling
│   ├── ladder/             # Ranking system and matches
│   └── tournaments/        # Tournament management
└── shared/
    ├── models/             # Data models
    ├── widgets/            # Reusable UI components
    └── services/           # Shared services
```

Each feature follows Clean Architecture principles:
- `data/` - Data sources, repositories, and models
- `domain/` - Business logic, entities, and use cases
- `presentation/` - UI components, pages, and state management

## Getting Started

### Prerequisites
- Flutter SDK 3.10 or higher
- Dart SDK 3.0 or higher
- iOS Developer account (for iOS builds)
- Android development environment

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd pickle-connect
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Configure Firebase**
   - Add your `google-services.json` (Android) to `android/app/`
   - Add your `GoogleService-Info.plist` (iOS) to `ios/Runner/`

5. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

## Development

### Code Generation
This project uses code generation for models, API clients, and state management:

```bash
# Watch for changes and regenerate automatically
flutter packages pub run build_runner watch

# Generate once
flutter packages pub run build_runner build

# Clean and rebuild
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Adding New Features
1. Create feature folder under `lib/features/`
2. Implement data layer (repositories, data sources)
3. Define domain layer (entities, use cases)
4. Build presentation layer (pages, widgets, providers)
5. Update routing in `app_router.dart`

### Testing
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## Configuration

### Court Setup
- Default: 8 courts configured
- Modify `AppConstants.totalCourts` to change court count
- Court availability hours configurable per court

### Tournament Settings
- Top-8 elimination format (configurable)
- Maximum 32 participants per tournament
- Automatic bracket generation

### Rating Systems
- USTA ratings: 2.5 - 7.0
- UTR ratings: 1.0 - 16.0
- Automatic skill division assignment

## Deployment

### Building for Release

**Android:**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ipa --release
```

### App Store Requirements
- Configure app signing
- Update app metadata in platform-specific files
- Ensure privacy policy and terms of service links

## Contributing

1. Fork the repository
2. Create a feature branch
3. Follow the existing code style and architecture
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
