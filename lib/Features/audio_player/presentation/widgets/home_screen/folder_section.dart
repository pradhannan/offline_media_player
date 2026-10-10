import 'package:flutter/material.dart';

class FolderSection extends StatelessWidget {
  const FolderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: const [
          _FolderTile(title: 'Songs'),
          _FolderTile(title: 'Albums'),
          _FolderTile(title: 'Artists'),
          _FolderTile(title: 'Genres'),
          _FolderTile(title: 'Playlists'),
        ],
      ),
    );
  }
}

class _FolderTile extends StatelessWidget {
  final String title;

  const _FolderTile({required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}
