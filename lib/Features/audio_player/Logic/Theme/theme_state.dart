
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final String selectedPalette;
  const ThemeState({
    this.themeMode = ThemeMode.light,
    this.selectedPalette = 'Graphite & Silver', 
  });

  @override
  List<Object> get props => [themeMode, selectedPalette]; 
}
