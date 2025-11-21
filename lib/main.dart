// ...existing code...
import 'package:flutter/material.dart';
import 'package:sandwich_shop_final/views/app_styles.dart';
import 'package:sandwich_shop_final/repositories/order_repository.dart';
import 'package:sandwich_shop_final/repositories/pricing_repository.dart';

// AppStyles moved to `lib/views/app_styles.dart`.

// PricingRepository moved to `lib/repositories/pricing_repository.dart`.

const TextStyle normalText = TextStyle(fontSize: 16);
const TextStyle heading1 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

enum BreadType { white, wheat, multigrain }

// OrderRepository moved to `lib/repositories/order_repository.dart`.

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mr Tree Sandwiches',
      theme: AppStyles.theme,
      debugShowCheckedModeBanner: false,
      home: const OrderScreen(maxQuantity: 5),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;
  const OrderScreen({Key? key, required this.maxQuantity}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late final OrderRepository _orderRepository;
  final TextEditingController _notesController = TextEditingController();
  bool _isFootlong = true;
  bool _isToasted = false;
  BreadType _selectedBreadType = BreadType.white;
  final PricingRepository _pricing = PricingRepository();

  @override
  void initState() {
    super.initState();
    _orderRepository = OrderRepository(maxQuantity: widget.maxQuantity);
    _notesController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  VoidCallback? _getIncreaseCallback() {
    if (_orderRepository.canIncrement) {
      return () => setState(_orderRepository.increment);
    }
    return null;
  }

  VoidCallback? _getDecreaseCallback() {
    if (_orderRepository.canDecrement) {
      return () => setState(_orderRepository.decrement);
    }
    return null;
  }

  void _onSandwichTypeChanged(bool value) {
    setState(() => _isFootlong = value);
  }

  void _onToastedChanged(bool value) {
    setState(() => _isToasted = value);
  }

  void _onBreadTypeSelected(BreadType? value) {
    if (value != null) {
      setState(() => _selectedBreadType = value);
    }
  }

  List<DropdownMenuEntry<BreadType>> _buildDropdownEntries() {
    List<DropdownMenuEntry<BreadType>> entries = [];
    for (BreadType bread in BreadType.values) {
      DropdownMenuEntry<BreadType> newEntry = DropdownMenuEntry<BreadType>(
        value: bread,
        label: bread.name,
      );
      entries.add(newEntry);
    }
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    String sandwichType = _isFootlong ? 'footlong' : 'six-inch';

    String noteForDisplay = _notesController.text.isEmpty
        ? 'No notes added.'
        : _notesController.text;

    final total = _pricing.calculateTotal(
      quantity: _orderRepository.quantity,
      isFootlong: _isFootlong,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Mr Tree Sandwiches', style: heading1)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OrderItemDisplay(
                quantity: _orderRepository.quantity,
                itemType: sandwichType,
                breadType: _selectedBreadType,
                orderNote: noteForDisplay,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('six-inch', style: normalText),
                  Switch(
                    key: const Key('size_switch'),
                    value: _isFootlong,
                    onChanged: _onSandwichTypeChanged,
                  ),
                  const Text('footlong', style: normalText),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not toasted', style: normalText),
                  Switch(
                    key: const Key('toasted_switch'),
                    value: _isToasted,
                    onChanged: _onToastedChanged,
                  ),
                  const Text('Toasted', style: normalText),
                ],
              ),
              const SizedBox(height: 10),
              DropdownMenu<BreadType>(
                textStyle: normalText,
                initialSelection: _selectedBreadType,
                onSelected: _onBreadTypeSelected,
                dropdownMenuEntries: _buildDropdownEntries(),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: TextField(
                  key: const Key('notes_textfield'),
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Add a note (e.g., no onions)',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StyledButton(
                    onPressed: _getIncreaseCallback(),
                    icon: Icons.add,
                    label: 'Add',
                    backgroundColor: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  StyledButton(
                    onPressed: _getDecreaseCallback(),
                    icon: Icons.remove,
                    label: 'Remove',
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Total: £${total.toStringAsFixed(2)}', style: normalText),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;
  final BreadType breadType;
  final String orderNote;

  const OrderItemDisplay({
    Key? key,
    required this.quantity,
    required this.itemType,
    required this.breadType,
    required this.orderNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Order Summary', style: heading1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quantity:', style: normalText),
                Text('$quantity', style: normalText),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Type:', style: normalText),
                Text(itemType, style: normalText),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Bread:', style: normalText),
                Text(breadType.name, style: normalText),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Note:', style: normalText),
            ),
            const SizedBox(height: 4),
            Text(orderNote, style: normalText),
          ],
        ),
      ),
    );
  }
}

class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const StyledButton({
    Key? key,
    this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: normalText),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}
// ...existing code...