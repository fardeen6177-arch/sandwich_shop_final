// ...existing code...
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop_final/views/app_styles.dart';
import 'package:sandwich_shop_final/views/order_screen.dart';
import 'package:sandwich_shop_final/models/cart.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStyles.loadFontSize();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => Cart(),
      child: MaterialApp(
        title: 'Sandwich Shop App',
        theme: AppStyles.theme,
        debugShowCheckedModeBanner: false,
        home: const OrderScreen(maxQuantity: 5),
      ),
    );
  }
}
