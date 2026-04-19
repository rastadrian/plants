# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
/Users/adrian/Applications/flutter/bin/flutter pub get          # Install dependencies
/Users/adrian/Applications/flutter/bin/flutter run              # Run on connected device/emulator
/Users/adrian/Applications/flutter/bin/flutter test             # Run all tests
/Users/adrian/Applications/flutter/bin/flutter test test/widget_test.dart  # Run a single test file
/Users/adrian/Applications/flutter/bin/flutter analyze          # Static analysis / lint
/Users/adrian/Applications/flutter/bin/dart fix --apply         # Auto-fix lint issues
/Users/adrian/Applications/flutter/bin/flutter build apk        # Build Android APK
/Users/adrian/Applications/flutter/bin/flutter build ios        # Build iOS app
```

## Architecture

Flutter + Dart app. State management via **Riverpod 2** (`AsyncNotifier`). Persistence via **sqflite** (SQLite). Background notifications via **workmanager** + **flutter_local_notifications**.

### Entry point

`lib/main.dart` — initializes notification service, requests permissions, registers the workmanager periodic task, then mounts `ProviderScope → PlantsApp`.

`lib/app.dart` — `MaterialApp` with theme + `_AppLifecycleWrapper` (WidgetsBindingObserver that refreshes plant state and fires notifications on foreground resume).

### Feature structure

```
lib/
  core/
    background/background_service.dart   # workmanager callbackDispatcher (top-level fn) + task registration
    database/database_helper.dart        # SQLite singleton; setDatabaseForTesting() for tests
    database/database_constants.dart     # Table/column name constants
    notifications/notification_service.dart
    storage/photo_storage.dart           # Save/delete plant photos in app documents dir
    theme/app_colors.dart + app_theme.dart
    utils/date_utils.dart
  models/plant.dart                      # Plant.daysUntilNextWatering + needsWatering computed props
  models/watering_entry.dart
  repositories/plant_repository.dart    # SQL JOIN query returns plants + last_watered_at
  repositories/watering_repository.dart
  providers/
    database_provider.dart              # Riverpod providers for DatabaseHelper, repositories
    plant_provider.dart                 # PlantsNotifier (AsyncNotifier): addPlant, updatePlant, waterPlant, deletePlant
    watering_provider.dart              # FutureProvider.family for history per plant
  features/
    plants_list/                        # Main screen
    add_plant/                          # Form screen (photo, name, week interval)
    plant_details/                      # DraggableScrollableSheet modal (history, edit, delete)
```

### Data flow

1. `plantsProvider` (AsyncNotifier) calls `PlantRepository.getAll()` — a LEFT JOIN query that returns each plant with its `MAX(watered_at)`. Sorted in Dart by `daysUntilNextWatering` then name.
2. Mutations (`waterPlant`, `addPlant`, etc.) call `ref.invalidateSelf()` to re-run the query.
3. Plant photos are stored as files under `<documents>/plant_photos/<plantId>.<ext>`; only the path is stored in the DB.
4. The background task runs in a fresh Dart isolate — it re-initializes `DatabaseHelper` and `NotificationService` independently of the main app.

### Key architectural notes

- `wateringIntervalDays` is stored in days (input UI is weeks × 7) to keep the schema flexible.
- UUID primary keys are used for both tables.
- `ON DELETE CASCADE` on `watering_history.plant_id` — deleting a plant removes all its history automatically.
- The background task deduplicates notifications using `SharedPreferences` (key `last_notified_plant_ids`); it only fires when the overdue plant set changes.
