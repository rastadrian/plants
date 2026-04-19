import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../models/plant.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const _channelId = 'plants_watering';
  static const _channelName = 'Plant watering reminders';
  static const int _notificationId = 1;

  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    final tzInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(tzInfo.identifier));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final granted = await android?.requestNotificationsPermission();
      return granted ?? false;
    } else if (Platform.isIOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final granted = await ios?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    return true;
  }

  Future<void> showWateringNotification(List<Plant> overduePlants) async {
    if (overduePlants.isEmpty) return;

    final String title;
    final String body;

    if (overduePlants.length == 1) {
      title = '${overduePlants.first.name} needs water!';
      body = 'Your plant is due for watering.';
    } else {
      title = '${overduePlants.length} plants need water!';
      body = overduePlants.map((p) => p.name).join(', ');
    }

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: overduePlants.length > 1
          ? InboxStyleInformation(
              overduePlants.map((p) => p.name).toList(),
              summaryText: '${overduePlants.length} plants need watering',
            )
          : null,
    );

    await _plugin.show(
      _notificationId,
      title,
      body,
      NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> cancel() => _plugin.cancel(_notificationId);
}
