
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeModeChanged extends ThemeEvent {
  final ThemeMode themeMode;

  const ThemeModeChanged(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

class ColorPaletteChanged extends ThemeEvent {
  final String paletteName;

  const ColorPaletteChanged(this.paletteName);

  @override
  List<Object> get props => [paletteName];
}
