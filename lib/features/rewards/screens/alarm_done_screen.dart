import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../services/rewards_service.dart';

class AlarmDoneScreen extends StatelessWidget {
  final AwardResult? result;
  const AlarmDoneScreen({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    final r = result;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.check_circle_rounded,
                    size: 96, color: Color(0xFF16A34A)),
                const SizedBox(height: 16),
                const Text('Mission complete!',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                const SizedBox(height: 24),
                if (r != null && r.xp > 0) ...[
                  Text('+${r.xp} XP',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: AppColors.gold)),
                  Text('+${r.coins} coins',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 16)),
                ] else
                  const Text('Good morning!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18, color: AppColors.textSecondary)),
                if (r != null) ...[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.local_fire_department_rounded,
                          color: AppColors.orange),
                      const SizedBox(width: 6),
                      Text('${r.streak} day streak',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  if (r.leveledUp)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Level up! You are now level ${r.level}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.orange)),
                    ),
                ],
                const SizedBox(height: 40),
                SizedBox(
                  height: 56,
                  child: FilledButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Continue',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}