import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop_final/main.dart';

void main() {
  testWidgets('Switch toggles between six-inch and footlong', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());

    // Find sandwich size switch
    final switchFinder = find.byKey(const Key('size_switch'));

    expect(switchFinder, findsOneWidget);

    // Read initial value (should be true = footlong)
    Switch switchWidget = tester.widget<Switch>(switchFinder);
    expect(switchWidget.value, true);

    // Tap to toggle to six-inch
    await tester.tap(switchFinder);
    await tester.pump();

    // Verify toggled value is now false
    switchWidget = tester.widget<Switch>(switchFinder);
    expect(switchWidget.value, false);
  });

  testWidgets('Toasted switch toggles correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Find toasted switch
    final toastedFinder = find.byKey(const Key('toasted_switch'));

    expect(toastedFinder, findsOneWidget);

    // Initial value should be false
    Switch toastedSwitch = tester.widget<Switch>(toastedFinder);
    expect(toastedSwitch.value, false);

    // Tap switch
    await tester.tap(toastedFinder);
    await tester.pump();

    // Verify toggled value is now true
    toastedSwitch = tester.widget<Switch>(toastedFinder);
    expect(toastedSwitch.value, true);
  });
}
