# Plants

A Flutter app for tracking plant watering schedules with background reminders.

## Features

### Plant management
- Add plants with a name, optional photo, and a watering interval (set in weeks)
- Edit a plant's name, photo, or watering interval at any time
- Delete a plant along with its full watering history

### Watering tracking
- Log a watering event for any plant with a single tap
- View the complete watering history per plant
- Plants are sorted by urgency — most overdue appear first

### Smart notifications
- Background task periodically checks for overdue plants
- Sends a local notification when plants need watering
- Deduplicates: only fires again when the overdue plant set changes

### Platform support
- Android and iOS

## Developer commands

```bash
# Install dependencies
flutter pub get

# Run on a connected device or emulator
flutter run

# Run all tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Static analysis / lint
flutter analyze

# Auto-fix lint issues
dart fix --apply

# Build Android APK
flutter build apk

# Build iOS app
flutter build ios
```

## Tech stack

- **Flutter / Dart** — UI framework
- **Riverpod 2** (`AsyncNotifier`) — state management
- **sqflite** — local SQLite persistence
- **workmanager** — background task scheduling
- **flutter_local_notifications** — local push notifications
