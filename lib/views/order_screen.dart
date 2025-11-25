import 'package:flutter/material.dart';
import 'package:sandwich_shop_final/views/app_styles.dart';
import 'package:sandwich_shop_final/models/sandwich.dart';
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:sandwich_shop_final/models/cart.dart';
import 'package:sandwich_shop_final/services/file_service.dart';
import 'package:sandwich_shop_final/views/cart_screen.dart';
import 'package:sandwich_shop_final/views/cart_screen_page.dart';
import 'package:sandwich_shop_final/views/styled_button.dart';
import 'package:sandwich_shop_final/views/settings_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:sandwich_shop_final/views/order_history_screen.dart';
import 'package:sandwich_shop_final/views/dev_log.dart';
import 'package:sandwich_shop_final/services/dev_logger.dart';
// dev logger is used by the dev log screen; keep import for clarity
// profile_screen import removed (not used here)

class OrderScreen extends StatefulWidget {
  final int maxQuantity;
  const OrderScreen({super.key, required this.maxQuantity});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final FileService _fileService = FileService();
  final TextEditingController _notesController = TextEditingController();
  String? _confirmationMessage;

  SandwichType _selectedSandwichType = SandwichType.veggieDelight;
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _notesController.addListener(() {
      setState(() {});
    });
    // no local cart; use Provider for Cart access
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _addToCart() {
    if (_quantity > 0) {
      final Sandwich sandwich = Sandwich(
        type: _selectedSandwichType,
        isFootlong: _isFootlong,
        breadType: _selectedBreadType,
      );

      final cart = Provider.of<Cart>(context, listen: false);
      cart.add(sandwich, quantity: _quantity);

      String sizeText = _isFootlong ? 'footlong' : 'six-inch';
      String confirmationMessage =
          'Added $_quantity $sizeText ${sandwich.name} sandwich(es) on ${_selectedBreadType.name} bread to cart';

      setState(() => _confirmationMessage = confirmationMessage);
      // Log add-to-cart for debugging
      DevLogger.instance.log(
        'Added $_quantity ${sandwich.name} (footlong=${sandwich.isFootlong}) to cart',
      );
    }
  }

  VoidCallback? _getAddToCartCallback() {
    if (_quantity > 0) {
      return _addToCart;
    }
    return null;
  }

  Future<void> _saveCart() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final cart = Provider.of<Cart>(context, listen: false);
      final jsonStr = jsonEncode(cart.toJson());
      await _fileService.save('cart.json', jsonStr);
      DevLogger.instance.log('Cart saved to cart.json');
      if (!mounted) return;
      setState(() => _confirmationMessage = 'Cart saved');
      messenger.showSnackBar(const SnackBar(content: Text('Cart saved')));
    } catch (e, st) {
      // Log and show error
      // ignore: avoid_print
      print('Failed to save cart: $e\n$st');
      DevLogger.instance.log('Failed to save cart: $e');
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Failed to save cart: $e')),
        );
      }
    }
  }

  Future<void> _loadCart() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final data = await _fileService.read('cart.json');
      if (data == null) {
        DevLogger.instance.log('No saved cart found (cart.json missing)');
        if (!mounted) return;
        setState(() => _confirmationMessage = 'No saved cart found');
        messenger.showSnackBar(
          const SnackBar(content: Text('No saved cart found')),
        );
        return;
      }
      final Map<String, dynamic> parsed =
          jsonDecode(data) as Map<String, dynamic>;
      final Cart loaded = Cart.fromJson(parsed);
      if (!mounted) return;
      final cart = Provider.of<Cart>(context, listen: false);
      cart.clearAndLoadFrom(loaded);
      DevLogger.instance.log('Cart loaded from cart.json');
      setState(() => _confirmationMessage = 'Cart loaded');
      messenger.showSnackBar(const SnackBar(content: Text('Cart loaded')));
    } catch (e, st) {
      // ignore: avoid_print
      print('Failed to load cart: $e\n$st');
      DevLogger.instance.log('Failed to load cart: $e');
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Failed to load cart: $e')),
        );
      }
    }
  }

  List<DropdownMenuEntry<SandwichType>> _buildSandwichTypeEntries() {
    List<DropdownMenuEntry<SandwichType>> entries = [];
    for (SandwichType type in SandwichType.values) {
      Sandwich sandwich = Sandwich(
        type: type,
        isFootlong: true,
        breadType: BreadType.white,
      );
      DropdownMenuEntry<SandwichType> entry = DropdownMenuEntry<SandwichType>(
        value: type,
        label: sandwich.name,
      );
      entries.add(entry);
    }
    return entries;
  }

  List<DropdownMenuEntry<BreadType>> _buildBreadTypeEntries() {
    List<DropdownMenuEntry<BreadType>> entries = [];
    for (BreadType bread in BreadType.values) {
      DropdownMenuEntry<BreadType> entry = DropdownMenuEntry<BreadType>(
        value: bread,
        label: bread.name,
      );
      entries.add(entry);
    }
    return entries;
  }

  String _getCurrentImagePath() {
    final Sandwich sandwich = Sandwich(
      type: _selectedSandwichType,
      isFootlong: _isFootlong,
      breadType: _selectedBreadType,
    );
    return sandwich.image;
  }

  void _onSandwichTypeChanged(SandwichType? value) {
    if (value != null) {
      setState(() {
        _selectedSandwichType = value;
      });
    }
  }

  void _onSizeChanged(bool value) {
    setState(() {
      _isFootlong = value;
    });
  }

  void _onBreadTypeChanged(BreadType? value) {
    if (value != null) {
      setState(() {
        _selectedBreadType = value;
      });
    }
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }

  VoidCallback? _getDecreaseCallback() {
    if (_quantity > 0) {
      return _decreaseQuantity;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sandwich Counter', style: AppStyles.heading1),
        actions: [
          // Dev log button (debug builds only)
          if (kDebugMode)
            IconButton(
              tooltip: 'Dev Log',
              icon: const Icon(Icons.bug_report),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DevLogScreen()),
              ),
            ),
          IconButton(
            tooltip: 'Cart',
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Orders',
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 300,
                child: Image.asset(
                  _getCurrentImagePath(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        'Image not found',
                        style: AppStyles.normalText,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              DropdownMenu<SandwichType>(
                width: double.infinity,
                label: const Text('Sandwich Type'),
                textStyle: AppStyles.normalText,
                initialSelection: _selectedSandwichType,
                onSelected: _onSandwichTypeChanged,
                dropdownMenuEntries: _buildSandwichTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Six-inch', style: AppStyles.normalText),
                  Switch(
                    key: const Key('size_switch'),
                    value: _isFootlong,
                    onChanged: _onSizeChanged,
                  ),
                  Text('Footlong', style: AppStyles.normalText),
                ],
              ),
              const SizedBox(height: 20),
              DropdownMenu<BreadType>(
                width: double.infinity,
                label: const Text('Bread Type'),
                textStyle: AppStyles.normalText,
                initialSelection: _selectedBreadType,
                onSelected: _onBreadTypeChanged,
                dropdownMenuEntries: _buildBreadTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Quantity: ', style: AppStyles.normalText),
                  IconButton(
                    onPressed: _getDecreaseCallback(),
                    icon: const Icon(Icons.remove),
                  ),
                  Text('$_quantity', style: AppStyles.heading2),
                  IconButton(
                    onPressed: _increaseQuantity,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              StyledButton(
                key: const Key('add_to_cart'),
                onPressed: _getAddToCartCallback(),
                icon: Icons.add_shopping_cart,
                label: 'Add to Cart',
                backgroundColor: Colors.green,
              ),
              const SizedBox(height: 12),
              // Confirmation message
              if (_confirmationMessage != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    _confirmationMessage!,
                    key: const Key('confirmation_text'),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              // Cart summary
              const CartSummary(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StyledButton(
                    onPressed: _saveCart,
                    icon: Icons.save,
                    label: 'Save Cart',
                    backgroundColor: Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  StyledButton(
                    onPressed: _loadCart,
                    icon: Icons.folder_open,
                    label: 'Load Cart',
                    backgroundColor: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.shopping_cart),
        label: const Text('View Cart'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CartScreen()),
        ),
      ),
    );
  }
}
