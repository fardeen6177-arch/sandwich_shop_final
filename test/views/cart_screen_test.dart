import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop_final/views/cart_screen_page.dart';

void main() {
  testWidgets('Cart screen shows empty state or items', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CartScreen()));

    // Either loading indicator or Items text should appear
    expect(find.byType(CircularProgressIndicator).first, findsNothing);
    expect(find.textContaining('Items:'), findsOneWidget);
  });
}
