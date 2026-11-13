
import 'package:flutter/material.dart';
import 'package:media_player_app/Features/audio_player/domain/song_model.dart';
import 'package:media_player_app/Features/audio_player/presentation/Screens/artists_page.dart';
import 'package:on_audio_query/on_audio_query.dart' hide SongModel;

class ArtistList extends StatelessWidget {
  final List<SongModel> songs;

  const ArtistList({
    super.key,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    final artists = <String, List<SongModel>>{};

    for (final song in songs) {
 final artist = (song.artist ).trim();
  final artistName = artist.isEmpty ? 'Unknown Artist' : artist;

  artists.putIfAbsent(artistName, () => <SongModel>[]).add(song);
    }

    final artistNames = artists.keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    final colors = Theme.of(context).colorScheme;

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 20,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final artistName = artistNames[index];
            final artistSongs = artists[artistName]!;
            debugPrint('Artist: $artistName, ID: ${artistSongs.first.artistId}');

            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ArtistsPage(
                      artist: artistName,
                      songs: artistSongs,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child:ClipOval(
  child: QueryArtworkWidget(
    
 id: int.tryParse(artistSongs.first.artistId ?? '') ?? -1,
type: ArtworkType.ARTIST,
    artworkFit: BoxFit.cover,
    size: 600,
    quality: 100,
    keepOldArtwork: true,
    nullArtworkWidget: Container(
      color: colors.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.person_rounded,
        size: 52,
        color: colors.onSurfaceVariant,
      ),
    ),
  ),
)
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    artistName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                 
                ],
              ),
            );
          },
          childCount: artistNames.length,
        ),
      ),
    );
  }
}
