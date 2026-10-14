
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color terracota = Color(0xFFB85C38);
  static const Color marrom = Color(0xFF462B20);
  static const Color fundo = Color(0xFFFFF9F2);
  static const Color creme = Color(0xFFF4E2D2);
  static const Color branco = Colors.white;

  static ThemeData get tema {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: fundo,
      colorScheme: ColorScheme.fromSeed(
        seedColor: terracota,
        primary: terracota,
        secondary: marrom,
        surface: branco,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: fundo,
        foregroundColor: marrom,
        centerTitle: false,
        elevation: 0,
        surfaceTintColor: fundo,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: branco,
        labelStyle: const TextStyle(color: marrom),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: creme),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: creme),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: terracota,
            width: 1.5,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: terracota,
          foregroundColor: branco,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
