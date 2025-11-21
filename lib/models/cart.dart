import 'package:sandwich_shop_final/models/sandwich.dart';
import 'package:sandwich_shop_final/repositories/pricing_repository.dart';

class CartItem {
  final Sandwich sandwich;
  int quantity;

  CartItem({required this.sandwich, required this.quantity});
}

class Cart {
  final List<CartItem> _items = [];
  final PricingRepository _pricing = PricingRepository();

  void add(Sandwich sandwich, {int quantity = 1}) {
    final existing = _items.firstWhere(
      (it) =>
          it.sandwich.type == sandwich.type &&
          it.sandwich.isFootlong == sandwich.isFootlong &&
          it.sandwich.breadType == sandwich.breadType,
      orElse: () => CartItem(sandwich: sandwich, quantity: 0),
    );

    if (existing.quantity == 0) {
      _items.add(CartItem(sandwich: sandwich, quantity: quantity));
    } else {
      existing.quantity += quantity;
    }
  }

  int get totalItems {
    int sum = 0;
    for (final it in _items) {
      sum += it.quantity;
    }
    return sum;
  }

  double get totalPrice {
    double total = 0.0;
    for (final it in _items) {
      total += _pricing.calculateTotal(
        quantity: it.quantity,
        isFootlong: it.sandwich.isFootlong,
      );
    }
    return total;
  }

  List<CartItem> get items => List.unmodifiable(_items);
}
