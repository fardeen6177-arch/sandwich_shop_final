import 'package:flutter/material.dart';
import 'package:sandwich_shop_final/models/cart.dart';
import 'package:sandwich_shop_final/views/app_styles.dart';

class CartSummary extends StatelessWidget {
  final Cart cart;

  const CartSummary({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Items: ${cart.totalItems}', key: const Key('cart_items')),
          Text(
            'Total: £${cart.totalPrice.toStringAsFixed(2)}',
            key: const Key('cart_total'),
          ),
        ],
      ),
    );
  }
}
