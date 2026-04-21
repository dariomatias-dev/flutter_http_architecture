import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(
        surface: Colors.white,
        onSurface: Colors.black,
        primary: Colors.black,
        onPrimary: Colors.white,
        surfaceContainerHighest: const Color(0xFFF5F5F5),
        outlineVariant: Colors.grey[300]!,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.0,
        centerTitle: true,
      ),
      dividerTheme: DividerThemeData(color: Colors.grey[200]),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: const ColorScheme.dark(
        surface: Color(0xFF0A0A0A),
        onSurface: Colors.white,
        primary: Colors.white,
        onPrimary: Colors.black,
        surfaceContainerHighest: Color(0xFF121212),
        outlineVariant: Color(0xFF1A1A1A),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFF1A1A1A)),
    );
  }
}
