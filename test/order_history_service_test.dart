import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop_final/services/order_history_service.dart';
import 'package:sandwich_shop_final/services/file_service.dart';
import 'package:sandwich_shop_final/models/saved_order.dart';

class TestFileService extends FileService {
  final String dirPath;
  TestFileService()
    : dirPath = Directory.systemTemp.createTempSync('orders_test').path;
  @override
  Future<void> save(String name, String content) async {
    final file = File('$dirPath/$name');
    await file.writeAsString(content);
  }

  @override
  Future<String?> read(String name) async {
    final file = File('$dirPath/$name');
    if (await file.exists()) return file.readAsString();
    return null;
  }
}

void main() {
  test('OrderHistoryService save and load', () async {
    final fs = TestFileService();
    final service = OrderHistoryService(fs);

    final before = await service.loadOrders();

    final order = SavedOrder(
      id: 0,
      orderId: 'TST123',
      totalAmount: 10.5,
      itemCount: 2,
      orderDate: DateTime.now(),
    );
    await service.saveOrder(order);

    final after = await service.loadOrders();
    expect(after.length, before.length + 1);
    expect(after.first.orderId, 'TST123');
  });
}
