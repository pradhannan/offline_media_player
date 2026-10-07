import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/audio_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/audio_event.dart';
import 'package:media_player_app/Features/audio_player/data/audio_repository.dart';
import 'package:media_player_app/Features/audio_player/presentation/song_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(create: (context)=> AudioRepository(),
    child: BlocProvider(create: (context)=>AudioBloc(audioRepository: context.read<AudioRepository>(),)..add(FetchSongsEvent()),
    child: MaterialApp(
      title: 'Offline Media Player',
      theme: ThemeData.dark(),
      home: const SongListScreen(),
    ),),);
  }
}