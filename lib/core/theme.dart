import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0F4D3A); // Dark Teal
  static const Color accentColor = Color(0xFFD4AF37); // Gold
  static const Color backgroundLight = Color(0xFFF5F9F9);
  static const Color backgroundDark = Color(0xFF0A1F18);
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
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        brightness: Brightness.dark,
        surface: const Color(0xFF0D2820),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0D2820),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF0D2820),
      ),
      useMaterial3: true,
    );
  }
}
