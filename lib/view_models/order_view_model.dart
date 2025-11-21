import 'dart:convert';
import 'package:sandwich_shop_final/models/cart.dart';
import 'package:sandwich_shop_final/services/file_service.dart';

class OrderViewModel {
  final Cart cart;
  final FileService fileService;

  OrderViewModel({Cart? cart, FileService? fileService})
    : cart = cart ?? Cart(),
      fileService = fileService ?? FileService();

  void addToCart(cartItem) {
    // Delegates to Cart (UI layer will call Cart methods directly in this app).
  }

  Future<void> saveCart(String filename) async {
    final json = cart.toJson();
    await fileService.save(filename, jsonEncode(json));
  }

  Future<bool> loadCart(String filename) async {
    final content = await fileService.read(filename);
    if (content == null) return false;
    final decoded = jsonDecode(content) as Map<String, dynamic>;
    final loaded = Cart.fromJson(decoded);
    cart.clearAndLoadFrom(loaded);
    return true;
  }
}
