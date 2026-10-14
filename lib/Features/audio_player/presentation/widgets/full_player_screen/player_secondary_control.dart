import 'package:flutter/material.dart' hide RepeatMode;
import 'package:media_player_app/Features/audio_player/Logic/Player/player_state.dart';

class PlayerSecondaryControls extends StatelessWidget {
  final bool isFavorite;
  final bool isShuffle;
    final RepeatMode repeatMode;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onShuffleToggle;
  final VoidCallback onRepeatToggle;
  final VoidCallback onQueueTap;

 const PlayerSecondaryControls({
  super.key,
  required this.isFavorite,
  required this.isShuffle,
  required this.repeatMode,
  required this.onFavoriteToggle,
  required this.onShuffleToggle,
  required this.onRepeatToggle,
  required this.onQueueTap,
});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isRepeatEnabled = repeatMode != RepeatMode.off;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Repeat Mode Toggle
        // Repeat Mode Toggle
IconButton(
  tooltip: switch (repeatMode) {
    RepeatMode.off => 'Repeat Off',
    RepeatMode.all => 'Repeat All',
    RepeatMode.one => 'Repeat One',
  },
  iconSize: 26,
  icon: Icon(
    repeatMode == RepeatMode.one
        ? Icons.repeat_one_rounded
        : Icons.repeat_rounded,
  ),
 color: repeatMode == RepeatMode.off
    ? colors.primary
    : colors.outline,
  onPressed: onRepeatToggle,
),
        // Favorite Toggle
        IconButton(
            iconSize: 26,
          icon: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          ),
          color: isFavorite ? colors.primary : colors.onSurfaceVariant,
          onPressed: onFavoriteToggle,
        ),

        // Queue Button
        IconButton(
            iconSize: 26,
          icon: const Icon(Icons.queue_music_rounded),
          color: colors.onSurfaceVariant,
          onPressed: onQueueTap,
        ),

        //  Shuffle Toggle
        IconButton(
            iconSize: 26,
          icon: const Icon(Icons.shuffle_rounded),
          color: isShuffle ? colors.outline : colors.primary,
          onPressed: onShuffleToggle,
        ),
      ],
    );
  }
}