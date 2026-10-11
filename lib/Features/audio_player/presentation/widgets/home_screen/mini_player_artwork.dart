
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MiniPlayerArtwork extends StatelessWidget {
  final int songId;

  const MiniPlayerArtwork({
    super.key,
    required this.songId,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipOval(
      child: QueryArtworkWidget(
        id: songId,
         keepOldArtwork: true,
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
              colors: [colors.primary, colors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(
            Icons.album_rounded,
            color: colors.onPrimary,
            size: 28,
          ),
        ),
      ),
    );
  }
}

