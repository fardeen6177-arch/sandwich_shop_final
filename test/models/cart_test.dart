import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop_final/models/cart.dart';
import 'package:sandwich_shop_final/models/sandwich.dart';

void main() {
  group('Cart model', () {
    test('adding items updates total items', () {
      final cart = Cart();
      final s = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(s, quantity: 2);
      expect(cart.totalItems, 2);
    });

    test('total price uses PricingRepository', () {
      final cart = Cart();
      final s1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white,
      );
      final s2 = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.wheat,
      );
      cart.add(s1, quantity: 1); // six-inch => £7
      cart.add(s2, quantity: 2); // footlong => £11 each => 22
      expect(cart.totalPrice, 7.0 + 22.0);
    });
  });
}
