
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF101211),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFC6F36B),

onPrimary: Color(0xFF18200D),

surface: Color(0xFF1B201D),

onSurface: Color(0xFFE9EEE7),

secondary: Color(0xFF8BD3B0)
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF101211),
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF4F6F0),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF527D24),

onPrimary: Colors.white,

surface: Color(0xFFFFFFFF),

onSurface: Color(0xFF20251E),

secondary: Color(0xFF367C67),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
