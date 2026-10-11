import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/player_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/player_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/player_state.dart';
import 'package:media_player_app/Features/audio_player/domain/song_model.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/player_artwork.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/player_primary_controls.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/player_progress_bar.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/player_secondary_control.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/player_top_bar.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/progress_bar_style.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/song_info.dart';

class FullPlayerScreen extends StatelessWidget {
  final SongModel song;
  const FullPlayerScreen({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //TOp bar (arrow+sleep)
              PlayerTopBar(onSleepTimerTap: () {}),

              //artwork
              SizedBox(
                height: 340,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: PlayerArtwork( onTap: () {},  songId: int.parse(song.id),),
                  ),
                ),
              ),

              //info
              Align(
                alignment: Alignment.centerLeft,
                child: SongInfo(title: song.title, artist: song.artist, onTap: () {}),
              ),

              //progress
             
BlocBuilder<PlayerBloc, PlayerState>(
  builder: (context, state) {
    final isReady = state is PlayerStatusState;

    return PlayerProgressSection(
      position: isReady ? state.position : Duration.zero,
      duration: isReady ? state.duration : Duration.zero,
      style: ProgressBarStyle.linear,
      onSeek: (newPosition) {
        context.read<PlayerBloc>().add(
          SeekPositionEvent(newPosition),
        );
      },
    );
  },
),
              //primary control
              BlocBuilder<PlayerBloc, PlayerState>(
  builder: (context, state) {
    return PlayerPrimaryControls(
      isPlaying:
          state is PlayerStatusState && state.isPlaying,
      onPlayPause: () {
        context.read<PlayerBloc>().add(
          TogglePlayPauseEvent(),
        );
      },
      onPrevious: () {},
      onNext: () {},
    );
  },
),
              //secondary control
              PlayerSecondaryControls(
                isFavorite: false,
                isShuffle: false,
                isRepeat: false,
                onFavoriteToggle: () {},
                onShuffleToggle: () {},
                onRepeatToggle: () {},
                onQueueTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
