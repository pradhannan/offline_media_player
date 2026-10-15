
import 'package:flutter/material.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/collapsing_title.dart';
import 'package:on_audio_query/on_audio_query.dart' hide SongModel;
import 'package:media_player_app/Features/audio_player/domain/song_model.dart';

class SongInfo extends StatelessWidget {

  final SongModel song;

  const SongInfo({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
           flexibleSpace: CollapsingTitle(title: "Song Info"),
          ),

         
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.outline),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    
                      
               
ClipOval(
  child: SizedBox(
    height: 220,
    width: 220,
    child: QueryArtworkWidget(
      keepOldArtwork: true,
      id: int.parse(song.id),
      type: ArtworkType.AUDIO,
      artworkFit: BoxFit.cover,
      nullArtworkWidget: Container(
        color: colors.surfaceContainerHighest,
        child: const Icon(
          Icons.music_note_rounded,
          size: 80,
        ),
      ),
    ),
  ),
),

                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),

         
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.outline),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   
                    _buildInfoRow(context, 'Title', song.title),
                    _buildInfoRow(context, 'Artist', song.artist),
                    _buildInfoRow(context, 'Album', song.album),

                    _buildInfoRow(
                      context,
                      'Duration',
                      _formatDuration(song.duration),
                    ),

                    
                    _buildInfoRow(context, 'File path', song.uri),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Unknown' : value,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }


  String _formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);

    return '${duration.inMinutes}:'
        '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}
