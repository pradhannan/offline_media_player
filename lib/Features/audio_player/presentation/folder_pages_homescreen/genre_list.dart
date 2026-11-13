
import 'package:flutter/material.dart';
import 'package:media_player_app/Features/audio_player/domain/song_model.dart';
import 'package:media_player_app/Features/audio_player/presentation/Screens/genrepage.dart';
import 'package:on_audio_query/on_audio_query.dart' hide SongModel;

class GenreList extends StatelessWidget {
  final List<SongModel> songs;

  const GenreList({
    super.key,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    final genres = <String, List<SongModel>>{};

    for (final song in songs) {
      final genre = (song.genre ?? '').trim();

      if (genre.isEmpty) continue;

      genres.putIfAbsent(genre, () => <SongModel>[]).add(song);
    }

    final genreNames = genres.keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    final colors = Theme.of(context).colorScheme;

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final genreName = genreNames[index];
            final genreSongs = genres[genreName]!;
            final firstSong = genreSongs.first;

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
                    child: QueryArtworkWidget(
                      key: ValueKey(firstSong.id),
                      id: int.tryParse(firstSong.id) ?? -1,
                      type: ArtworkType.AUDIO,
                      size: 600,
                      quality: 100,
                      keepOldArtwork: true,
                      artworkWidth: 48,
                      artworkHeight: 48,
                      artworkFit: BoxFit.cover,
                      nullArtworkWidget: _placeholder(colors),
                    ),
                  ),
                ),
                title: Text(
                  genreName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${genreSongs.length} songs',
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GenrePage(
                        genre: genreName,
                        songs: genreSongs,
                      ),
                    ),
                  );
                },
              ),
            );
          },
          childCount: genreNames.length,
        ),
      ),
    );
  }

  Widget _placeholder(ColorScheme colors) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [colors.primary, colors.secondary],
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.music_note_rounded,
        size: 28,
        color: colors.onPrimary,
      ),
    );
  }
}
