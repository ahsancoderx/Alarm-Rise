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

class _RiseQuestAppState extends ConsumerState<RiseQuestApp> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    ref.read(alarmsProvider); // database sync shuru
    _setup();
  }

  Future<void> _setup() async {
    // Alarm bajte hi ring screen kholo
    _sub = plugin.Alarm.ringing.listen((set) {
  for (final s in set.alarms) {
    _openRing(s.id);
  }
});

    await Permission.notification.request();
    await Permission.scheduleExactAlarm.request();
  }

  void _openRing(int id) => appRouter.go('/ring/$id');

  @override
  void dispose() {
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