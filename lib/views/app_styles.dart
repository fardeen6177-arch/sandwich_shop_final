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
}
