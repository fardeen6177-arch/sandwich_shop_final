import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop_final/models/cart.dart';
import 'package:sandwich_shop_final/views/app_styles.dart';
import 'package:sandwich_shop_final/services/order_history_service.dart';
import 'package:sandwich_shop_final/models/saved_order.dart';

class CheckoutScreen extends StatefulWidget {
  final dynamic orderHistoryService;

  const CheckoutScreen({super.key, this.orderHistoryService});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _processing = false;

  Future<void> _confirmOrder() async {
    final cart = Provider.of<Cart>(context, listen: false);
    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 1));

    // Simulate order id and estimated time
    final rnd = Random();
    final orderId = 'ORD${1000 + rnd.nextInt(9000)}';
    final estimated = '${10 + rnd.nextInt(20)} mins';
    final service =
        widget.orderHistoryService as OrderHistoryService? ??
        OrderHistoryService();
    final saved = SavedOrder(
      id: 0,
      orderId: orderId,
      totalAmount: cart.totalPrice,
      itemCount: cart.totalItems,
      orderDate: DateTime.now(),
    );
    await service.saveOrder(saved);
    // Clear the cart now that the order is persisted
    cart.clear();

    if (!mounted) return;
    Navigator.pop(context, {'orderId': orderId, 'estimatedTime': estimated});
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Checkout', style: AppStyles.heading1)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Items: ${cart.totalItems}', style: AppStyles.normalText),
            const SizedBox(height: 8),
            Text(
              'Total: £${cart.totalPrice.toStringAsFixed(2)}',
              style: AppStyles.heading2,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final it = cart.items[index];
                  return ListTile(
                    title: Text(it.sandwich.name, style: AppStyles.normalText),
                    subtitle: Text(
                      '${it.quantity} x ${it.sandwich.isFootlong ? 'Footlong' : 'Six-inch'}',
                    ),
                    trailing: Text(
                      '£${(it.quantity * (it.sandwich.isFootlong ? 11.0 : 7.0)).toStringAsFixed(2)}',
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _processing ? null : _confirmOrder,
              child: _processing
                  ? const CircularProgressIndicator()
                  : const Text('Confirm Order'),
            ),
          ],
        ),
      ),
    );
  }
}
