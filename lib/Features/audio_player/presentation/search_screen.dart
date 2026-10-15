import 'package:flutter/material.dart';


import 'package:media_player_app/Features/audio_player/Logic/Player/player_state.dart';
import 'package:media_player_app/Features/audio_player/presentation/album_page.dart';
import 'package:media_player_app/Features/audio_player/presentation/artists_page.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/animated_equilizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Search/search_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Search/search_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/Search/search_state.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_state.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_event.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/mini_player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            context.read<SearchBloc>().add(SearchQueryChangedEvent(value));
          },
          decoration: InputDecoration(
            hintText: 'Search songs...',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),

            border: InputBorder.none,
            isDense: true,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _searchController.clear();

              context.read<SearchBloc>().add(
                const SearchQueryChangedEvent(''), //tells SearchBloc that the query is empty, so it updates the results state.
              );
            },
            icon: const Icon(Icons.close_rounded),
          ),
          IconButton(
            onPressed: () async {
              final selectedFilter = await showMenu<String>(
                context: context,
                position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
                items: [
                  const PopupMenuItem(value: 'All', child: Text('All')),
                  const PopupMenuItem(value: 'Songs', child: Text('Songs')),
                  const PopupMenuItem(value: 'Albums', child: Text('Albums')),
                  const PopupMenuItem(value: 'Artists', child: Text('Artists')),
                ],
              );

              if (selectedFilter != null && context.mounted) {
                setState(() {
                  _selectedFilter = selectedFilter;
                });

                context.read<SearchBloc>().add(
                  SearchFilterChangedEvent(selectedFilter),
                );
              }
            },
            icon: const Icon(Icons.filter_list_rounded),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return const Center(
                      child: Text(
                        'Search your song by \n song title, artist or album',
                      ),
                    );
                  }

                  if (state is SearchResultsState) {
                    if (state.query.isEmpty) {
                      return const Center(
                        child: Text(
                          'Search your song by \n song title, artist or album',
                        ),
                      );
                    }

                    if (_selectedFilter == 'Albums' && state.albums.isEmpty) {
                      return const Center(child: Text('No albums found'));
                    }

                    if (_selectedFilter == 'Artists' && state.artists.isEmpty) {
                      return const Center(child: Text('No artists found'));
                    }

                    if (_selectedFilter != 'Albums' &&
                        _selectedFilter != 'Artists' &&
                        state.results.isEmpty) {
                      return const Center(child: Text('No songs found'));
                    }

                    if (_selectedFilter == 'Albums') {
                      return ListView.builder(
                        itemCount: state.albums.length,
                        itemBuilder: (context, index) {
                          final album = state.albums[index];

                          return ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.album_rounded),
                            ),
                            title: Text(album),
                            subtitle: const Text('Album'),

                            onTap: () {
                              final audioState = context
                                  .read<AudioBloc>()
                                  .state;

                              if (audioState is AudioLoaded) {
                                final albumSongs = audioState.songs
                                    .where((song) => song.album == album)
                                    .toList();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AlbumPage(
                                      album: album,
                                      songs: albumSongs,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    }

                    if (_selectedFilter == 'Artists') {
                      return ListView.builder(
                        itemCount: state.artists.length,
                        itemBuilder: (context, index) {
                          final artist = state.artists[index];

                          return ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person_rounded),
                            ),
                            title: Text(artist),
                            subtitle: const Text('Artist'),

                            onTap: () {
                              final audioState = context
                                  .read<AudioBloc>()
                                  .state;

                              if (audioState is AudioLoaded) {
                                final artistSongs = audioState.songs
                                    .where((song) => song.artist == artist)
                                    .toList();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ArtistsPage(
                                      artist: artist,
                                      songs: artistSongs,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    }

                    return ListView.builder(
                      itemCount: state.results.length,
                      itemBuilder: (context, index) {
                        final song = state.results[index];
                        final playerState = context.watch<PlayerBloc>().state;

                        final isPlaying =
                            playerState is PlayerStatusState &&
                            playerState.currentSong.id == song.id &&
                            playerState.isPlaying;

                        return ListTile(
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                QueryArtworkWidget(
                                  id: int.parse(song.id),
                                  type: ArtworkType.AUDIO,
                                  artworkWidth: 50,
                                  artworkHeight: 50,
                                  keepOldArtwork: true,
                                  artworkFit: BoxFit.cover,
                                  nullArtworkWidget: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).colorScheme.primary,
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),

                                    child: Icon(
                                      Icons.album_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      size: 28,
                                    ),
                                  ),
                                ),
                                if (isPlaying)
                                  const Positioned.fill(
                                    child: Center(child: AnimatedEqualizer()),
                                  ),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              // We'll add the menu actions next.
                            },
                          ),
                          title: Text(
                            song.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(song.artist),
                          onTap: () {
                            final audioState = context.read<AudioBloc>().state;

                            if (audioState is AudioLoaded) {
                              context.read<PlayerBloc>().add(
                                PlaySongEvent(song, audioState.songs),
                              );
                            }
                          },
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: MiniPlayer(),
            )
          ],
        ),
      ),
    );
  }
}
