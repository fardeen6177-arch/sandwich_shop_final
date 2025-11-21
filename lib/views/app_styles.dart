import 'package:flutter/material.dart';

class AppStyles {
  static final ThemeData theme = ThemeData(
    primarySwatch: Colors.green,
    appBarTheme: const AppBarTheme(centerTitle: true),
    scaffoldBackgroundColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
    ),
  );

  // Common text styles used across the app
  static const TextStyle normalText = TextStyle(fontSize: 16);
  static const TextStyle heading1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
}
