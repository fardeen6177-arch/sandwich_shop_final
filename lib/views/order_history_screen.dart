import 'package:flutter/material.dart';
import 'package:sandwich_shop_final/views/app_styles.dart';
import 'package:sandwich_shop_final/services/order_history_service.dart';
import 'package:sandwich_shop_final/models/saved_order.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final OrderHistoryService _service = OrderHistoryService();
  List<SavedOrder> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final orders = await _service.loadOrders();
    setState(() {
      _orders = orders;
      _isLoading = false;
    });
  }

  String _formatDate(DateTime date) {
    final d = date;
    return '${d.day}/${d.month}/${d.year} ${d.hour}:${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Order History', style: AppStyles.heading1)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Order History', style: AppStyles.heading1)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _orders.isEmpty
            ? Center(child: Text('No orders yet', style: AppStyles.heading2))
            : ListView.separated(
                itemCount: _orders.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final o = _orders[index];
                  return ListTile(
                    title: Text(o.orderId, style: AppStyles.heading2),
                    subtitle: Text(
                      '${o.itemCount} items • ${_formatDate(o.orderDate)}',
                      style: AppStyles.normalText,
                    ),
                    trailing: Text(
                      '£${o.totalAmount.toStringAsFixed(2)}',
                      style: AppStyles.heading2,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
