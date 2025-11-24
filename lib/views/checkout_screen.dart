import 'package:flutter/material.dart';
import 'package:sandwich_shop_final/views/app_styles.dart';
import 'package:sandwich_shop_final/models/cart.dart';
import 'package:sandwich_shop_final/models/sandwich.dart';
import 'package:sandwich_shop_final/repositories/pricing_repository.dart';

class CheckoutScreen extends StatefulWidget {
  final Cart cart;

  const CheckoutScreen({super.key, required this.cart});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final orderId = 'ORD$timestamp';

    final orderConfirmation = {
      'orderId': orderId,
      'totalAmount': widget.cart.totalPrice,
      'itemCount': widget.cart.totalItems,
      'estimatedTime': '15-20 minutes',
    };

    if (mounted) Navigator.pop(context, orderConfirmation);
  }

  double _calculateItemPrice(Sandwich sandwich, int quantity) {
    final repo = PricingRepository();
    return repo.calculateTotal(
      quantity: quantity,
      isFootlong: sandwich.isFootlong,
    );
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    children.add(const Text('Order Summary', style: AppStyles.heading2));
    children.add(const SizedBox(height: 20));

    for (final it in widget.cart.items) {
      final itemPrice = _calculateItemPrice(it.sandwich, it.quantity);
      children.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${it.quantity}x ${it.sandwich.name}',
              style: AppStyles.normalText,
            ),
            Text(
              '£${itemPrice.toStringAsFixed(2)}',
              style: AppStyles.normalText,
            ),
          ],
        ),
      );
      children.add(const SizedBox(height: 8));
    }

    children.add(const Divider());
    children.add(const SizedBox(height: 10));
    children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total:', style: AppStyles.heading2),
          Text(
            '£${widget.cart.totalPrice.toStringAsFixed(2)}',
            style: AppStyles.heading2,
          ),
        ],
      ),
    );
    children.add(const SizedBox(height: 40));

    children.add(
      const Text(
        'Payment Method: Card ending in 1234',
        style: AppStyles.normalText,
        textAlign: TextAlign.center,
      ),
    );
    children.add(const SizedBox(height: 20));

    if (_isProcessing) {
      children.add(const Center(child: CircularProgressIndicator()));
      children.add(const SizedBox(height: 20));
      children.add(
        const Text(
          'Processing payment...',
          style: AppStyles.normalText,
          textAlign: TextAlign.center,
        ),
      );
    } else {
      children.add(
        ElevatedButton(
          onPressed: _processPayment,
          child: const Text('Confirm Payment', style: AppStyles.normalText),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout', style: AppStyles.heading1)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(children: children),
      ),
    );
  }
}
