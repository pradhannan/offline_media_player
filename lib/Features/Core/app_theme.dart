import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: const ColorScheme.dark(
        primary: Colors.deepPurpleAccent,
        onPrimary: Colors.white,
        surface: Color(0xFF1E1E2C),
        onSurface: Colors.white,
        secondary: Colors.tealAccent,
      ), 
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
      ),
    );

    
  }
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      colorScheme: const ColorScheme.light(
        primary: Colors.deepPurple,
        onPrimary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black87,
        secondary: Colors.teal,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
}
}
