import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop_final/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('name getter returns human readable name', () {
      final s = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      expect(s.name, 'Veggie Delight');
    });

    test('image getter constructs expected path', () {
      final s = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      expect(s.image, 'images/${SandwichType.tunaMelt.name}_six_inch.png');
    });
  });
}
