import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop_final/views/cart_screen_page.dart';

void main() {
  testWidgets('Cart screen shows empty state or items', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CartScreen()));

    // Wait for async load to complete
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // After settling we expect the Items label to be present
    expect(find.textContaining('Items:'), findsOneWidget);
  });
}
