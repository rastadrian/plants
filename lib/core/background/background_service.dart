import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import '../../core/database/database_helper.dart';
import '../../core/notifications/notification_service.dart';
import '../../repositories/plant_repository.dart';

const _taskName = 'checkPlantsWateringTask';
const _taskKey = 'plants.watering.check';
const _lastNotifiedKey = 'last_notified_plant_ids';

/// Must be a top-level function — called by workmanager in a separate isolate.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName != _taskKey) return true;

    try {
      final repo = PlantRepository(dbHelper: DatabaseHelper.instance);
      final plants = await repo.getAll();
      final overdue = plants.where((p) => p.needsWatering).toList();

      if (overdue.isEmpty) return true;

      // Dedup: only notify if the overdue set has changed
      final prefs = await SharedPreferences.getInstance();
      final lastIds = prefs.getStringList(_lastNotifiedKey) ?? [];
      final overdueIds = overdue.map((p) => p.id).toList()..sort();

      if (overdueIds.join(',') == lastIds.join(',')) return true;

      await NotificationService.instance.init();
      await NotificationService.instance.showWateringNotification(overdue);
      await prefs.setStringList(_lastNotifiedKey, overdueIds);
    } catch (_) {
      // Don't crash the background task
    }
    return true;
  });
}

class BackgroundService {
  BackgroundService._();

  static Future<void> init() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  static Future<void> registerPeriodicTask() async {
    await Workmanager().registerPeriodicTask(
      _taskName,
      _taskKey,
      frequency: const Duration(hours: 1),
      constraints: Constraints(networkType: NetworkType.notRequired),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  }

  static Future<void> cancelAll() => Workmanager().cancelAll();
}
