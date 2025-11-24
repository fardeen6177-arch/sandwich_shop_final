import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop_final/views/cart_screen_page.dart';
import 'package:sandwich_shop_final/services/file_service.dart';

class FakeFileService extends FileService {
  @override
  Future<String?> read(String name) async {
    // Return a deterministic cart JSON with one veggie sandwich (quantity 2)
    return '''{"items":[{"type":"veggieDelight","isFootlong":true,"bread":"white","quantity":2}]}''';
  }
}

void main() {
  testWidgets('Cart screen shows empty state or items', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: CartScreen(fileService: FakeFileService())),
    );

    // Allow async load to proceed
    await tester.pumpAndSettle();

    // After loading, expect the Items label and our Veggie sandwich entry
    expect(find.textContaining('Items:'), findsOneWidget);
    expect(find.textContaining('Veggie Delight'), findsOneWidget);
  });
}
