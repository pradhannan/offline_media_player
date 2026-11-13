import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Playlist/playlist_event.dart';
import 'package:media_player_app/Features/audio_player/presentation/Screens/playlist_page.dart';
import 'package:on_audio_query/on_audio_query.dart' hide SongModel;

import '../../Logic/Playlist/playlist_bloc.dart';
import '../../Logic/Playlist/playlist_state.dart';
import '../../domain/song_model.dart';

class PlaylistList extends StatelessWidget {
  final List<SongModel> songs;

  const PlaylistList({
    super.key,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        final favoriteSongs = songs
            .where((song) => state.favoriteSongIds.contains(song.id))
            .toList();

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Favorites always appears first.
                if (index == 0) {
                  return _buildPlaylistTile(
                    context: context,
                    colors: colors,
                    name: 'Favorites',
                    songCount: favoriteSongs.length,
                    firstSong: favoriteSongs.isEmpty
                        ? null
                        : favoriteSongs.first,
                    isFavorites: true,
                  );
                }

                // Custom playlists appear after Favorites.
                final playlist = state.playlists[index - 1];

                final playlistSongIds =
                    state.playlistSongIds[playlist.id] ?? [];

                final playlistSongs = songs
                    .where(
                      (song) => playlistSongIds.contains(song.id),
                    )
                    .toList();

                return _buildPlaylistTile(
                  playlistId: playlist.id,
                  context: context,
                  colors: colors,
                  name: playlist.name,
                  songCount: playlistSongIds.length,
                  firstSong: playlistSongs.isEmpty
                      ? null
                      : playlistSongs.first,
                );
              },
              childCount: state.playlists.length + 1,
            ),
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
    bool isFavorites = false,
    int? playlistId,
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
        onTap: () {
  if (!isFavorites && playlistId != null) {
    context.read<PlaylistBloc>().add(
      // ignore: unnecessary_non_null_assertion
      LoadPlaylistSongsEvent(playlistId!),
    );
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PlaylistPage(
        playlistName: name,
        isFavorites: isFavorites,
        playlistId: playlistId,
      ),
    ),
  );
},
trailing: isFavorites
    ? null
    : PopupMenuButton<String>(
        onSelected: (value) {
         if (value == 'rename') {
  String newName = name;

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Rename playlist'),
      content: TextFormField(
        initialValue: name,
        autofocus: true,
        onChanged: (value) {
          newName = value.trim();
        },
        decoration: const InputDecoration(
          hintText: 'Playlist name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (newName.isNotEmpty && newName != name) {
              context.read<PlaylistBloc>().add(
                RenamePlaylistEvent(
                  playlistId: playlistId!,
                  newName: newName,
                ),
              );
            }

            Navigator.pop(dialogContext);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}else if (value == 'delete') {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete playlist?'),
      content: const Text(
        'Are you sure you want to delete this playlist?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            context.read<PlaylistBloc>().add(
              DeletePlaylistEvent(playlistId!),
            );
            Navigator.pop(dialogContext);
          },
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
        },
        itemBuilder: (context) => const [
          PopupMenuItem(
            value: 'rename',
            child: Text('Rename'),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Text('Delete'),
          ),
        ],
      ),
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
}