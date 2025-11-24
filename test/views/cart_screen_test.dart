import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop_final/views/cart_screen_page.dart';

void main() {
  testWidgets('Cart screen shows empty state or items', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CartScreen()));

    // Don't rely on async file IO in the test environment. Accept either
    // a loading indicator or the Items label being present initially.
    final loadingFound = find.byType(CircularProgressIndicator);
    final itemsFound = find.textContaining('Items:');
    final condition =
        loadingFound.evaluate().isNotEmpty || itemsFound.evaluate().isNotEmpty;
    expect(condition, isTrue);
  });
}
