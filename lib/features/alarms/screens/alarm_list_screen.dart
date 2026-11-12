import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/alarm.dart';
import '../providers/alarms_provider.dart';
import 'alarm_edit_screen.dart';
import 'category_picker_screen.dart';

class AlarmListScreen extends ConsumerWidget {
  const AlarmListScreen({super.key});

  void _openEditor(BuildContext context, Alarm alarm) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AlarmEditScreen(alarm: alarm)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarms = ref.watch(alarmsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Alarms')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CategoryPickerScreen()),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New alarm'),
      ),
      body: alarms.isEmpty
          ? const _EmptyState()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              itemCount: alarms.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final alarm = alarms[i];
                return Dismissible(
                  key: ValueKey(alarm.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:
                        const Icon(Icons.delete_rounded, color: Colors.white),
                  ),
                  onDismissed: (_) =>
                      ref.read(alarmsProvider.notifier).remove(alarm.id),
                  child: _AlarmCard(
                    alarm: alarm,
                    onTap: () => _openEditor(context, alarm),
                    onToggle: () =>
                        ref.read(alarmsProvider.notifier).toggle(alarm.id),
                  ),
                );
              },
            ),
    );
  }
}

class _AlarmCard extends StatelessWidget {
  final Alarm alarm;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  const _AlarmCard({
    required this.alarm,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final dim = !alarm.enabled;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          alarm.timeText,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            height: 1,
                            color: dim
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            alarm.period,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: dim
                                  ? AppColors.textSecondary
                                  : AppColors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      [
                        alarm.repeatText,
                        alarm.category.title,
                        if (alarm.label.isNotEmpty) alarm.label,
                      ].join('  •  '),
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Switch(value: alarm.enabled, onChanged: (_) => onToggle()),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.alarm_add_rounded, size: 72, color: AppColors.orange),
            SizedBox(height: 16),
            Text(
              'No alarms yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tap "New alarm" to create your first mission alarm.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}