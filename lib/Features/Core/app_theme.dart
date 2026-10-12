
import 'package:flutter/material.dart';
import 'color_palettes.dart';

class AppTheme {
  static ThemeData lightTheme(ColorPaletteData palette) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: palette.lightBackground,
      colorScheme: ColorScheme.light(
        primary: palette.lightPrimary,
        onPrimary: Colors.white,
        surface: palette.lightSurface,
        onSurface: palette.lightText,
        secondary: palette.lightPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.lightBackground,
        foregroundColor: palette.lightText,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

 
  static ThemeData darkTheme(ColorPaletteData palette) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: palette.darkBackground,
      colorScheme: ColorScheme.dark(
        primary: palette.darkPrimary,
        onPrimary: palette.darkBackground,
        surface: palette.darkSurface,
        onSurface: palette.darkText,
        secondary: palette.darkPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.darkBackground,
        foregroundColor: palette.darkText,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
