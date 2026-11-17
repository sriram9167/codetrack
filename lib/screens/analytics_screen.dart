import 'package:material_ui/material_ui.dart';

import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final branches = state.branchAverages.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final atRisk = state.atRiskStudents;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        const Text(
          'Analytics',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Cohort-level performance breakdown',
          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
        const SizedBox(height: 18),
        SectionCard(
          title: 'Average score by branch',
          subtitle: 'Ranked from strongest to weakest',
          child: Column(
            children: [
              for (var i = 0; i < branches.length; i++) ...[
                _BranchRow(
                  branch: branches[i].key,
                  average: branches[i].value,
                  isTop: i == 0,
                ),
                if (i != branches.length - 1) const SizedBox(height: 14),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Platform averages',
          subtitle: 'Mean score across all students (out of 10)',
          child: Row(
            children: [
              Expanded(
                child: _PlatformStat(
                  label: 'LeetCode',
                  value: state.leetcodeAverage,
                  color: AppColors.amber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PlatformStat(
                  label: 'Codeforces',
                  value: state.codeforcesAverage,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PlatformStat(
                  label: 'CodeChef',
                  value: state.codechefAverage,
                  color: AppColors.cyan,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'At-risk students',
          subtitle: 'Overall score below 5.0',
          trailing: StatusPill(
            label: '${atRisk.length} flagged',
            color: AppColors.red,
            icon: Icons.flag_rounded,
          ),
          child: atRisk.isEmpty
              ? const EmptyState(
                  icon: Icons.check_circle_outline_rounded,
                  message: 'Nobody is at risk right now.',
                )
              : Column(
                  children: [
                    for (var i = 0; i < atRisk.length; i++) ...[
                      Row(
                        children: [
                          InitialsAvatar(
                            name: atRisk[i].name,
                            size: 32,
                            color: AppColors.red,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              atRisk[i].name,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '${atRisk[i].branch} · ',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11.5,
                            ),
                          ),
                          ScorePill(score: atRisk[i].overall),
                        ],
                      ),
                      if (i != atRisk.length - 1) const SizedBox(height: 10),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _BranchRow extends StatelessWidget {
  const _BranchRow({
    required this.branch,
    required this.average,
    required this.isTop,
  });

  final String branch;
  final double average;
  final bool isTop;

  @override
  Widget build(BuildContext context) {
    final color = scoreColor(average);
    return Column(
      children: [
        Row(
          children: [
            if (isTop) ...[
              const Icon(Icons.workspace_premium_rounded,
                  size: 15, color: AppColors.amber),
              const SizedBox(width: 5),
            ],
            Text(
              branch,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              average.toStringAsFixed(2),
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ScoreBar(value: average, color: color),
      ],
    );
  }
}

class _PlatformStat extends StatelessWidget {
  const _PlatformStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          ScoreBar(value: value, color: color, height: 5),
        ],
      ),
    );
  }
}
