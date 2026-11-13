
import 'package:flutter/material.dart';
import 'package:media_player_app/Features/audio_player/domain/song_model.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/collapsing_title.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/mini_player.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/song_tile.dart';

class GenrePage extends StatelessWidget {
  final String genre;
  final List<SongModel> songs;

  const GenrePage({
    super.key,
    required this.genre,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
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
                flexibleSpace: CollapsingTitle(title: genre),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(
                    '${songs.length} Songs',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final song = songs[index];

                      return SongTile(song: song, playlist: songs,);
                    },
                    childCount: songs.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 90)),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }
}
