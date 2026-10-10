import 'package:flutter/material.dart';

class PlayerPrimaryControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const PlayerPrimaryControls({
    super.key,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Previous Track Button
        IconButton(
          iconSize: 36.0,
          icon: const Icon(Icons.skip_previous_rounded),
          color: colors.onSurface,
          onPressed: onPrevious,
        ),

        //  Main Play / Pause Button
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.primary,
          ),
          child: IconButton(
            iconSize: 42.0,
            icon: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            ),
            color: colors.onPrimary,
            onPressed: onPlayPause,
          ),
        ),

        //  Next Track Button
        IconButton(
          iconSize: 36.0,
          icon: const Icon(Icons.skip_next_rounded),
          color: colors.onSurface,
          onPressed: onNext,
        ),
      ],
    );
  }
}