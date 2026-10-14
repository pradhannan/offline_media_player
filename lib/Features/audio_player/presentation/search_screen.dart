import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:media_player_app/Features/audio_player/Logic/Player/player_state.dart';
import 'package:media_player_app/Features/audio_player/presentation/album_page.dart';
import 'package:media_player_app/Features/audio_player/presentation/artists_page.dart';
import 'package:media_player_app/Features/audio_player/presentation/full_player_screen.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/home_screen/mini_player_artwork.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/animated_equilizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Search/search_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Search/search_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/Search/search_state.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_state.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_event.dart';
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
          Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const AlbumPage(),
    ),
  );
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
         
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const ArtistsPage(),
    ),
  );

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

final isPlaying = playerState is PlayerStatusState &&
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
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          
          child: Icon(
            Icons.album_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 28,
          ),
        ),
      ),
      if (isPlaying)
        const Positioned.fill(
          child: Center(
            child: AnimatedEqualizer(),
          ),
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
                          title: Text(song.title, maxLines: 2,overflow: TextOverflow.ellipsis,),
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
            BlocBuilder<PlayerBloc, PlayerState>(
              builder: (context, state) {
                if (state is! PlayerStatusState) {
                  return const SizedBox.shrink();
                }

                final colors = Theme.of(context).colorScheme;

                return SafeArea(
                  
                  top: false,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.push(
  context,
  PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, animation, secondaryAnimation) =>
        FullPlayerScreen(song: state.currentSong),
    transitionsBuilder: (_, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  ),
);
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                      height: 70,
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child:  Stack(
  alignment: Alignment.center,
  children: [
    MiniPlayerArtwork(
      songId: int.parse(state.currentSong.id),
    ),
    if (state.isPlaying)
      const Positioned.fill(
        child: Center(
          child: AnimatedEqualizer(),
        ),
      ),
  ],
),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.currentSong.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  state.currentSong.artist,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<PlayerBloc>().add(
                                TogglePlayPauseEvent(),
                              );
                            },
                            icon: Icon(
                              state.isPlaying
                                  ? Icons.pause_circle_outline_rounded
                                  : Icons.play_circle_fill_rounded,
                              color: colors.primary,
                              size: 34,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<PlayerBloc>().add(NextSongEvent());
                            },
                            icon: Icon(
                              Icons.skip_next_rounded,
                              color: colors.primary,
                              size: 34,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
