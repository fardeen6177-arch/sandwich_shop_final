import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop_final/models/cart.dart';
import 'package:sandwich_shop_final/views/order_screen.dart';

void main() {
  testWidgets('navigates to Settings screen from OrderScreen', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<Cart>(
        create: (_) => Cart(),
        child: const MaterialApp(home: OrderScreen(maxQuantity: 5)),
      ),
    );

    // Tap settings icon (tooltip 'Settings')
    final Finder settingsIcon = find.byTooltip('Settings');
    expect(settingsIcon, findsOneWidget);

    await tester.tap(settingsIcon);
    await tester.pump();
    // Allow the pushed route to build its first frame (loading state)
    await tester.pump(const Duration(seconds: 1));
    final bool settingsShown =
        tester.any(find.byType(CircularProgressIndicator)) ||
        tester.any(find.text('Settings'));
    expect(settingsShown, isTrue);
  });

  testWidgets('navigates to Order History from OrderScreen', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<Cart>(
        create: (_) => Cart(),
        child: const MaterialApp(home: OrderScreen(maxQuantity: 5)),
      ),
    );

    final Finder ordersIcon = find.byTooltip('Orders');
    expect(ordersIcon, findsOneWidget);

    await tester.tap(ordersIcon);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Order History'), findsOneWidget);
  });
}
