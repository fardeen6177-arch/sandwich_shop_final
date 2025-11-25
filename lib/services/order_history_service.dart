import 'dart:convert';
import 'package:sandwich_shop_final/models/saved_order.dart';
import 'package:sandwich_shop_final/services/file_service.dart';

class OrderHistoryService {
  final FileService _fileService = FileService();
  final String _fileName = 'orders.json';

  Future<List<SavedOrder>> loadOrders() async {
    final data = await _fileService.read(_fileName);
    if (data == null) return [];
    final List<dynamic> parsed = jsonDecode(data) as List<dynamic>;
    final List<SavedOrder> orders = parsed.map((e) {
      final map = Map<String, dynamic>.from(e as Map);
      return SavedOrder.fromMap(map);
    }).toList();
    return orders;
  }

  Future<void> saveOrder(SavedOrder order) async {
    final orders = await loadOrders();
    final nextId = (orders.isEmpty) ? 1 : (orders.first.id + 1);
    final orderWithId = SavedOrder(
      id: nextId,
      orderId: order.orderId,
      totalAmount: order.totalAmount,
      itemCount: order.itemCount,
      orderDate: order.orderDate,
    );
    final List<Map<String, Object?>> out = [
      orderWithId.toMap(),
      ...orders.map((o) => o.toMap()),
    ];
    await _fileService.save(_fileName, jsonEncode(out));
  }
}
