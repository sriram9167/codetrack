import 'package:material_ui/material_ui.dart';

import '../models/student.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'student_profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final top = state.leaderboard.take(4).toList();
    final atRisk = state.atRiskStudents;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        const Text(
          'Welcome back, Admin',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 23,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Here's how your students are performing this week.",
          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            StatCard(
              icon: Icons.groups_rounded,
              label: 'Total students',
              value: '${state.students.length}',
              caption: 'Across ${state.branchAverages.length} branches',
              accent: AppColors.primary,
            ),
            StatCard(
              icon: Icons.speed_rounded,
              label: 'Average score',
              value: state.averageScore.toStringAsFixed(2),
              caption: 'Out of 10 overall',
              accent: AppColors.cyan,
            ),
            StatCard(
              icon: Icons.warning_amber_rounded,
              label: 'At risk',
              value: '${atRisk.length}',
              caption: 'Overall below 5.0',
              accent: AppColors.red,
            ),
            StatCard(
              icon: Icons.sync_rounded,
              label: 'Synced today',
              value: '${state.syncedToday}',
              caption: 'Coding profiles updated',
              accent: AppColors.green,
            ),
          ],
        ),
        const SizedBox(height: 24),
        SectionCard(
          title: 'Top performers',
          subtitle: 'Ranked by overall coding score',
          trailing: const StatusPill(
            label: 'Live sync',
            color: AppColors.green,
            icon: Icons.bolt_rounded,
          ),
          child: Column(
            children: [
              for (var i = 0; i < top.length; i++) ...[
                _TopPerformerRow(
                  rank: i + 1,
                  student: top[i],
                  onTap: () => _openProfile(context, top[i].id),
                ),
                if (i != top.length - 1) const SizedBox(height: 12),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Needs attention',
          subtitle: '${atRisk.length} students below the 5.0 threshold',
          child: atRisk.isEmpty
              ? const EmptyState(
                  icon: Icons.check_circle_outline_rounded,
                  message: 'No students at risk. Everyone is above 5.0.',
                )
              : Column(
                  children: [
                    for (var i = 0; i < atRisk.length; i++) ...[
                      _AtRiskRow(
                        student: atRisk[i],
                        onTap: () => _openProfile(context, atRisk[i].id),
                      ),
                      if (i != atRisk.length - 1) const SizedBox(height: 10),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  void _openProfile(BuildContext context, int id) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StudentProfileScreen(studentId: id),
      ),
    );
  }
}

class _TopPerformerRow extends StatelessWidget {
  const _TopPerformerRow({
    required this.rank,
    required this.student,
    required this.onTap,
  });

  final int rank;
  final Student student;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final rankColor = switch (rank) {
      1 => AppColors.amber,
      2 => const Color(0xFFCBD5E1),
      3 => const Color(0xFFD97706),
      _ => AppColors.textMuted,
    };

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          children: [
            SizedBox(
              width: 26,
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: rankColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
            InitialsAvatar(name: student.name, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${student.rollNumber} · ${student.branch}',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ScorePill(score: student.overall),
          ],
        ),
      ),
    );
  }
}

class _AtRiskRow extends StatelessWidget {
  const _AtRiskRow({required this.student, required this.onTap});

  final Student student;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.red.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.red.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          InitialsAvatar(name: student.name, size: 36, color: AppColors.red),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
                Text(
                  '${student.branch} · last sync ${student.lastSyncLabel}',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.red,
              visualDensity: VisualDensity.compact,
            ),
            child: const Text('Review'),
          ),
        ],
      ),
    );
  }
}
