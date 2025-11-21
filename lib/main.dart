// ...existing code...
import 'package:flutter/material.dart';
import 'package:sandwich_shop_final/views/app_styles.dart';
import 'package:sandwich_shop_final/views/order_screen.dart';

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
