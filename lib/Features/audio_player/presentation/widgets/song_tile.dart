import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_state.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_state.dart';
import 'package:media_player_app/Features/audio_player/Logic/Playlist/playlist_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Playlist/playlist_event.dart';
import 'package:media_player_app/Features/audio_player/domain/song_model.dart';
import 'package:media_player_app/Features/audio_player/presentation/Screens/album_page.dart';
import 'package:media_player_app/Features/audio_player/presentation/Screens/artists_page.dart';
import 'package:media_player_app/Features/audio_player/presentation/Screens/song_info.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/add_to_playlist_sheet.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/animated_equilizer.dart';
import 'package:on_audio_query/on_audio_query.dart' hide SongModel;

class SongTile extends StatelessWidget {
  final SongModel song;
  final List<SongModel>? playlist; // the contextual list used for playback.


  const SongTile({super.key, required this.song, this.playlist});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final artwork = SizedBox(
      width: 48,
      height: 48,
      child: ClipOval(
        child: QueryArtworkWidget(
          key: ValueKey(song.id),
          id: int.parse(song.id),
          type: ArtworkType.AUDIO,
          quality: 100,
      size: 1000,
          artworkWidth: 48,
          artworkHeight: 48,
          artworkFit: BoxFit.cover,
          nullArtworkWidget: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [colors.primary, colors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              Icons.album_rounded,
              color: colors.onPrimary,
              size: 28,
            ),
          ),
        ),
      ),
    );

    return BlocBuilder<PlayerBloc, PlayerState>(
      buildWhen: (previous, current) {
        if (previous is PlayerStatusState && current is PlayerStatusState) {
          return previous.currentSong.id != current.currentSong.id;
        }
        return true;
      },
      builder: (context, playerState) {
        final isPlaying =
            playerState is PlayerStatusState &&
            song.id == playerState.currentSong.id;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),

            border: isPlaying
                ? Border.all(
                    //color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  )
                : null,
          ),
          child: ListTile(
            tileColor: isPlaying
                ? colors.primary.withValues(alpha: 0.12)
                : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            leading: SizedBox(
              width: 48,
              height: 48,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  artwork,
                  BlocBuilder<PlayerBloc, PlayerState>(
                    buildWhen: (previous, current) {
                      //  Rebuild only when the playing song or playback status changes.
                      if (previous is PlayerStatusState &&
                          current is PlayerStatusState) {
                        return previous.currentSong.id !=
                                current.currentSong.id ||
                            previous.isPlaying != current.isPlaying;
                      }
                      return previous.runtimeType != current.runtimeType;
                    },
                    builder: (context, state) {
                      // while this song is playing.
                      final isCurrentSong =
                          state is PlayerStatusState &&
                          song.id == state.currentSong.id;

                      final isPlaying = isCurrentSong && state.isPlaying;

                      return isPlaying
                          ? const AnimatedEqualizer()
                          : const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            title: Text(
              song.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              song.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: PopupMenuButton<String>(
  icon: const Icon(Icons.more_vert),
  onSelected: (value) {
    switch (value) {
      case 'play_next':
        context.read<PlayerBloc>().add(PlayNextEvent(song));
        break;

      case 'add_queue':
        context.read<PlayerBloc>().add(AddToQueueEvent(song));
        break;

      case 'album':
  final songs = context.read<AudioBloc>().state as AudioLoaded;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AlbumPage(
        album: song.album,
        songs: songs.songs
            .where((s) => s.album == song.album)
            .toList(),
      ),
    ),
  );
  break;

      case 'artist':
  final songs = context.read<AudioBloc>().state as AudioLoaded;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ArtistsPage(
        artist: song.artist,
        songs: songs.songs
            .where((s) => s.artist == song.artist)
            .toList(),
      ),
    ),
  );
  break;

      case 'playlist':
  final audioState = context.read<AudioBloc>().state;

  if (audioState is AudioLoaded) {
    context.read<PlaylistBloc>().add(
      const LoadPlaylistsEvent(),
    );

    context.read<PlaylistBloc>().add(
      const LoadFavoritesEvent(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddToPlaylistSheet(
        song: song,
        allSongs: audioState.songs,
      ),
    );
  }
  break;

     case 'details':
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => SongInfo(song: song),
    ),
  );
  break;
    }
  },
  itemBuilder: (context) => [
    const PopupMenuItem(
      value: 'play_next',
      child: Text('Play Next'),
    ),
    const PopupMenuItem(
      value: 'add_queue',
      child: Text('Add to Queue'),
    ),
    const PopupMenuItem(
      value: 'album',
      child: Text('Go to Album'),
    ),
    const PopupMenuItem(
      value: 'artist',
      child: Text('Go to Artist'),
    ),
    const PopupMenuItem(
      value: 'playlist',
      child: Text('Add to Playlist'),
    ),
    const PopupMenuItem(
      value: 'details',
      child: Text('Details'),
    ),
  ],
),
            onTap: () {
              final currentState = context.read<PlayerBloc>().state;

              if (currentState is PlayerStatusState &&
                  song.id == currentState.currentSong.id) {
                context.read<PlayerBloc>().add(TogglePlayPauseEvent());
              } else {
                final audioState = context.read<AudioBloc>().state;

                if (audioState is AudioLoaded) {
                  context.read<PlayerBloc>().add(
                    // Use the screen's playlist; fall back to all songs on the library screen.
PlaySongEvent(song, playlist ?? audioState.songs),
                  );
                }
              }
            },
          ),
        );
      },
    );
  }
}
