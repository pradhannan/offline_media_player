import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_state.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/animated_equilizer.dart';
import 'package:on_audio_query/on_audio_query.dart';

class QueueBottomSheet extends StatelessWidget {
  const QueueBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 1.0,
      minChildSize: 0.4,
      maxChildSize: 1.0,

      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: BlocBuilder<PlayerBloc, PlayerState>(
            builder: (context, state) {
              if (state is! PlayerStatusState) {
                return ListView(
                  controller: scrollController,
                  children: const [Center(child: Text('No songs in queue'))],
                );
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Now Playing',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('${state.playlist.length} songs'),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          iconSize: 30,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      height: 1,
                      thickness: 0.8,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  Expanded(
                    child: ReorderableListView.builder(
                      scrollController: scrollController,
                      onReorderItem: (oldIndex, newIndex) {
                        debugPrint('Moving from $oldIndex to $newIndex');
                        context.read<PlayerBloc>().add(
                          ReorderQueueEvent(oldIndex, newIndex),
                        );
                      },

                      itemCount: state.playlist.length,
                      itemBuilder: (context, index) {
                        final song = state.playlist[index];
                        final isPlaying = song.id == state.currentSong.id;

                        return Material(
                          key: ValueKey(song.id),
                          color: isPlaying
                              ? Theme.of(context).colorScheme.primary
                                    .withValues(alpha: 0.12)
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            
                            leading: Stack(
                                alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: QueryArtworkWidget(
                                    keepOldArtwork: true,
                                    id: int.parse(song.id),
                                    type: ArtworkType.AUDIO,
                                    artworkWidth: 48,
                                    artworkHeight: 48,
                                    artworkFit: BoxFit.cover,
                                    nullArtworkWidget: Container(
                                      width: 48,
                                      height: 48,
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ),
                                if (isPlaying)
      const Positioned.fill(
        child: Center(
          child: AnimatedEqualizer()
        ),
      ),
                              ],
                            ),
                            title: Text(song.title),
                            subtitle: Text(song.artist),
                            trailing: ReorderableDragStartListener(
                              index: index,
                              child: const Icon(Icons.drag_handle_rounded),
                            ),
                            onTap: () {
  final playerBloc = context.read<PlayerBloc>();

  if (song.id == state.currentSong.id) {
    playerBloc.add(TogglePlayPauseEvent());
  } else {
    playerBloc.add(PlaySongEvent(song, state.playlist));
  }
},
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
