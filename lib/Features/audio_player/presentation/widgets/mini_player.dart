import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_state.dart';
import 'package:media_player_app/Features/audio_player/presentation/full_player_screen.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/animated_equilizer.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/home_screen/mini_player_artwork.dart';

class MiniPlayer extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
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
                                              songId: int.parse(
                                                state.currentSong.id,
                                              ),
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
            );
  }
}