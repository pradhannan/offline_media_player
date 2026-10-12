
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ThemeModeChanged>((event, emit) {
      emit(ThemeState(themeMode: event.themeMode, selectedPalette: state.selectedPalette));
    });
    on<ColorPaletteChanged>((event, emit) {
      emit(
        ThemeState(
          themeMode: state.themeMode,
          selectedPalette: event.paletteName,
        ),
      );
    });
  }
}
