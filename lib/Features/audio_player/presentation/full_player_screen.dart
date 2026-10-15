import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_state.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_state.dart';
import 'package:media_player_app/Features/audio_player/domain/song_model.dart';
import 'package:media_player_app/Features/audio_player/presentation/artists_page.dart';
import 'package:media_player_app/Features/audio_player/presentation/song_info.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/player_artwork.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/player_primary_controls.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/player_progress_bar.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/player_secondary_control.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/player_top_bar.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/progress_bar_style.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/queue_bottom_sheet.dart';
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
                    child: BlocBuilder<PlayerBloc,PlayerState>(
                      builder: (context,state) {
                         final currentSong = state is PlayerStatusState
        ? state.currentSong
        
        : song;
        debugPrint('Full player song: ${currentSong.title}');
                        return GestureDetector(
                          onTap: () {
                         
                          Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  SongInfo(song: currentSong,),
                      ),
                    );
                          },
                          child: PlayerArtwork(
                            
                            
                            
                            key: ValueKey(currentSong.id),  //tells Flutter that each song has a different artwork widget
                            songId: int.parse(currentSong.id),
                          ),
                        );
                      }
                    ),
                  ),
                ),
              ),

              //info
             BlocBuilder<PlayerBloc, PlayerState>(
                builder: (context,state) {
                  final currentSong = state is PlayerStatusState
        ? state.currentSong
        : song;

                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Songtitlealbum(
                      title: currentSong.title,
                      artist: currentSong.artist,
                     onTap: () {
  final allSongs = context.read<AudioBloc>().state;

  if (allSongs is AudioLoaded) {
    final artistSongs = allSongs.songs
        .where((song) => song.artist == currentSong.artist)
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ArtistsPage(
          artist: currentSong.artist,
          songs: artistSongs,
        ),
      ),
    );
  }
},
                    ),
                  );
                }
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
                    isPlaying: state is PlayerStatusState && state.isPlaying,
                    onPlayPause: () {
                      context.read<PlayerBloc>().add(TogglePlayPauseEvent());
                    },
                    onPrevious: () {
                      context.read<PlayerBloc>().add(PreviousSongEvent());
                    },
                    onNext: () {
                      context.read<PlayerBloc>().add(NextSongEvent());
                    },
                  );
                },
              ),
              //secondary control
             // Secondary controls
BlocBuilder<PlayerBloc, PlayerState>(
  builder: (context, state) {
    final repeatMode = state is PlayerStatusState
        ? state.repeatMode
        : RepeatMode.off;
        final isShuffle = state is PlayerStatusState
    ? state.isShuffle
    : false;

    return PlayerSecondaryControls(
      isFavorite: false,
      isShuffle: isShuffle,
onShuffleToggle: () {
  context.read<PlayerBloc>().add(ToggleShuffleEvent());
},
      repeatMode: repeatMode,
      onFavoriteToggle: () {},
      
      onRepeatToggle: () {
        context.read<PlayerBloc>().add(ToggleRepeatEvent());
      },
      onQueueTap: () {
        showModalBottomSheet(
          context: context,
          useSafeArea: true,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const QueueBottomSheet(),
        );
      }, 
    );
  },
),
            ],
          ),
        ),
      ),
    );
  }
}
