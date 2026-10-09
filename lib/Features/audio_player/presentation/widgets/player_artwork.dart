import 'package:flutter/material.dart';

class PlayerArtwork extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onTap;
  const PlayerArtwork({super.key, required this.onTap, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        
      },
      
      child: FittedBox(fit: BoxFit.contain,
      child: SizedBox(
        height: 300,
        width: 300,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: colors.surfaceContainerHighest,
            child: Container(
              color: colors.surfaceContainerHighest,
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(colors),
                    )
                  : _buildPlaceholder(colors),
            ),
        
          ),
        ),
      ),),
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