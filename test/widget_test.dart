import 'package:codetrack_flutter/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('signs in with the demo credentials', (tester) async {
    await tester.pumpWidget(const CodeTrackApp());

    expect(find.text('CodeTrack'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Total students'), findsOneWidget);
    expect(find.text('Top performers'), findsOneWidget);
  });

  testWidgets('rejects invalid credentials', (tester) async {
    await tester.pumpWidget(const CodeTrackApp());

    await tester.enterText(find.byType(TextFormField).at(1), 'nope');
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(
      find.text('Invalid email or password. Use the demo credentials below.'),
      findsOneWidget,
    );
  });

  testWidgets('adds a student through the dialog', (tester) async {
    await tester.pumpWidget(const CodeTrackApp());

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Students'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add student'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Full name'), 'Kiran Das');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Roll number'), '25CSE123');
    await tester.tap(find.widgetWithText(FilledButton, 'Add student'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Kiran');
    await tester.pumpAndSettle();

    expect(find.text('Kiran Das'), findsOneWidget);
  });
}
