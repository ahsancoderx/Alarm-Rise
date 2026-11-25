import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/prayer_calc.dart';
import '../../../data/models/alarm_category.dart';
import '../../prayer/data/prayer_cities.dart';
import '../../prayer/models/prayer.dart';
import '../../prayer/providers/prayer_providers.dart';
import '../../prayer/services/location_service.dart';

void _sheet(BuildContext context, Widget child) => showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.background,
      builder: (_) => child,
    );

void showLocationSheet(BuildContext c) => _sheet(c, const _LocationSheet());
void showSettingsSheet(BuildContext c) => _sheet(c, const _SettingsSheet());
void showAlarmSheet(BuildContext c, Prayer p) =>
    _sheet(c, _AlarmSheet(prayer: p));

// ---------------- Location ----------------

class _LocationSheet extends ConsumerStatefulWidget {
  const _LocationSheet();

  @override
  ConsumerState<_LocationSheet> createState() => _LocationSheetState();
}

class _LocationSheetState extends ConsumerState<_LocationSheet> {
  String _q = '';
  bool _busy = false;

  Future<void> _gps() async {
    setState(() => _busy = true);
    final c = await getDeviceLocation();
    if (!mounted) return;
    if (c == null) {
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Could not get your location. Check GPS and permission, or choose a city.')));
      return;
    }
    final near = nearestCity(c);
    final name = (near != null && near.$2 < 60)
        ? 'Near ${near.$1.name}'
        : 'My location';
    final country = (near != null && near.$2 < 1200) ? near.$1.cc : null;
    await ref.read(prayerServiceProvider).setLocation(
        name: name, lat: c.lat, lng: c.lng, country: country);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _pick(City c) async {
    await ref
        .read(prayerServiceProvider)
        .setLocation(name: c.name, lat: c.lat, lng: c.lng, country: c.cc);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final q = _q.toLowerCase();
    final list = prayerCities
        .where((c) => c.name.toLowerCase().contains(q))
        .toList();
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            ListTile(
              leading: _busy
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.my_location_rounded,
                      color: AppColors.orange),
              title: const Text('Use my current location',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('GPS, works without internet'),
              onTap: _busy ? null : _gps,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (v) => setState(() => _q = v),
                decoration: InputDecoration(
                  hintText: 'Search city',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) => ListTile(
                  title: Text(list[i].name),
                  trailing: Text(list[i].cc,
                      style:
                          const TextStyle(color: AppColors.textSecondary)),
                  onTap: () => _pick(list[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Settings ----------------

class _SettingsSheet extends ConsumerWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cfg = ref.watch(prayerConfigProvider);
    final svc = ref.read(prayerServiceProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Prayer settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          const Text('Calculation method',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final m in PrayerMethod.values)
                ChoiceChip(
                  label: Text(m.label),
                  selected: cfg.method == m,
                  showCheckmark: false,
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: cfg.method == m
                          ? Colors.white
                          : AppColors.textPrimary),
                  onSelected: (_) => svc.setMethod(m),
                ),
            ],
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Hanafi Asr'),
            subtitle: const Text('Later Asr time (Pakistan, India)'),
            value: cfg.hanafi,
            onChanged: svc.setHanafi,
          ),
          const SizedBox(height: 8),
          const Text('Fine tune (minutes)',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const Text('Match your local mosque timetable.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          for (final p in Prayer.values)
            Row(
              children: [
                Expanded(child: Text(p.title)),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline_rounded),
                  onPressed: () => svc.setAdjust(p, cfg.adjust(p) - 1),
                ),
                SizedBox(
                  width: 44,
                  child: Text(
                      '${cfg.adjust(p) > 0 ? '+' : ''}${cfg.adjust(p)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline_rounded),
                  onPressed: () => svc.setAdjust(p, cfg.adjust(p) + 1),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ---------------- Prayer alarm ----------------

class _AlarmSheet extends ConsumerStatefulWidget {
  final Prayer prayer;
  const _AlarmSheet({required this.prayer});

  @override
  ConsumerState<_AlarmSheet> createState() => _AlarmSheetState();
}

class _AlarmSheetState extends ConsumerState<_AlarmSheet> {
  late bool _on;
  late int _offset;
  late String _cat;

  static const _offsets = [0, 5, 10, 15, 20, 30, 45, 60];
  static const _missions = [
    AlarmCategory.simple,
    AlarmCategory.math,
    AlarmCategory.face,
  ];

  @override
  void initState() {
    super.initState();
    final a = ref.read(prayerConfigProvider).alarm(widget.prayer);
    _on = a.on || a.alarmId == null;
    _offset = a.offset;
    _cat = a.category;
  }

  Future<void> _save() async {
    await ref.read(prayerServiceProvider).saveAlarm(
          widget.prayer,
          on: _on,
          offset: _offset,
          category: widget.prayer == Prayer.fajr ? _cat : null,
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.prayer;
    final cfg = ref.watch(prayerConfigProvider);
    final now = DateTime.now();
    final next = _on ? cfg.nextAlarmTime(p, now, offset: _offset) : null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 4, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${p.title} alarm',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Alarm on'),
              value: _on,
              onChanged: (v) => setState(() => _on = v),
            ),
            if (_on) ...[
              const Text('When',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final o in _offsets)
                    ChoiceChip(
                      label: Text(o == 0 ? 'At azan' : '$o min before'),
                      selected: _offset == o,
                      showCheckmark: false,
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _offset == o
                              ? Colors.white
                              : AppColors.textPrimary),
                      onSelected: (_) => setState(() => _offset = o),
                    ),
                ],
              ),
              if (p == Prayer.fajr) ...[
                const SizedBox(height: 14),
                const Text('Wake-up mission',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final m in _missions)
                      ChoiceChip(
                        label: Text(m.title),
                        selected: _cat == m.name,
                        showCheckmark: false,
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _cat == m.name
                                ? Colors.white
                                : AppColors.textPrimary),
                        onSelected: (_) => setState(() => _cat = m.name),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Text(
                next == null
                    ? 'Set your location first.'
                    : 'Next alarm: ${next.day == now.day ? 'Today' : 'Tomorrow'} ${fmtClock(next)}',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: _save,
                child: const Text('Save',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}