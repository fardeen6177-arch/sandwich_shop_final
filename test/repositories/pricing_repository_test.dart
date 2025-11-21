import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop_final/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    test('six-inch price for quantity 1', () {
      final repo = PricingRepository();
      final total = repo.calculateTotal(quantity: 1, isFootlong: false);
      expect(total, 7.0);
    });

    test('footlong price for quantity 1', () {
      final repo = PricingRepository();
      final total = repo.calculateTotal(quantity: 1, isFootlong: true);
      expect(total, 11.0);
    });

    test('total scales with quantity', () {
      final repo = PricingRepository();
      final total = repo.calculateTotal(quantity: 3, isFootlong: true);
      expect(total, 33.0);
    });
  });
}
