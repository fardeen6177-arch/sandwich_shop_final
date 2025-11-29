// ...existing code...
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sandwich_shop_final/views/app_styles.dart';
import 'package:sandwich_shop_final/views/order_screen.dart';
import 'package:sandwich_shop_final/views/cart_screen_page.dart';
import 'package:sandwich_shop_final/views/profile_screen.dart';
import 'package:sandwich_shop_final/views/about_screen.dart';
import 'package:sandwich_shop_final/views/checkout_screen.dart';
import 'package:sandwich_shop_final/views/settings_screen.dart';
import 'package:sandwich_shop_final/models/cart.dart';

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const OrderScreen(maxQuantity: 5),
      routes: [
        GoRoute(path: 'cart', builder: (context, state) => const CartScreen()),
        GoRoute(
          path: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: 'about',
          builder: (context, state) => const AboutScreen(),
        ),
        GoRoute(
          path: 'checkout',
          builder: (context, state) => CheckoutScreen(
            cart: state.extra as Cart? ?? Cart(),
          ),
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mr Tree Sandwiches',
      theme: AppStyles.theme,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
