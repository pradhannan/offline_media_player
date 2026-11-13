import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_player_app/Features/Core/color_palettes.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/Library/library_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Theme/theme_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Theme/theme_state.dart';
import 'package:media_player_app/Features/audio_player/data/audio_player_repository.dart';
import 'package:media_player_app/Features/audio_player/data/audio_repository.dart';
import 'package:media_player_app/Features/audio_player/presentation/Screens/home_screen.dart';
import 'package:media_player_app/Features/audio_player/Logic/Playlist/playlist_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Playlist/playlist_event.dart';
import 'package:media_player_app/Features/audio_player/data/playlist_repository.dart';
import 'package:media_player_app/Features/audio_player/data/db/db_provider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'Features/Core/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId:
        'com.example.media_player_app.channel.audio',
    androidNotificationChannelName: 'Swarika Audio Playback',
    androidNotificationOngoing: true,
  );

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
        BlocProvider<LibraryBloc>(
  // Creates LibraryBloc and makes it available to HomeScreen.
  create: (context) => LibraryBloc(),
),
        BlocProvider<ThemeBloc>(
  create: (context) => ThemeBloc(), 
),
BlocProvider<PlaylistBloc>(
  create: (context) => PlaylistBloc(
    repository: PlaylistRepository(database),
  )
    ..add(const LoadFavoritesEvent())
    ..add(const LoadPlaylistsEvent()),
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
