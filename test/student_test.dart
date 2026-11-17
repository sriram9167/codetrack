import 'package:codetrack_flutter/models/student.dart';
import 'package:codetrack_flutter/state/app_state.dart';
import 'package:flutter_test/flutter_test.dart';

Student buildStudent({
  double leetcode = 8,
  double codeforces = 7,
  double codechef = 6,
  double consistency = 5,
  double problemSolving = 9,
}) {
  PlatformStat stat(String name, double score) => PlatformStat(
        name: name,
        handle: 'handle',
        rating: 1500,
        solved: 200,
        score: score,
      );

  return Student(
    id: 1,
    name: 'Test Student',
    rollNumber: '23CSE999',
    branch: 'CSE',
    year: 2,
    email: 'test@college.edu',
    leetcode: stat('LeetCode', leetcode),
    codeforces: stat('Codeforces', codeforces),
    codechef: stat('CodeChef', codechef),
    consistency: consistency,
    problemSolving: problemSolving,
    lastSynced: DateTime.now(),
  );
}

void main() {
  group('Student', () {
    test('computes the weighted overall score', () {
      final student = buildStudent();
      expect(student.overall, closeTo(7.2, 0.001));
    });

    test('flags students below the 5.0 threshold', () {
      final student = buildStudent(
        leetcode: 3,
        codeforces: 3,
        codechef: 3,
        consistency: 3,
        problemSolving: 3,
      );
      expect(student.overall, closeTo(3.0, 0.001));
      expect(student.isAtRisk, isTrue);
      expect(buildStudent().isAtRisk, isFalse);
    });

    test('builds initials from the full name', () {
      expect(buildStudent().initials, 'TS');
    });
  });

  group('AppState', () {
    test('authenticates only with the demo credentials', () {
      final state = AppState();
      expect(state.login(demoEmail, 'wrong'), isFalse);
      expect(state.isAuthenticated, isFalse);
      expect(state.login(demoEmail, demoPassword), isTrue);
      expect(state.isAuthenticated, isTrue);
      state.logout();
      expect(state.isAuthenticated, isFalse);
      state.dispose();
    });

    test('adds a student and finds it by search', () {
      final state = AppState();
      final before = state.students.length;
      state.addStudent(
        name: 'New Recruit',
        rollNumber: '25CSE100',
        email: 'new@college.edu',
        branch: 'CSE',
        year: 1,
      );
      expect(state.students.length, before + 1);
      expect(state.search('25cse100').single.name, 'New Recruit');
      expect(state.search('AI&DS').isNotEmpty, isTrue);
      state.dispose();
    });

    test('sync updates the timestamp of a student', () {
      final state = AppState();
      final student = state.students.first;
      final oldTime = DateTime.now().subtract(const Duration(days: 6));
      student.lastSynced = oldTime;
      state.syncStudent(student.id);
      expect(student.lastSynced.isAfter(oldTime), isTrue);
      state.dispose();
    });
  });
}
