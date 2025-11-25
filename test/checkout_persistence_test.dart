import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop_final/models/cart.dart';
import 'package:sandwich_shop_final/models/sandwich.dart';
import 'dart:io';

import 'package:sandwich_shop_final/views/checkout_screen.dart';
import 'package:sandwich_shop_final/services/order_history_service.dart';
import 'package:sandwich_shop_final/services/file_service.dart';

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
  testWidgets(
    'Confirming order persists to history',
    (tester) async {
      final testFs = TestFileService();
      final service = OrderHistoryService(testFs);
      final before = await service.loadOrders();

      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 2);

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: MaterialApp(
            home: CheckoutScreen(orderHistoryService: service),
          ),
        ),
      );

      expect(find.textContaining('Total:'), findsOneWidget);

      // Tap confirm
      final Finder confirm = find.text('Confirm Order');
      expect(confirm, findsOneWidget);
      await tester.tap(confirm);
      await tester.pumpAndSettle();

      final after = await service.loadOrders();
      expect(after.length, greaterThanOrEqualTo(before.length + 1));
    },
    timeout: Timeout(Duration(seconds: 30)),
    skip: true,
  );
}
