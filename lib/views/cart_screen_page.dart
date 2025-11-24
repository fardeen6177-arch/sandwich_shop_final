import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sandwich_shop_final/views/app_styles.dart';
import 'package:sandwich_shop_final/services/file_service.dart';
import 'package:sandwich_shop_final/models/cart.dart';
import 'package:sandwich_shop_final/views/checkout_screen.dart';
import 'package:sandwich_shop_final/views/app_drawer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FileService _fs = FileService();
  Cart _cart = Cart();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final content = await _fs.read('cart.json');
    if (content != null) {
      final decoded = jsonDecode(content) as Map<String, dynamic>;
      setState(() {
        _cart = Cart.fromJson(decoded);
        _loading = false;
      });
    } else {
      setState(() {
        _cart = Cart();
        _loading = false;
      });
    }
  }

  Future<void> _navigateToCheckout() async {
    if (_cart.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty')));
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CheckoutScreen(cart: _cart)),
    );

    if (result != null && mounted) {
      setState(() => _cart = Cart());
      final orderId = result['orderId'] as String? ?? 'UNKNOWN';
      final estimatedTime = result['estimatedTime'] as String? ?? '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order $orderId confirmed! Estimated: $estimatedTime'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart', style: AppStyles.heading1)),
      drawer: const AppDrawer(),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Items: ${_cart.totalItems}',
                    style: AppStyles.normalText,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _cart.items.length,
                      itemBuilder: (context, index) {
                        final it = _cart.items[index];
                        return ListTile(
                          title: Text(
                            '${it.quantity}x ${it.sandwich.name}',
                            style: AppStyles.normalText,
                          ),
                          subtitle: Text(
                            '${it.sandwich.breadType.name} • ${it.sandwich.isFootlong ? 'Footlong' : 'Six-inch'}',
                          ),
                          trailing: Text(
                            '£${_cart.totalPrice.toStringAsFixed(2)}',
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _navigateToCheckout,
                    icon: const Icon(Icons.payment),
                    label: const Text('Checkout'),
                  ),
                ],
              ),
            ),
    );
  }
}
