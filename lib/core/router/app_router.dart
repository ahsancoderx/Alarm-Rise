import 'package:go_router/go_router.dart';
import '../widgets/app_shell.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/alarms/screens/alarm_list_screen.dart';
import '../../features/routine/screens/routine_screen.dart';
import '../../features/rewards/screens/rewards_screen.dart';
import '../../features/profile/screens/profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/alarms', builder: (c, s) => const AlarmListScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/routine', builder: (c, s) => const RoutineScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/rewards', builder: (c, s) => const RewardsScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen()),
        ]),
      ],
    ),
  ],
);