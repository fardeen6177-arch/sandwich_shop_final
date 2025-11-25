import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStyles {
  static final ThemeData theme = ThemeData(
    primarySwatch: Colors.green,
    appBarTheme: const AppBarTheme(centerTitle: true),
    scaffoldBackgroundColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
    ),
  );

  static double _baseFontSize = 16.0;

  static Future<void> loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    _baseFontSize = prefs.getDouble('fontSize') ?? 16.0;
  }

  static Future<void> saveFontSize(double fontSize) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', fontSize);
    _baseFontSize = fontSize;
  }

  static double get baseFontSize => _baseFontSize;

  static TextStyle get normalText => TextStyle(fontSize: _baseFontSize);
  static TextStyle get heading1 =>
      TextStyle(fontSize: _baseFontSize + 8, fontWeight: FontWeight.bold);
  static TextStyle get heading2 =>
      TextStyle(fontSize: _baseFontSize + 4, fontWeight: FontWeight.bold);
}

// Backwards-compatible top-level getters
TextStyle get normalText => AppStyles.normalText;
TextStyle get heading1 => AppStyles.heading1;
TextStyle get heading2 => AppStyles.heading2;
