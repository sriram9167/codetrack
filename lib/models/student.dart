class PlatformStat {
  final String name;
  final String handle;
  final int rating;
  final int solved;
  final double score;

  const PlatformStat({
    required this.name,
    required this.handle,
    required this.rating,
    required this.solved,
    required this.score,
  });
}

class Student {
  final int id;
  final String name;
  final String rollNumber;
  final String branch;
  final int year;
  final String email;
  final PlatformStat leetcode;
  final PlatformStat codeforces;
  final PlatformStat codechef;
  final double consistency;
  final double problemSolving;
  DateTime lastSynced;

  Student({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.branch,
    required this.year,
    required this.email,
    required this.leetcode,
    required this.codeforces,
    required this.codechef,
    required this.consistency,
    required this.problemSolving,
    required this.lastSynced,
  });

  double get overall {
    final value = 0.35 * leetcode.score +
        0.30 * codeforces.score +
        0.15 * codechef.score +
        0.10 * consistency +
        0.10 * problemSolving;
    return double.parse(value.toStringAsFixed(2));
  }

  bool get isAtRisk => overall < 5.0;

  List<PlatformStat> get platforms => [leetcode, codeforces, codechef];

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  String get insight {
    if (overall >= 8.5) {
      return 'Top performer across every platform. Keep pushing into hard '
          'problems and contests to stay ahead.';
    }
    if (overall >= 7) {
      return 'Strong profile. Raising CodeChef contest participation is the '
          'quickest way to move into the elite band.';
    }
    if (overall >= 5) {
      return 'Steady progress. Focus on medium-level problem volume and sync '
          'profiles weekly so consistency keeps climbing.';
    }
    return 'At risk. Start with a daily problem habit on LeetCode and join '
        'the next Codeforces Div. 4 round to rebuild momentum.';
  }

  String get lastSyncLabel {
    final diff = DateTime.now().difference(lastSynced);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
