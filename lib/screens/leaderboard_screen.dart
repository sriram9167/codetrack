import 'package:material_ui/material_ui.dart';

import '../models/student.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'student_profile_screen.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final ranked = state.leaderboard;
    final podium = ranked.take(3).toList();
    final rest = ranked.skip(3).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        const Text(
          'Overall leaderboard',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${ranked.length} students ranked by weighted coding score',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: _PodiumCard(student: podium[1], place: 2)),
            const SizedBox(width: 10),
            Expanded(child: _PodiumCard(student: podium[0], place: 1)),
            const SizedBox(width: 10),
            Expanded(child: _PodiumCard(student: podium[2], place: 3)),
          ],
        ),
        const SizedBox(height: 20),
        SectionCard(
          title: 'Full ranking',
          subtitle: 'Tap any student to open their profile',
          child: Column(
            children: [
              for (var i = 0; i < rest.length; i++) ...[
                _RankRow(
                  rank: i + 4,
                  student: rest[i],
                  onTap: () => _openProfile(context, rest[i].id),
                ),
                if (i != rest.length - 1) const SizedBox(height: 8),
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

class _PodiumCard extends StatelessWidget {
  const _PodiumCard({required this.student, required this.place});

  final Student student;
  final int place;

  Color get _accent => switch (place) {
        1 => AppColors.amber,
        2 => const Color(0xFFCBD5E1),
        _ => const Color(0xFFD97706),
      };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => StudentProfileScreen(studentId: student.id),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: place == 1 ? 20 : 14,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _accent.withValues(alpha: 0.45)),
          ),
          child: Column(
            children: [
              Icon(Icons.emoji_events_rounded, color: _accent, size: place == 1 ? 30 : 24),
              const SizedBox(height: 8),
              InitialsAvatar(
                name: student.name,
                size: place == 1 ? 46 : 40,
                color: _accent,
              ),
              const SizedBox(height: 8),
              Text(
                student.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                student.branch,
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
              const SizedBox(height: 8),
              Text(
                student.overall.toStringAsFixed(2),
                style: TextStyle(
                  color: _accent,
                  fontWeight: FontWeight.w800,
                  fontSize: place == 1 ? 20 : 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({
    required this.rank,
    required this.student,
    required this.onTap,
  });

  final int rank;
  final Student student;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
            InitialsAvatar(name: student.name, size: 34),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                    ),
                  ),
                  Text(
                    '${student.rollNumber} · ${student.branch}',
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 11),
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
