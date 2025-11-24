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
}
