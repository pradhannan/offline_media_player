import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_state.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_state.dart';
import 'package:media_player_app/Features/audio_player/Logic/Search/search_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Search/search_event.dart';
import 'package:media_player_app/Features/audio_player/presentation/search_screen.dart';
import 'package:media_player_app/Features/audio_player/presentation/full_player_screen.dart';
import 'package:media_player_app/Features/audio_player/presentation/setting_screen.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/animated_equilizer.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/home_screen/folder_section.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/home_screen/mini_player_artwork.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 160,
                collapsedHeight: 78,
          
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                surfaceTintColor: Colors.transparent,
                forceMaterialTransparency: false,
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1.8,
          
                  title: Text(
                    'S U R   T A A L',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                  collapseMode: CollapseMode.pin,
                ),
                actions: [
                  IconButton(
                   
                     onPressed: () {
            final audioState = context.read<AudioBloc>().state;
          
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => SearchBloc()
                    ..add(
          SearchSongsLoadedEvent(
            audioState is AudioLoaded ? audioState.songs : [],  // If audioState is AudioLoaded, pass its song list. Otherwise, pass an empty list.
          ),
                    ),
                  child: const SearchScreen(),
                ),
              ),
            );
          
                    },
                    icon: Icon(
                      Icons.search_rounded,
                      size: 28,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.settings,
                      size: 28,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SliverToBoxAdapter(child: FolderSection()),
              BlocBuilder<AudioBloc, AudioState>(
                builder: (context, state) {
                  if (state is AudioLoading) {
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is AudioError) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Error ${state.message}',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<AudioBloc>().add(
                                  FetchSongsEvent(),
                                );
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is AudioLoaded) {
                    if (state.songs.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(child: Text('No songs found on device.')),
                      );
                    }
          
                    return BlocBuilder<PlayerBloc, PlayerState>(
                      buildWhen: (previous, current) {
                        if (previous is PlayerStatusState &&
                            current is PlayerStatusState) {
                          return previous.currentSong.id !=
                              current.currentSong.id;
                        }
                        return previous.runtimeType != current.runtimeType;
                      },
                      builder: (context, playerState) {
                        final currentSongId = playerState is PlayerStatusState
                            ? playerState.currentSong.id
                            : null;
                        return SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final colors = Theme.of(context).colorScheme;
                            final song = state.songs[index];
                            final isPlaying = song.id == currentSongId;
          
                            return ListTile(
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
                                    ClipOval(
                                      child: QueryArtworkWidget(
                                        id: int.parse(song.id),
                                        type: ArtworkType.AUDIO,
                                        artworkWidth: 48,
                                        artworkHeight: 48,
                                        artworkFit: BoxFit.cover,
                                        nullArtworkWidget: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                colors.primary,
                                                colors.secondary,
                                              ],
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
                                    if (isPlaying)
                                     const Positioned.fill(
                                        child: Center(
                                          child:AnimatedEqualizer(),
                                        ),
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
                              trailing: IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  // We'll add the menu actions next.
                                },
                              ),
                              onTap: () {
                                context.read<PlayerBloc>().add(
                                  PlaySongEvent(song, state.songs),
                                );
                              },
                            );
                          }, childCount: state.songs.length),
                          
                        );
                      },
                    );
                  }
          
                  return const SliverToBoxAdapter(
                    child: Center(child: Text('Press fetch to load songs.')),
                  );
                },
              ),
              const SliverToBoxAdapter(
  child: SizedBox(height: 90),
),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BlocBuilder<PlayerBloc, PlayerState>(
              buildWhen: (previous, current) {
                if (previous is PlayerStatusState &&
                    current is PlayerStatusState) {
                  return previous.currentSong != current.currentSong ||
                      previous.isPlaying != current.isPlaying;
                }
                return true;
              },
              builder: (context, state) {
                if (state is PlayerStatusState) {
                  final theme = Theme.of(context);
                  final colors = theme.colorScheme;
                  return SafeArea(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                            ) => FullPlayerScreen(song: state.currentSong),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  const begin = Offset(
                                    0.0,
                                    1.0,
                                  ); // Start from bottom
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;

                                  var tween = Tween(
                                    begin: begin,
                                    end: end,
                                  ).chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Material(
                              color: Colors.transparent,
                              elevation: 6,
                              shadowColor: Colors.black.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  color: colors.surface.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                     child: SizedBox(
    width: 48,
    height: 48,
    child: Stack(
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
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.currentSong.title,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  color: colors.onSurface,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            state.currentSong.artist,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: colors.onSurface,
                                                ),
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
                                      iconSize: 34,
                                      constraints: const BoxConstraints(
                                        minWidth: 48,
                                        minHeight: 48,
                                      ),
                                      icon: Icon(
                                        state.isPlaying
                                            ? Icons
                                                  .pause_circle_outline_outlined
                                            : Icons.play_circle_filled_rounded,
                                        color: colors.primary,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        context.read<PlayerBloc>().add(
                                          NextSongEvent(),
                                        );
                                      },
                                      iconSize: 34,
                                      constraints: const BoxConstraints(
                                        minWidth: 48,
                                        minHeight: 48,
                                      ),
                                      icon: Icon(
                                        Icons.skip_next_rounded,
                                        color: colors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
