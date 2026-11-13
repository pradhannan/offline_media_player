import 'package:flutter/material.dart';
import 'package:media_player_app/Features/audio_player/domain/song_model.dart';
import 'package:media_player_app/Features/audio_player/presentation/Screens/album_page.dart';
import 'package:on_audio_query/on_audio_query.dart' hide SongModel;

class AlbumList extends StatelessWidget {
  final List<SongModel> songs;
  const AlbumList({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    final albums = <String, List<SongModel>>{};

    for (final song in songs) {
      albums.putIfAbsent(song.album, () => <SongModel>[]).add(song);
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              '${albums.length} Albums',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 0.78,
            ),
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final albumName = albums.keys.elementAt(index);
              final albumSongs = albums[albumName]!;
              final firstSong = albumSongs.first;
              return InkWell(
                borderRadius: BorderRadius.circular(16),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AlbumPage(album: albumName, songs: albumSongs),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: double.infinity,
                          child: QueryArtworkWidget(
                            id: int.tryParse(firstSong.id) ?? -1,
                            type: ArtworkType.AUDIO,
                            quality: 100,
                            size: 1000,
                            artworkFit: BoxFit.cover,
                            nullArtworkWidget: Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              child: const Center(
                                child: Icon(Icons.album_rounded, size: 48),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      albumName.isEmpty ? 'Unknown Album' : albumName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      firstSong.artist.isEmpty
                          ? 'Unknown Artist'
                          : firstSong.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${albumSongs.length} songs',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
