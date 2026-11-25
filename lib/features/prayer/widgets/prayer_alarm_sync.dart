import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/prayer_providers.dart';

/// Home par rakha jata hai: app khulne aur wapas aane par prayer alarms
/// ka waqt (roz badalta hai) dobara lagata hai.
class PrayerAlarmSync extends ConsumerStatefulWidget {
  const PrayerAlarmSync({super.key});

  @override
  ConsumerState<PrayerAlarmSync> createState() => _PrayerAlarmSyncState();
}

class _PrayerAlarmSyncState extends ConsumerState<PrayerAlarmSync>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _sync();
  }

  Future<void> _sync() async {
    try {
      await ref.read(prayerServiceProvider).refreshAll();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}