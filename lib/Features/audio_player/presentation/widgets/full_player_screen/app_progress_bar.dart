import 'package:flutter/material.dart';
import 'progress_bar_style.dart';

class AppProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration>? onSeek;
  final ProgressBarStyle style;

  const AppProgressBar({
    super.key,
    required this.position,
    required this.duration,
    this.onSeek,
    this.style = ProgressBarStyle.linear,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Convert Durations to milliseconds for the slider
    final double maxDuration = duration.inMilliseconds.toDouble();
    final double currentPosition = position.inMilliseconds
        .toDouble()
        .clamp(0.0, maxDuration > 0 ? maxDuration : 1.0);

    // 2. Select display mode based on style
    switch (style) {
      case ProgressBarStyle.wavy:
        // We will plug in the Wavy track painter here next
        return _buildLinearBar(context, currentPosition, maxDuration);

      case ProgressBarStyle.customCat:
        // Placeholder slot for the future Cat theme
        return _buildLinearBar(context, currentPosition, maxDuration);

      case ProgressBarStyle.linear:
      default:
        return _buildLinearBar(context, currentPosition, maxDuration);
    }
  }

  // --- Base Linear Slider ---
  Widget _buildLinearBar(
      BuildContext context, double positionMs, double durationMs) {
    final colors = Theme.of(context).colorScheme;

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 3.0,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
        activeTrackColor: colors.primary,
        inactiveTrackColor: colors.primary.withAlpha(50),
        thumbColor: colors.primary,
      ),
      child: Slider(
        min: 0.0,
        max: durationMs > 0 ? durationMs : 1.0,
        value: positionMs,
        onChanged: (value) {
          if (onSeek != null) {
            onSeek!(Duration(milliseconds: value.toInt()));
          }
        },
      ),
    );
  }
}