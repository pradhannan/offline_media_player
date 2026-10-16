import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/Audio/audio_state.dart';
import 'package:media_player_app/Features/audio_player/Logic/Library/library_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Library/library_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/Library/library_state.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_state.dart';
import 'package:media_player_app/Features/audio_player/Logic/Search/search_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Search/search_event.dart';
import 'package:media_player_app/Features/audio_player/presentation/search_screen.dart';
import 'package:media_player_app/Features/audio_player/presentation/setting_screen.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/home_screen/folder_section.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/mini_player.dart';
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
                                  audioState is AudioLoaded
                                      ? audioState.songs
                                      : [], // If audioState is AudioLoaded, pass its song list. Otherwise, pass an empty list.
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
              SliverPersistentHeader(
                pinned:
                    true, // Keeps the folder section visible while scrolling.
                delegate: FolderSectionHeaderDelegate(
                  child: BlocBuilder<LibraryBloc, LibraryState>(
                    builder: (context, libraryState) {
                      return FolderSection(
                        // Highlights the currently selected section.
                        selectedSection: libraryState.selectedSection,

                        // Updates LibraryBloc when a tile is tapped.
                        onSectionSelected: (section) {
                          context.read<LibraryBloc>().add(
                            SelectLibrarySection(section),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              BlocBuilder<LibraryBloc, LibraryState>(
                  builder: (context, libraryState) {

                   
                  return BlocBuilder<AudioBloc, AudioState>(
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
                  
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Container(
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
                                        final playerState = context
                                            .read<PlayerBloc>()
                                            .state;
                  
                                        if (playerState is PlayerStatusState &&
                                            song.id == playerState.currentSong.id) {
                                          context.read<PlayerBloc>().add(
                                            TogglePlayPauseEvent(),
                                          );
                                        } else {
                                          context.read<PlayerBloc>().add(
                                            PlaySongEvent(song, state.songs),
                                          );
                                        }
                                      },
                                    ),
                                  ),
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
                  );
                }
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 90)),
            ],
          ),
          Align(alignment: Alignment.bottomCenter, child: MiniPlayer()),
        ],
      ),
    );
  }
}

// Controls the size and pinned behavior of the folder section.
class FolderSectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child; // existing FolderSection widget

  FolderSectionHeaderDelegate({required this.child});

  @override
  double get minExtent => 50; // Keeps the header at least 40 pixels tall.

  @override
  double get maxExtent => 50; // Prevents the header from expanding.

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset, //indicates how much the header has shrunk during scrolling BUT NOT USED
    bool overlapsContent, //Indicates whether the header overlaps the content below it BUT NOT NEEDED
  ) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SizedBox(
        height: maxExtent,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: child,
        ),
      ), // Displays the existing FolderSection.
    );
  }

  @override
  bool shouldRebuild(covariant FolderSectionHeaderDelegate oldDelegate) {
    // Rebuilds only if the child widget changes.
    return oldDelegate.child != child;
  }
}
