import 'package:flutter/widgets.dart';

import '../data/sample_data.dart';
import '../models/student.dart';

const demoEmail = 'admin@codetrack.local';
const demoPassword = 'Admin@12345';

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree');
    return scope!.notifier!;
  }
}

class AppState extends ChangeNotifier {
  final List<Student> _students = buildSampleStudents();
  bool _isAuthenticated = false;
  String? _adminEmail;

  bool get isAuthenticated => _isAuthenticated;
  String? get adminEmail => _adminEmail;
  List<Student> get students => List.unmodifiable(_students);

  List<Student> get leaderboard {
    final sorted = List<Student>.of(_students);
    sorted.sort((a, b) => b.overall.compareTo(a.overall));
    return sorted;
  }

  List<Student> get atRiskStudents =>
      leaderboard.where((student) => student.isAtRisk).toList();

  double get averageScore {
    if (_students.isEmpty) return 0;
    final total = _students.fold<double>(0, (sum, s) => sum + s.overall);
    return total / _students.length;
  }

  int get syncedToday => _students
      .where((s) => DateTime.now().difference(s.lastSynced).inHours < 24)
      .length;

  bool login(String email, String password) {
    final normalized = email.trim().toLowerCase();
    if (normalized == demoEmail && password == demoPassword) {
      _isAuthenticated = true;
      _adminEmail = normalized;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    _adminEmail = null;
    notifyListeners();
  }

  Student? studentById(int id) {
    for (final student in _students) {
      if (student.id == id) return student;
    }
    return null;
  }

  List<Student> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return leaderboard;
    return leaderboard
        .where((s) =>
            s.name.toLowerCase().contains(q) ||
            s.rollNumber.toLowerCase().contains(q) ||
            s.branch.toLowerCase().contains(q))
        .toList();
  }

  void addStudent({
    required String name,
    required String rollNumber,
    required String email,
    required String branch,
    required int year,
  }) {
    final nextId =
        _students.fold<int>(0, (max, s) => s.id > max ? s.id : max) + 1;
    _students.add(
      Student(
        id: nextId,
        name: name.trim(),
        rollNumber: rollNumber.trim().toUpperCase(),
        branch: branch,
        year: year,
        email: email.trim(),
        leetcode: const PlatformStat(
            name: 'LeetCode', handle: 'not linked', rating: 0, solved: 0, score: 0),
        codeforces: const PlatformStat(
            name: 'Codeforces',
            handle: 'not linked',
            rating: 0,
            solved: 0,
            score: 0),
        codechef: const PlatformStat(
            name: 'CodeChef', handle: 'not linked', rating: 0, solved: 0, score: 0),
        consistency: 0,
        problemSolving: 0,
        lastSynced: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void syncStudent(int id) {
    final student = studentById(id);
    if (student == null) return;
    student.lastSynced = DateTime.now();
    notifyListeners();
  }

  void syncAll() {
    final now = DateTime.now();
    for (final student in _students) {
      student.lastSynced = now;
    }
    notifyListeners();
  }

  Map<String, double> get branchAverages {
    final totals = <String, double>{};
    final counts = <String, int>{};
    for (final student in _students) {
      totals[student.branch] =
          (totals[student.branch] ?? 0) + student.overall;
      counts[student.branch] = (counts[student.branch] ?? 0) + 1;
    }
    final averages = <String, double>{};
    for (final branch in totals.keys) {
      averages[branch] = double.parse(
          (totals[branch]! / counts[branch]!).toStringAsFixed(2));
    }
    return averages;
  }

  double get leetcodeAverage => _platformAverage((s) => s.leetcode.score);
  double get codeforcesAverage => _platformAverage((s) => s.codeforces.score);
  double get codechefAverage => _platformAverage((s) => s.codechef.score);

  double _platformAverage(double Function(Student) pick) {
    if (_students.isEmpty) return 0;
    final total = _students.fold<double>(0, (sum, s) => sum + pick(s));
    return total / _students.length;
  }
}
