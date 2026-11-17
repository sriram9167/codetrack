import 'package:material_ui/material_ui.dart';

import '../state/app_state.dart';
import '../theme.dart';
import 'analytics_screen.dart';
import 'dashboard_screen.dart';
import 'leaderboard_screen.dart';
import 'students_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _titles = ['Dashboard', 'Students', 'Leaderboard', 'Analytics'];

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final pages = [
      const DashboardScreen(),
      const StudentsScreen(),
      const LeaderboardScreen(),
      const AnalyticsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _titles[_index],
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
            const Text(
              'CodeTrack admin',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Sync all profiles',
            onPressed: () {
              state.syncAll();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All coding profiles synced')),
              );
            },
            icon: const Icon(Icons.sync_rounded),
          ),
          PopupMenuButton<String>(
            tooltip: 'Account',
            icon: const Icon(Icons.account_circle_outlined),
            onSelected: (value) {
              if (value == 'logout') state.logout();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Text(
                  state.adminEmail ?? 'Admin',
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 12.5),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, size: 18),
                    SizedBox(width: 10),
                    Text('Sign out'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(index: _index, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.space_dashboard_outlined),
            selectedIcon: Icon(Icons.space_dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups_rounded),
            label: 'Students',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events_rounded),
            label: 'Leaderboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }
}
