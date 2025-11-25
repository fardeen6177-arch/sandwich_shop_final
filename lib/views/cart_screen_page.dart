import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop_final/models/cart.dart';
import 'package:sandwich_shop_final/views/app_styles.dart';
import 'package:sandwich_shop_final/models/sandwich.dart';
import 'package:sandwich_shop_final/repositories/pricing_repository.dart';
import 'package:sandwich_shop_final/views/checkout_screen.dart';
import 'package:sandwich_shop_final/views/styled_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<void> _navigateToCheckout() async {
    final cart = Provider.of<Cart>(context, listen: false);

    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CheckoutScreen()),
    );

    if (result != null && mounted) {
      cart.clear();
      final String orderId = result['orderId'] as String;
      final String estimatedTime = result['estimatedTime'] as String;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Order $orderId confirmed! Estimated time: $estimatedTime',
          ),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  String _getSizeText(bool isFootlong) => isFootlong ? 'Footlong' : 'Six-inch';

  double _getItemPrice(Sandwich sandwich, int quantity) {
    final repo = PricingRepository();
    return repo.calculateTotal(
      quantity: quantity,
      isFootlong: sandwich.isFootlong,
    );
  }

  void _incrementQuantity(Sandwich sandwich) {
    final cart = Provider.of<Cart>(context, listen: false);
    cart.add(sandwich, quantity: 1);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Quantity increased')));
  }

  void _decrementQuantity(Sandwich sandwich) {
    final cart = Provider.of<Cart>(context, listen: false);
    final wasPresent = cart.items.any(
      (it) =>
          it.sandwich.type == sandwich.type &&
          it.sandwich.isFootlong == sandwich.isFootlong &&
          it.sandwich.breadType == sandwich.breadType,
    );
    cart.remove(sandwich, quantity: 1);
    if (!cart.items.any(
          (it) =>
              it.sandwich.type == sandwich.type &&
              it.sandwich.isFootlong == sandwich.isFootlong &&
              it.sandwich.breadType == sandwich.breadType,
        ) &&
        wasPresent) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item removed from cart')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Quantity decreased')));
    }
  }

  void _removeItem(Sandwich sandwich) {
    final cart = Provider.of<Cart>(context, listen: false);
    cart.remove(sandwich, quantity: cart.getQuantity(sandwich));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Item removed from cart')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart View', style: AppStyles.heading1)),
      body: Center(
        child: SingleChildScrollView(
          child: Consumer<Cart>(
            builder: (context, cart, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  if (cart.items.isEmpty)
                    const Text(
                      'Your cart is empty.',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    )
                  else
                    for (final it in cart.items)
                      Column(
                        children: [
                          Text(it.sandwich.name, style: AppStyles.heading2),
                          Text(
                            '${_getSizeText(it.sandwich.isFootlong)} on ${it.sandwich.breadType.name} bread',
                            style: AppStyles.normalText,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () =>
                                    _decrementQuantity(it.sandwich),
                              ),
                              Text(
                                'Qty: ${it.quantity}',
                                style: AppStyles.normalText,
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () =>
                                    _incrementQuantity(it.sandwich),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '£${_getItemPrice(it.sandwich, it.quantity).toStringAsFixed(2)}',
                                style: AppStyles.normalText,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'Remove item',
                                onPressed: () => _removeItem(it.sandwich),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                  Text(
                    'Total: £${cart.totalPrice.toStringAsFixed(2)}',
                    style: AppStyles.heading2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if (cart.items.isNotEmpty)
                    StyledButton(
                      onPressed: _navigateToCheckout,
                      icon: Icons.payment,
                      label: 'Checkout',
                      backgroundColor: Colors.orange,
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(height: 20),
                  StyledButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icons.arrow_back,
                    label: 'Back to Order',
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
