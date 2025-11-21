class PricingRepository {
  static const double _sixInchPrice = 7.0; // £7
  static const double _footlongPrice = 11.0; // £11

  double calculateTotal({required int quantity, required bool isFootlong}) {
    final unitPrice = isFootlong ? _footlongPrice : _sixInchPrice;
    return unitPrice * quantity;
  }
}
