import 'package:flutter/material.dart';

class FolderSection extends StatelessWidget {
  final String selectedSection;
  final ValueChanged<String> onSectionSelected;

  const FolderSection({super.key, required this.selectedSection, required this.onSectionSelected, });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
        _FolderTile(
            title: 'Songs',
            isSelected: selectedSection == 'Songs',
            onTap: () => onSectionSelected('Songs'),
          ),
          _FolderTile(
            title: 'Albums',
            isSelected: selectedSection == 'Albums',
            onTap: () => onSectionSelected('Albums'),
          ),
          _FolderTile(
            title: 'Artists',
            isSelected: selectedSection == 'Artists',
            onTap: () => onSectionSelected('Artists'),
          ),
          _FolderTile(
            title: 'Genres',
            isSelected: selectedSection == 'Genres',
            onTap: () => onSectionSelected('Genres'),
          ),
          _FolderTile(
            title: 'Playlists',
            isSelected: selectedSection == 'Playlists',
            onTap: () => onSectionSelected('Playlists'),
          ),
        ],
      ),
    );
  }
}

class _FolderTile extends StatelessWidget {
   final String title; 
  final bool isSelected; 
  final VoidCallback onTap; 



  const _FolderTile({required this.title, required this.isSelected, required this.onTap,});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      decoration: BoxDecoration(
      color:
             colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      
        border: Border.all(
          color: colors.outline,
        ),
       
      ),
      
      child: Material(
        color: colors.surfaceContainerHighest,
    borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
           borderRadius: BorderRadius.circular(18),
       
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
