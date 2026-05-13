import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF008080); // Teal
  static const Color accentColor = Color(0xFF004D40);
  static const Color backgroundLight = Color(0xFFF5F9F9);
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textGrey = Color(0xFF7F8C8D);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      useMaterial3: true,
    );
  }
}
