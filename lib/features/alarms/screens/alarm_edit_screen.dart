import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/alarm.dart';
import '../../../data/models/alarm_category.dart';
import '../providers/alarms_provider.dart';

class AlarmEditScreen extends ConsumerStatefulWidget {
  final Alarm? alarm;
  final AlarmCategory? category;

  const AlarmEditScreen({super.key, this.alarm, this.category});

  @override
  ConsumerState<AlarmEditScreen> createState() => _AlarmEditScreenState();
}

class _AlarmEditScreenState extends ConsumerState<AlarmEditScreen> {
  static const _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  late AlarmCategory _category;
  late TimeOfDay _time;
  late Set<int> _days;
  late String _tone;
  late bool _vibrate;
  late TextEditingController _label;

  bool get _isEdit => widget.alarm != null;

  @override
  void initState() {
    super.initState();
    final a = widget.alarm;
    _category = a?.category ?? widget.category ?? AlarmCategory.simple;
    _time = a == null
        ? const TimeOfDay(hour: 7, minute: 0)
        : TimeOfDay(hour: a.hour, minute: a.minute);
    _days = {...?a?.days};
    _tone = a?.tone ?? alarmTones.first;
    _vibrate = a?.vibrate ?? true;
    _label = TextEditingController(text: a?.label ?? '');
  }

  @override
  void dispose() {
    _label.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _pickTone() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.background,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final t in alarmTones)
              ListTile(
                leading: Icon(
                  Icons.music_note_rounded,
                  color: t == _tone ? AppColors.orange : AppColors.textSecondary,
                ),
                title: Text(t,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: t == _tone
                    ? const Icon(Icons.check_rounded, color: AppColors.orange)
                    : null,
                onTap: () => Navigator.of(context).pop(t),
              ),
          ],
        ),
      ),
    );
    if (picked != null) setState(() => _tone = picked);
  }

  void _save() {
    final notifier = ref.read(alarmsProvider.notifier);
    notifier.save(Alarm(
      id: widget.alarm?.id ?? notifier.nextId(),
      hour: _time.hour,
      minute: _time.minute,
      days: _days,
      category: _category,
      tone: _tone,
      vibrate: _vibrate,
      label: _label.text.trim(),
      enabled: widget.alarm?.enabled ?? true,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final preview = Alarm(id: 0, hour: _time.hour, minute: _time.minute);

    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit alarm' : 'New alarm')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Category badge
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _category.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_category.icon, color: _category.color, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      _category.title,
                      style: TextStyle(
                        color: _category.color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Time
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _pickTime,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      preview.timeText,
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w800,
                        height: 1,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        preview.period,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Center(
              child: Text('Tap to change time',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          ),

          // Repeat
          const SizedBox(height: 24),
          const _SectionTitle('Repeat'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(7, (i) {
              final day = i + 1;
              final selected = _days.contains(day);
              return FilterChip(
                label: Text(_dayLabels[i]),
                selected: selected,
                showCheckmark: false,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.textPrimary,
                ),
                onSelected: (v) => setState(() {
                  v ? _days.add(day) : _days.remove(day);
                }),
              );
            }),
          ),
          const SizedBox(height: 4),
          Text(
            Alarm(id: 0, hour: 0, minute: 0, days: _days).repeatText,
            style: const TextStyle(color: AppColors.textSecondary),
          ),

          // Tone and vibration
          const SizedBox(height: 24),
          const _SectionTitle('Sound'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.music_note_rounded,
                      color: AppColors.orange),
                  title: const Text('Alarm tone',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(_tone),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: _pickTone,
                ),
                const Divider(height: 1, color: AppColors.border),
                SwitchListTile(
                  secondary: const Icon(Icons.vibration_rounded,
                      color: AppColors.orange),
                  title: const Text('Vibration',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  value: _vibrate,
                  onChanged: (v) => setState(() => _vibrate = v),
                ),
              ],
            ),
          ),

          // Label
          const SizedBox(height: 24),
          const _SectionTitle('Label'),
          TextField(
            controller: _label,
            maxLength: 30,
            decoration: InputDecoration(
              hintText: 'e.g. Fajr, Gym, College',
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),

          const SizedBox(height: 16),
          SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text(
                'Save alarm',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}