
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart' hide SongModel;

import '../../Logic/Playlist/playlist_bloc.dart';
import '../../Logic/Playlist/playlist_event.dart';
import '../../Logic/Playlist/playlist_state.dart';
import '../../domain/song_model.dart';

class AddToPlaylistSheet extends StatelessWidget {
  final SongModel song;
  final List<SongModel> allSongs;

  const AddToPlaylistSheet({
    super.key,
    required this.song,
    required this.allSongs,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.35,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.onSurface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 12, 12),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Add to Playlist',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),

              // Playlist list
              Expanded(
                child: BlocBuilder<PlaylistBloc, PlaylistState>(
                  builder: (context, state) {
                    final favoriteSongs = allSongs
                        .where(
                          (s) => state.favoriteSongIds.contains(s.id),
                        )
                        .toList();

                    return ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      children: [
                        // Favorites
                        _buildPlaylistTile(
                          context: context,
                          colors: colors,
                          name: 'Favorites',
                          songCount: favoriteSongs.length,
                          firstSong: favoriteSongs.isEmpty
                              ? null
                              : favoriteSongs.first,
                          isFavorites: true,
                          isAlreadyAdded:
                              state.favoriteSongIds.contains(song.id),
                          onTap: () {
                            if (state.favoriteSongIds.contains(song.id)) {
                              _showMessage(
                                context,
                                'This song is already in Favorites',
                              );
                              return;
                            }

                            context.read<PlaylistBloc>().add(
                                  AddFavoriteEvent(song.id),
                                );

                            Navigator.pop(context);
                          },
                        ),

                        // Custom playlists
                        ...state.playlists.map((playlist) {
                          final ids =
                              state.playlistSongIds[playlist.id] ?? [];

                          final playlistSongs = allSongs
                              .where((s) => ids.contains(s.id))
                              .toList();

                          final alreadyAdded = ids.contains(song.id);

                          return _buildPlaylistTile(
                            context: context,
                            colors: colors,
                            name: playlist.name,
                            songCount: ids.length,
                            firstSong: playlistSongs.isEmpty
                                ? null
                                : playlistSongs.first,
                            isAlreadyAdded: alreadyAdded,
                            onTap: () {
                              if (alreadyAdded) {
                                _showMessage(
                                  context,
                                  'This song is already in ${playlist.name}',
                                );
                                return;
                              }

                              context.read<PlaylistBloc>().add(
                                    AddSongToPlaylistEvent(
                                      playlistId: playlist.id,
                                      songId: song.id,
                                    ),
                                  );

                              Navigator.pop(context);
                            },
                          );
                        }),

                        const SizedBox(height: 8),

                        // Create new playlist
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          leading: Icon(
                            Icons.add_circle_outline_rounded,
                            color: colors.primary,
                            size: 28,
                          ),
                          title: const Text(
                            'Create New Playlist',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () => _showCreatePlaylistDialog(context),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaylistTile({
    required BuildContext context,
    required ColorScheme colors,
    required String name,
    required int songCount,
    required SongModel? firstSong,
    required VoidCallback onTap,
    bool isFavorites = false,
    bool isAlreadyAdded = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        leading: SizedBox(
          width: 48,
          height: 48,
          child: ClipOval(
            child: firstSong != null
                ? QueryArtworkWidget(
                    key: ValueKey(firstSong.id),
                    id: int.tryParse(firstSong.id) ?? -1,
                    type: ArtworkType.AUDIO,
                    size: 600,
                    quality: 100,
                    keepOldArtwork: true,
                    artworkWidth: 48,
                    artworkHeight: 48,
                    artworkFit: BoxFit.cover,
                    nullArtworkWidget: _placeholder(
                      colors,
                      isFavorites,
                    ),
                  )
                : _placeholder(colors, isFavorites),
          ),
        ),
        title: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('$songCount songs'),
        trailing: isAlreadyAdded
            ? Icon(
                Icons.check_circle_rounded,
                color: colors.primary,
              )
            : Icon(
                Icons.add_circle_outline_rounded,
                color: colors.onSurfaceVariant,
              ),
        onTap: onTap,
      ),
    );
  }

  Widget _placeholder(ColorScheme colors, bool isFavorites) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            colors.primary,
            colors.secondary,
          ],
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        isFavorites
            ? Icons.favorite_rounded
            : Icons.music_note_rounded,
        size: 28,
        color: colors.onPrimary,
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
  showDialog(
    context: context,
    useRootNavigator: true,
    builder: (dialogContext) {
      return _CreatePlaylistDialog(
        onCreate: (name) {
          context.read<PlaylistBloc>().add(
                CreatePlaylistEvent(name),
              );
        },
      );
    },
  );
}


  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _CreatePlaylistDialog extends StatefulWidget {
  final ValueChanged<String> onCreate;

  const _CreatePlaylistDialog({
    required this.onCreate,
  });

  @override
  State<_CreatePlaylistDialog> createState() =>
      _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState
    extends State<_CreatePlaylistDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _create() {
    final name = _controller.text.trim();

    if (name.isEmpty) return;

    widget.onCreate(name);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Playlist'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
          hintText: 'Playlist name',
          border: OutlineInputBorder(),
        ),
        onSubmitted: (_) => _create(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _create,
          child: const Text('Create'),
        ),
      ],
    );
  }
}
