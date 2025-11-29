import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop_final/views/profile_screen.dart';

void main() {
  testWidgets('Profile screen has name and email fields and save button', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('ProfileScreen displays and saves user input', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

    // Enter name and email
    await tester.enterText(find.byType(TextField).at(0), 'Test User');
    await tester.enterText(find.byType(TextField).at(1), 'test@example.com');

    // Tap Save button
    await tester.tap(find.text('Save'));
    await tester.pump();

    // Check for SnackBar
    expect(find.textContaining('Profile saved'), findsOneWidget);
  });
}
