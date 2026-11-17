import 'package:material_ui/material_ui.dart';

import '../models/student.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key, required this.studentId});

  final int studentId;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final student = state.studentById(studentId);

    if (student == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Student')),
        body: const Center(child: Text('Student not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(student.name),
        actions: [
          IconButton(
            tooltip: 'Sync profiles',
            onPressed: () => _sync(context, state, student),
            icon: const Icon(Icons.sync_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          _ProfileHeader(student: student),
          const SizedBox(height: 16),
          SectionCard(
            title: 'Platform scores',
            subtitle:
                'Weighted: LeetCode 35%, Codeforces 30%, CodeChef 15%',
            child: Column(
              children: [
                for (var i = 0; i < student.platforms.length; i++) ...[
                  _PlatformRow(platform: student.platforms[i]),
                  if (i != student.platforms.length - 1)
                    const SizedBox(height: 16),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: 'Score breakdown',
            subtitle: 'Overall ${student.overall.toStringAsFixed(2)} / 10',
            child: Column(
              children: [
                _MetricRow(
                  label: 'LeetCode',
                  value: student.leetcode.score,
                  color: AppColors.amber,
                ),
                _MetricRow(
                  label: 'Codeforces',
                  value: student.codeforces.score,
                  color: AppColors.primary,
                ),
                _MetricRow(
                  label: 'CodeChef',
                  value: student.codechef.score,
                  color: AppColors.cyan,
                ),
                _MetricRow(
                  label: 'Consistency',
                  value: student.consistency,
                  color: AppColors.green,
                ),
                _MetricRow(
                  label: 'Problem solving',
                  value: student.problemSolving,
                  color: AppColors.red,
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: 'Coaching insight',
            trailing: StatusPill(
              label: student.isAtRisk ? 'At risk' : 'On track',
              color: student.isAtRisk ? AppColors.red : AppColors.green,
              icon: student.isAtRisk
                  ? Icons.warning_amber_rounded
                  : Icons.trending_up_rounded,
            ),
            child: Text(
              student.insight,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => _sync(context, state, student),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.sync_rounded, size: 19),
            label: const Text('Sync all platforms'),
          ),
        ],
      ),
    );
  }

  void _sync(BuildContext context, AppState state, Student student) {
    state.syncStudent(student.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Synced ${student.name}\'s coding profiles'),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.22),
            AppColors.cyan.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          InitialsAvatar(name: student.name, size: 58),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${student.rollNumber} · ${student.branch} · Year ${student.year}',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  student.email,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Last sync ${student.lastSyncLabel}',
                  style: const TextStyle(
                    color: AppColors.cyan,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Text(
                student.overall.toStringAsFixed(1),
                style: TextStyle(
                  color: scoreColor(student.overall),
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'overall',
                style: TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlatformRow extends StatelessWidget {
  const _PlatformRow({required this.platform});

  final PlatformStat platform;

  Color get _color => switch (platform.name) {
        'LeetCode' => AppColors.amber,
        'Codeforces' => AppColors.primary,
        _ => AppColors.cyan,
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              platform.name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
            const Spacer(),
            Text(
              platform.handle == 'not linked' ? 'Not linked' : '@${platform.handle}',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ScoreBar(value: platform.score, color: _color),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              'Rating ${platform.rating} · ${platform.solved} solved',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11.5,
              ),
            ),
            const Spacer(),
            Text(
              '${platform.score.toStringAsFixed(1)} / 10',
              style: TextStyle(
                color: _color,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
    required this.color,
    this.isLast = false,
  });

  final String label;
  final double value;
  final Color color;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 12.5),
              ),
              const Spacer(),
              Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  color: color,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ScoreBar(value: value, color: color, height: 6),
        ],
      ),
    );
  }
}
