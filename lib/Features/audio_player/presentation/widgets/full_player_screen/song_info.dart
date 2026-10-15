import 'package:flutter/material.dart';

class Songtitlealbum extends StatelessWidget {
  final String title;
  final String artist;
  final VoidCallback onTap;
  const Songtitlealbum({super.key, required this.title, required this.artist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
  title,
  style: theme.textTheme.headlineSmall?.copyWith(
    fontSize: 30,
  fontWeight: FontWeight.w900,
    letterSpacing: 0.3,
  ),
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
),
          const SizedBox(height: 4.0),
          Text(
  artist,
  style: theme.textTheme.titleMedium?.copyWith(
    color: theme.colorScheme.onSurfaceVariant,
  ),
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
),
        ],
      ),
    );
  }
}