import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/audio_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/audio_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/player_bloc.dart';
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
      ],
      child: MaterialApp(
        title: 'my_offline_media_player',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
