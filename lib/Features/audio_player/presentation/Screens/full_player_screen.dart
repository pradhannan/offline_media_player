import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_state.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_state.dart';
import 'package:media_player_app/Features/audio_player/Logic/Playlist/playlist_state.dart';
import 'package:media_player_app/Features/audio_player/domain/song_model.dart';
import 'package:media_player_app/Features/audio_player/presentation/Screens/artists_page.dart';
import 'package:media_player_app/Features/audio_player/presentation/Screens/song_info.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/player_artwork.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/player_primary_controls.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/player_progress_bar.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/player_secondary_control.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/player_top_bar.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/progress_bar_style.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/queue_bottom_sheet.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/full_player_screen/song_info.dart';
import 'package:media_player_app/Features/audio_player/Logic/Playlist/playlist_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Playlist/playlist_event.dart';


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

              PlayerTopBar(
                onSleepTimerTap: () {
                    final playerBloc = context.read<PlayerBloc>();

                  
showDialog(
  
  context: context,
  builder: (dialogContext) {
    return  BlocBuilder<PlayerBloc, PlayerState>(
          builder: (context, state) {

    
    const durations = [
      (label: '5 minutes', duration: Duration(minutes: 5)),
      (label: '10 minutes', duration: Duration(minutes: 10)),
      (label: '15 minutes', duration: Duration(minutes: 15)),
      (label: '30 minutes', duration: Duration(minutes: 30)),
      (label: '45 minutes', duration: Duration(minutes: 45)),
      (label: '1 hour', duration: Duration(hours: 1)),
      (label: '1 hour 30 minutes', duration: Duration(hours: 1, minutes: 30)),
    ];

    final colors = Theme.of(context).colorScheme;
     // Format the remaining duration as HH:MM:SS or MM:SS.
            String formatRemaining(Duration duration) {
              final hours = duration.inHours;
              final minutes = duration.inMinutes.remainder(60);
              final seconds = duration.inSeconds.remainder(60);

              final mm = minutes.toString().padLeft(2, '0');
              final ss = seconds.toString().padLeft(2, '0');  //adds 0 at the beginning if it's only one digit.

              if (hours > 0) {  //if in hours the hr:mm:ss else just mm:ss
                return '${hours.toString().padLeft(2, '0')}:$mm:$ss';
              }

              return '$mm:$ss';
            }

            final isTimerActive =
                state is PlayerStatusState && state.isSleepTimerActive;

            final sleepAfterSong =
                state is PlayerStatusState &&
                state.sleepAfterCurrentSong;

            final remainingTime =
                state is PlayerStatusState
                    ? state.sleepTimeRemaining
                    : null;


    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 380,
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sleep Timer',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),
              if (isTimerActive) ...[   ///...[ ] expects list of widgets, if true then insert all or none
                        Icon(
                          sleepAfterSong
                              ? Icons.music_note_rounded
                              : Icons.timer_outlined,
                          size: 36,
                          color: colors.primary,
                        ),

                        const SizedBox(height: 12),

                        Text(
                          sleepAfterSong
                              ? 'Sleep after this song'
                              : 'Time remaining',
                          style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 15,
                          ),
                        ),
                        if (!sleepAfterSong) ...[
                          const SizedBox(height: 8),
                          Text(
                            remainingTime != null
                                ? formatRemaining(remainingTime)
                                : '--:--',
                            style: TextStyle(
                              color: colors.primary,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              playerBloc.add(CancelSleepTimerEvent());
                              Navigator.pop(dialogContext);
                            },
                            icon: const Icon(Icons.timer_off_rounded),
                            label: const Text('Cancel Timer'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                            ),
                          ),
                        ),
                      ]

              else...[...durations.map(  //inner ... inserts the widgets generated by .map() into the inner list
                (option) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(vertical: -2),
                  title: Text(option.label),
                  trailing: Icon(
                    Icons.timer_outlined,
                    color: colors.primary,
                  ),
                  onTap: () {
                    context.read<PlayerBloc>().add(
                      StartSleepTimerEvent(option.duration),
                    );
                    Navigator.pop(dialogContext);
                  },
                ),
              ),

              const Divider(),

              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                visualDensity: const VisualDensity(vertical: -2),
                leading: Icon(
                  Icons.music_note_rounded,
                  color: colors.primary,
                ),
                title: const Text('End of this song'),
                onTap: () {
                  context.read<PlayerBloc>().add(
                    SleepAfterCurrentSongEvent(),
                  );
                  Navigator.pop(dialogContext);
                },
              ),

              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'Close',
                  style: TextStyle(color: colors.primary),
                ),
              ),
            ]],
          ),
        ),
      ),
    );});
  },
);


                 
                   
                },
              ),

              //artwork
              SizedBox(
                height: 340,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: BlocBuilder<PlayerBloc, PlayerState>(
                      builder: (context, state) {
                        final currentSong = state is PlayerStatusState
                            ? state.currentSong
                            : song;
                        debugPrint('Full player song: ${currentSong.title}');
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SongInfo(song: currentSong),
                              ),
                            );
                          },
                          child: PlayerArtwork(
                            key: ValueKey(currentSong.id), //tells Flutter that each song has a different artwork widget
                            songId: int.parse(currentSong.id),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              //info
              BlocBuilder<PlayerBloc, PlayerState>(
                builder: (context, state) {
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
                              .where(
                                (song) => song.artist == currentSong.artist,
                              )
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
                },
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
                  final currentSong = state is PlayerStatusState
                      ? state.currentSong
                      : song;    

                  return BlocBuilder<PlaylistBloc, PlaylistState>(
                     builder: (context, playlistState) {
                       final isFavorite = playlistState.favoriteSongIds.contains(
                        currentSong.id,
                      );
                      return PlayerSecondaryControls(
                        isFavorite: isFavorite,
                        isShuffle: isShuffle,
                        onShuffleToggle: () {
                          context.read<PlayerBloc>().add(ToggleShuffleEvent());
                        },
                        repeatMode: repeatMode,
                        onFavoriteToggle: () {
                          if (isFavorite) {
                            context.read<PlaylistBloc>().add(
                              RemoveFavoriteEvent(currentSong.id),
                            );
                          } else {
                            context.read<PlaylistBloc>().add(
                              AddFavoriteEvent(currentSong.id),
                            );
                          }
                        },
                      
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
                    }
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
