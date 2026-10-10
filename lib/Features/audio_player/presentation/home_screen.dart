import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_player_app/Features/audio_player/Logic/audio_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/audio_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/audio_state.dart';
import 'package:media_player_app/Features/audio_player/Logic/player_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/player_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/player_state.dart';
import 'package:media_player_app/Features/audio_player/presentation/full_player_screen.dart';
import 'package:media_player_app/Features/audio_player/presentation/setting_screen.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/home_screen/folder_section.dart';

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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => SettingScreen()),
                      // );
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
                        MaterialPageRoute(builder: (context) => SettingScreen()),
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
            child: Center(
              child: CircularProgressIndicator(),
            ),
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
                      context.read<AudioBloc>().add(FetchSongsEvent());
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
              child: Center(
                child: Text('No songs found on device.'),
              ),
            );
          }
          
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = state.songs[index];
          
                return ListTile(
                  leading: const Icon(Icons.music_note),
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
                  onTap: () {
                    context.read<PlayerBloc>().add(PlaySongEvent(song));
                  },
                );
              },
              childCount: state.songs.length,
            ),
          );
              }
          
              return const SliverToBoxAdapter(
          child: Center(
            child: Text('Press fetch to load songs.'),
          ),
              );
            },
          ),
          
            
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BlocBuilder<PlayerBloc, PlayerState>(
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
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const FullPlayerScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0); // Start from bottom
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
                
                  child: Material(
                    color: colors.surfaceContainerHigh,
                      elevation: 6,
                      shadowColor: Colors.black.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(24),
                    child: Container(
                      height: 60,
                      color: colors.surface,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(Icons.music_note, color: colors.primary),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.currentSong.title,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colors.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  state.currentSong.artist,
                                  style: theme.textTheme.bodySmall?.copyWith(
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
                            icon: Icon(
                              state.isPlaying
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                              color: colors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
                      }
                      return const SizedBox.shrink();}))
      ],
      ),
    );
  }
}
