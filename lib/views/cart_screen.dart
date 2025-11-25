import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop_final/models/cart.dart';
import 'package:sandwich_shop_final/views/app_styles.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Consumer<Cart>(
        builder: (context, cart, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Items: ${cart.totalItems}',
                key: const Key('cart_items'),
                style: AppStyles.normalText,
              ),
              Text(
                'Total: £${cart.totalPrice.toStringAsFixed(2)}',
                key: const Key('cart_total'),
                style: AppStyles.normalText,
              ),
            ],
          );
        },
      ),
    );
  }
}
