import 'package:flutter/material.dart';
import 'app_progress_bar.dart';
import 'progress_bar_style.dart';

class PlayerProgressSection extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration>? onSeek;
  final ProgressBarStyle style;

  const PlayerProgressSection({
    super.key,
    required this.position,
    required this.duration,
    this.onSeek,
    this.style = ProgressBarStyle.linear,
  });

  // Helper method to format Durations into 'MM:SS' strings
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(1, '0');
    final seconds = (duration.inSeconds.remainder(60)).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //  Progress Bar Manager
        AppProgressBar(
          position: position,
          duration: duration,
          onSeek: onSeek,
          style: style,
        ),
        
        //  Position & Duration Timestamps
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: timeStyle,
              ),
              Text(
                _formatDuration(duration),
                style: timeStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}