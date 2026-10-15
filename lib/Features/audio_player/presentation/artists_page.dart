import 'package:flutter/material.dart';
import 'package:media_player_app/Features/audio_player/domain/song_model.dart';
import 'package:media_player_app/Features/audio_player/presentation/album_page.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/collapsing_title.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/mini_player.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/song_tile.dart';
import 'package:on_audio_query/on_audio_query.dart' hide SongModel;

class ArtistsPage extends StatelessWidget {
  final String artist;
  final List<SongModel> songs;

  const ArtistsPage({super.key, required this.artist, required this.songs});

  @override
  Widget build(BuildContext context) {
    final albums = <String, List<SongModel>>{};

    for (final song in songs) {
      albums.putIfAbsent(song.album, () => []).add(song);
    }
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                titleSpacing: 0,
                pinned: true,
                expandedHeight: 160,
                collapsedHeight: 64,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),

                flexibleSpace: CollapsingTitle(title: artist),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(
                    '${albums.length} Albums',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.78,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
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
                                  type: ArtworkType.ALBUM,
                                  artworkFit: BoxFit.cover,
                                  nullArtworkWidget: Container(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
                                    child: const Center(
                                      child: Icon(
                                        Icons.album_rounded,
                                        size: 48,
                                      ),
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
                            '${albumSongs.length} songs',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    );
                  }, childCount: albums.length),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Text(
                    'Songs (${songs.length})',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final song = songs[index];

                    return SongTile(song: song);
                  }, childCount: songs.length),
                ),
              ),
            ],
          ),
          Align(alignment: Alignment.bottomCenter, child: MiniPlayer()),
        ],
      ),
    );
  }
}
