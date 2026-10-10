import 'package:flutter/material.dart';

class PlayerSecondaryControls extends StatelessWidget {
  final bool isFavorite;
  final bool isShuffle;
  final bool isRepeat;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onShuffleToggle;
  final VoidCallback onRepeatToggle;
  final VoidCallback onQueueTap;

  const PlayerSecondaryControls({
    super.key,
    required this.isFavorite,
    required this.isShuffle,
    required this.isRepeat,
    required this.onFavoriteToggle,
    required this.onShuffleToggle,
    required this.onRepeatToggle,
    required this.onQueueTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Repeat Mode Toggle
        IconButton(
          icon: Icon(
            isRepeat ? Icons.repeat_one_rounded : Icons.repeat_rounded,
          ),
          color: isRepeat ? colors.primary : colors.onSurfaceVariant,
          onPressed: onRepeatToggle,
        ),

        // Favorite Toggle
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          ),
          color: isFavorite ? colors.primary : colors.onSurfaceVariant,
          onPressed: onFavoriteToggle,
        ),

        // Queue Button
        IconButton(
          icon: const Icon(Icons.queue_music_rounded),
          color: colors.onSurfaceVariant,
          onPressed: onQueueTap,
        ),

        //  Shuffle Toggle
        IconButton(
          icon: const Icon(Icons.shuffle_rounded),
          color: isShuffle ? colors.primary : colors.onSurfaceVariant,
          onPressed: onShuffleToggle,
        ),
      ],
    );
  }
}