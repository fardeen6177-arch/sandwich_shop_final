class PricingRepository {
  static const double _basePrice = 4.99;
  static const double _footlongMultiplier = 1.8;

  double calculateTotal({required int quantity, required bool isFootlong}) {
    double price = _basePrice;
    if (isFootlong) {
      price *= _footlongMultiplier;
    }
    return price * quantity;
  }
}
