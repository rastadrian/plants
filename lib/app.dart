import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/notifications/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'features/plants_list/plants_list_screen.dart';
import 'providers/plant_provider.dart';

class PlantsApp extends StatelessWidget {
  const PlantsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plants',
      theme: appTheme,
      home: const _AppLifecycleWrapper(child: PlantsListScreen()),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Listens for app-foreground transitions and refreshes plant state + notifications.
class _AppLifecycleWrapper extends ConsumerStatefulWidget {
  const _AppLifecycleWrapper({required this.child});
  final Widget child;

  @override
  ConsumerState<_AppLifecycleWrapper> createState() => _AppLifecycleWrapperState();
}

class _AppLifecycleWrapperState extends ConsumerState<_AppLifecycleWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh plant list
      ref.invalidate(plantsProvider);
      // Check for overdue plants and notify if needed
      _checkAndNotify();
    }
  }

  Future<void> _checkAndNotify() async {
    final plants = await ref.read(plantsProvider.future);
    final overdue = plants.where((p) => p.needsWatering).toList();
    if (overdue.isNotEmpty) {
      await NotificationService.instance.showWateringNotification(overdue);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
