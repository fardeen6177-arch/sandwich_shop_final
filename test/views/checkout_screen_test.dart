import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop_final/views/checkout_screen.dart';
import 'package:sandwich_shop_final/models/cart.dart';
import 'package:sandwich_shop_final/models/sandwich.dart';

void main() {
  testWidgets('Checkout screen shows order summary and confirm button', (
    tester,
  ) async {
    final cart = Cart();
    cart.add(
      Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      ),
      quantity: 2,
    );

    await tester.pumpWidget(MaterialApp(home: CheckoutScreen(cart: cart)));

    expect(find.text('Order Summary'), findsOneWidget);
    expect(find.textContaining('Veggie'), findsWidgets);
    expect(find.text('Confirm Payment'), findsOneWidget);
  });
}
