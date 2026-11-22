import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../rewards/providers/rewards_providers.dart';
import '../providers/habit_providers.dart';
import '../widgets/habit_icons.dart';

class HabitsTab extends ConsumerWidget {
  const HabitsTab({super.key});

  Future<void> _toggle(
      BuildContext context, WidgetRef ref, HabitView h, String today) async {
    final done = !h.doneOn(today);
    await ref.read(rewardsServiceProvider).toggleHabit(h.habit, today, done);
    if (!context.mounted) return;
    final m = ScaffoldMessenger.of(context);
    m.clearSnackBars();
    m.showSnackBar(SnackBar(
      duration: const Duration(seconds: 1),
      content: Text(done ? '+${h.habit.xp} XP' : 'Habit unchecked'),
    ));
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, HabitView h) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete habit?'),
        content: Text('"${h.habit.name}" and its history will be removed. '
            'XP you already earned stays.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(rewardsServiceProvider).deleteHabit(h.habit.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitViewsProvider);
    final today = ref.watch(todayKeyProvider);
    final done = habits.where((h) => h.doneOn(today)).length;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          backgroundColor: AppColors.background,
          builder: (_) => const _AddHabitSheet(),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add habit'),
      ),
      body: habits.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No habits yet. Tap "Add habit" to start building your routine.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Today: $done of ${habits.length} done',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16)),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: habits.isEmpty ? 0 : done / habits.length,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.orange,
                          backgroundColor: AppColors.border,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                for (final h in habits)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _HabitCard(
                      view: h,
                      today: today,
                      onToggle: () => _toggle(context, ref, h, today),
                      onDelete: () => _confirmDelete(context, ref, h),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  final HabitView view;
  final String today;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _HabitCard({
    required this.view,
    required this.today,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final h = view.habit;
    final done = view.doneOn(today);
    final streak = view.streak(today);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.orange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(habitIcon(h.icon), color: AppColors.orange),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(h.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 2),
                      Text(
                        streak > 0
                            ? '$streak day streak  •  +${h.xp} XP'
                            : '+${h.xp} XP',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (_) => onDelete(),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
                GestureDetector(
                  onTap: onToggle,
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: done ? AppColors.orange : Colors.transparent,
                          border: Border.all(
                              color: done
                                  ? AppColors.orange
                                  : AppColors.textSecondary,
                              width: 2),
                        ),
                        child: done
                            ? const Icon(Icons.check_rounded,
                                color: Colors.white, size: 20)
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _WeekDots(view: view, today: today),
          ],
        ),
      ),
    );
  }
}

class _WeekDots extends StatelessWidget {
  final HabitView view;
  final String today;
  const _WeekDots({required this.view, required this.today});

  @override
  Widget build(BuildContext context) {
    final t = DateTime.parse(today);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 6; i >= 0; i--)
            Builder(builder: (_) {
              final d = DateTime(t.year, t.month, t.day - i);
              final done = view.days.contains(_key(d));
              return Column(
                children: [
                  Text('MTWTFSS'[d.weekday - 1],
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done ? AppColors.orange : Colors.transparent,
                      border: Border.all(
                          color: done ? AppColors.orange : AppColors.border,
                          width: 2),
                    ),
                  ),
                ],
              );
            }),
        ],
      ),
    );
  }

  String _key(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

class _AddHabitSheet extends ConsumerStatefulWidget {
  const _AddHabitSheet();

  @override
  ConsumerState<_AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends ConsumerState<_AddHabitSheet> {
  final _name = TextEditingController();
  String _icon = 'check';
  int _xp = 15;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    await ref.read(rewardsServiceProvider).addHabit(name, _icon, _xp);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 4, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('New habit',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          TextField(
            controller: _name,
            maxLength: 30,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'e.g. Read 10 pages',
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final e in habitIcons.entries)
                ChoiceChip(
                  label: Icon(e.value,
                      size: 20,
                      color: _icon == e.key
                          ? Colors.white
                          : AppColors.textPrimary),
                  selected: _icon == e.key,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _icon = e.key),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final x in const [10, 15, 20, 30])
                ChoiceChip(
                  label: Text('+$x XP'),
                  selected: _xp == x,
                  showCheckmark: false,
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _xp == x ? Colors.white : AppColors.textPrimary),
                  onSelected: (_) => setState(() => _xp = x),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: _save,
              child: const Text('Save habit',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}