import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerArtwork extends StatelessWidget {
  final int songId;
  final String? imageUrl;
  final VoidCallback onTap;
  const PlayerArtwork({super.key, required this.onTap, this.imageUrl, required this.songId,});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        
      },
      
      child: FittedBox(fit: BoxFit.contain,
      child: SizedBox(
        height: 325,
        width: 325,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: colors.surfaceContainerHighest,
            child: Container(
              color: colors.surfaceContainerHighest,
              child: QueryArtworkWidget(
              id: songId,
              type: ArtworkType.AUDIO,
                 quality: 100,
  size: 600,
  artworkWidth: 325,
  artworkHeight: 325,
  artworkQuality: FilterQuality.high,
              keepOldArtwork: true,
              nullArtworkWidget: _buildPlaceholder(colors),
            ),
        
          ),
        ),
      ),)),
    );


  }

  Widget _buildPlaceholder(ColorScheme colors) {
    return Center(
      child: Icon(
        Icons.music_note,
        size: 80,
        color: colors.onSurfaceVariant.withAlpha(120),
      ),
    );
  }
}