import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_shop_final/main.dart';

void main() {
  testWidgets('Adds item to cart updates summary and shows confirmation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());

    // Initially items should be 0
    final itemsFinder = find.byKey(const Key('cart_items'));
    final totalFinder = find.byKey(const Key('cart_total'));
    expect(itemsFinder, findsOneWidget);
    expect(totalFinder, findsOneWidget);
    expect(find.textContaining('Items: 0'), findsOneWidget);

    // Tap Add to Cart button (ensure visible first)
    final addButton = find.byKey(const Key('add_to_cart'));
    expect(addButton, findsOneWidget);
    await tester.ensureVisible(addButton);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // After adding default quantity 1 of six-inch Veggie (default), items should be 1 and total £7.00
    final itemsFinder2 = find.byKey(const Key('cart_items'));
    final totalFinder2 = find.byKey(const Key('cart_total'));
    expect(itemsFinder2, findsOneWidget);
    expect(totalFinder2, findsOneWidget);
    final itemsText = tester.widget<Text>(itemsFinder2).data;
    final totalText = tester.widget<Text>(totalFinder2).data;
    expect(itemsText, 'Items: 1');
    // Default sandwich size in the UI is footlong => £11.00
    expect(totalText, 'Total: £11.00');

    // Confirmation message displayed
    final confirmation = find.byKey(const Key('confirmation_text'));
    expect(confirmation, findsOneWidget);
  });
}
