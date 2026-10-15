import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_player_app/Features/Core/color_palettes.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Theme/theme_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Theme/theme_state.dart';
import 'package:media_player_app/Features/audio_player/data/audio_player_repository.dart';
import 'package:media_player_app/Features/audio_player/data/audio_repository.dart';
import 'package:media_player_app/Features/audio_player/presentation/home_screen.dart';


import 'Features/Core/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final audioRepository = AudioRepository();
  final audioPlayerRepository = AudioPlayerRepository();

  runApp(
    MyApp(
      audioRepository: audioRepository,
      audioPlayerRepository: audioPlayerRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AudioRepository audioRepository;
  final AudioPlayerRepository audioPlayerRepository;
  const MyApp({
    super.key,
    required this.audioRepository,
    required this.audioPlayerRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AudioBloc>(
          create: (context) =>
              AudioBloc(audioRepository: audioRepository)
                ..add(FetchSongsEvent()),
        ),
        BlocProvider<PlayerBloc>(
          create: (context) =>
              PlayerBloc(audioPlayerRepository: audioPlayerRepository),
        ),
        BlocProvider<ThemeBloc>(
  create: (context) => ThemeBloc(), // CHANGED
),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
  builder: (context, state) {
    final palette = colorPalettes.firstWhere(
    (palette) => palette.name == state.selectedPalette,
    orElse: () => colorPalettes.first,
  );
    return MaterialApp(
      title: 'S U R  T A A L',
      theme: AppTheme.lightTheme(palette),
      darkTheme: AppTheme.darkTheme(palette),
      themeMode: state.themeMode, // CHANGED
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  },
),
    );
  }
}
