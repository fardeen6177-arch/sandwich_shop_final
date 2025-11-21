class OrderRepository {
  int quantity = 0;
  final int maxQuantity;

  OrderRepository({required this.maxQuantity});

  bool get canIncrement => quantity < maxQuantity;
  bool get canDecrement => quantity > 0;

  void increment() {
    if (canIncrement) quantity++;
  }

  void decrement() {
    if (canDecrement) quantity--;
  }
}
