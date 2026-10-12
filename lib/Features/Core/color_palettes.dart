
import 'package:flutter/material.dart';

class ColorPaletteData {
  final String name;
  final Color lightBackground;
  final Color lightSurface;
  final Color lightPrimary;
  final Color lightText;
  final Color darkBackground;
  final Color darkSurface;
  final Color darkPrimary;
  final Color darkText;

  const ColorPaletteData({
    required this.name,
    required this.lightBackground,
    required this.lightSurface,
    required this.lightPrimary,
    required this.lightText,
    required this.darkBackground,
    required this.darkSurface,
    required this.darkPrimary,
    required this.darkText,
  });
}

const List<ColorPaletteData> colorPalettes = [
  ColorPaletteData(
    name: 'Graphite & Silver',
    lightBackground: Color(0xFFF2F3F4),
    lightSurface: Color(0xFFFFFFFF),
    lightPrimary: Color(0xFF626970),
    lightText: Color(0xFF202327),
    darkBackground: Color(0xFF17191B),
    darkSurface: Color(0xFF24272A),
    darkPrimary: Color(0xFFC5C9CE),
    darkText: Color(0xFFF1F2F3),
  ),
  ColorPaletteData(
    name: 'Black & Burgundy',
    lightBackground: Color(0xFFF6F0F1),
    lightSurface: Color(0xFFFFFFFF),
    lightPrimary: Color(0xFF853D4B),
    lightText: Color(0xFF292124),
    darkBackground: Color(0xFF191516),
    darkSurface: Color(0xFF282123),
    darkPrimary: Color(0xFFA65C6A),
    darkText: Color(0xFFF4EDEF),
  ),
  ColorPaletteData(
    name: 'Midnight & Steel Blue',
    lightBackground: Color(0xFFF0F3F7),
    lightSurface: Color(0xFFFFFFFF),
    lightPrimary: Color(0xFF4E6E98),
    lightText: Color(0xFF202733),
    darkBackground: Color(0xFF151A22),
    darkSurface: Color(0xFF202834),
    darkPrimary: Color(0xFF8BA9D4),
    darkText: Color(0xFFEDF2F8),
  ),
  ColorPaletteData(
    name: 'Espresso & Sand',
    lightBackground: Color(0xFFF5F0E8),
    lightSurface: Color(0xFFFFFCF7),
    lightPrimary: Color(0xFF95634D),
    lightText: Color(0xFF302721),
    darkBackground: Color(0xFF211C19),
    darkSurface: Color(0xFF302823),
    darkPrimary: Color(0xFFD09A7E),
    darkText: Color(0xFFF4EEE7),
  ),
  ColorPaletteData(
    name: 'Forest & Moss',
    lightBackground: Color(0xFFF1F4EF),
    lightSurface: Color(0xFFFFFFFF),
    lightPrimary: Color(0xFF52765B),
    lightText: Color(0xFF222923),
    darkBackground: Color(0xFF171D19),
    darkSurface: Color(0xFF242D27),
    darkPrimary: Color(0xFF9DB9A0),
    darkText: Color(0xFFEDF2EC),
  ),
  ColorPaletteData(
    name: 'Midnight Plum',
    lightBackground: Color(0xFFF4F0F7),
    lightSurface: Color(0xFFFFFFFF),
    lightPrimary: Color(0xFF745A91),
    lightText: Color(0xFF29232F),
    darkBackground: Color(0xFF1B1820),
    darkSurface: Color(0xFF2A2431),
    darkPrimary: Color(0xFFB7A0D5),
    darkText: Color(0xFFF2EDF7),
  ),
];
