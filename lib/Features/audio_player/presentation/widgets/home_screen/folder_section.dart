import 'package:flutter/material.dart';

class FolderSection extends StatelessWidget {
  final ValueChanged<String> onSectionSelected;
  const FolderSection({super.key, required this.onSectionSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          _FolderTile(title: 'Songs', onTap: () => onSectionSelected('Songs'),),
          _FolderTile(title: 'Albums', onTap: () => onSectionSelected('Albums'),),
          _FolderTile(title: 'Artists', onTap: () => onSectionSelected('Artists'),),
          _FolderTile(title: 'Genres', onTap: () => onSectionSelected('Genres'),),
          _FolderTile(title: 'Playlists', onTap: () => onSectionSelected('Playlists'),),
        ],
      ),
    );
  }
}

class _FolderTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _FolderTile({required this.title, required this.onTap});

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
      child: Material(
        color: colors.surfaceContainerHighest,
    borderRadius: BorderRadius.circular(18),
        child: InkWell(
           borderRadius: BorderRadius.circular(18),
        onTap: onTap,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ),
    );
  }
}
