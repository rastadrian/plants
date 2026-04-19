import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/background/background_service.dart';
import 'core/notifications/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.instance.init();
  await NotificationService.instance.requestPermissions();

  await BackgroundService.init();
  await BackgroundService.registerPeriodicTask();

  runApp(
    const ProviderScope(
      child: PlantsApp(),
    ),
  );
}
