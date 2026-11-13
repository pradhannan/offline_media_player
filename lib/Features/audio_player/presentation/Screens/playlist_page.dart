import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:media_player_app/Features/audio_player/domain/song_model.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_state.dart';
import 'package:media_player_app/Features/audio_player/Logic/Playlist/playlist_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Playlist/playlist_state.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/collapsing_title.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/mini_player.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/song_tile.dart';

class PlaylistPage extends StatelessWidget {
  final bool isFavorites;
  final int? playlistId;
  final String playlistName;

  const PlaylistPage({
    super.key,
    required this.isFavorites,
    required this.playlistName,
    this.playlistId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<AudioBloc, AudioState>(
            builder: (context, audioState) {
              if (audioState is! AudioLoaded) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return BlocBuilder<PlaylistBloc, PlaylistState>(
                builder: (context, playlistState) {
                  List<SongModel> playlistSongs;

                  if (isFavorites) {
                    playlistSongs = audioState.songs
                        .where(
                          (song) => playlistState.favoriteSongIds
                              .contains(song.id),
                        )
                        .toList();
                  } else {
                    final songIds =
                        playlistState.playlistSongIds[playlistId] ?? [];

                    playlistSongs = audioState.songs
                        .where((song) => songIds.contains(song.id))
                        .toList();
                  }

                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        titleSpacing: 0,
                        pinned: true,
                        expandedHeight: 160,
                        collapsedHeight: 64,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        flexibleSpace: CollapsingTitle(
                          title: playlistName,
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            0,
                            16,
                            12,
                          ),
                          child: Text(
                            '${playlistSongs.length} Songs',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),

                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          16,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final song = playlistSongs[index];
                              final songs = playlistSongs;

                              return SongTile(song: song, playlist: songs,);
                            },
                            childCount: playlistSongs.length,
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 90)),
                    ],
                  );
                },
              );
            },
          ),

          const Align(
            alignment: Alignment.bottomCenter,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }
}