import 'dart:async';
import 'package:alarm/alarm.dart' as plugin;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/alarms/providers/alarms_provider.dart';

class RiseQuestApp extends ConsumerStatefulWidget {
  const RiseQuestApp({super.key});

  @override
  ConsumerState<RiseQuestApp> createState() => _RiseQuestAppState();
}

class _RiseQuestAppState extends ConsumerState<RiseQuestApp>
    with WidgetsBindingObserver {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.read(alarmsProvider); // database sync shuru
    _setup();
  }

  Future<void> _setup() async {
        _sub = plugin.Alarm.ringing.listen((set) {
      if (set.alarms.isNotEmpty) _openRing(set.alarms.first.id);
    });
    await _checkRinging();
    await Permission.notification.request();
    await Permission.scheduleExactAlarm.request();
  }

  Future<void> _checkRinging() async {
    for (final s in await plugin.Alarm.getAlarms()) {
      if (await plugin.Alarm.isRinging(s.id)) {
        _openRing(s.id);
        break;
      }
    }
  }

  void _openRing(int id) => appRouter.go('/ring/$id');

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkRinging();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RiseQuest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}