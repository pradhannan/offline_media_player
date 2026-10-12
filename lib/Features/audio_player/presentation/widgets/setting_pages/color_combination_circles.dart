


import 'package:flutter/material.dart';

class ColorPalette extends StatelessWidget {
  final String name;
  final List<Color> colors;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorPalette({super.key, 
    required this.name,
    required this.colors, required this.isSelected, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
      final themeColors = Theme.of(context).colorScheme;
      
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? themeColors.primary
                : themeColors.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: colors.map((color) {
                return Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: themeColors.outline,
                    ),
                  ),
                );
              }).toList(),
            ),
                        const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeColors.onSurface,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: themeColors.primary,
                size: 20,
              )
            else
              const SizedBox(height: 20),

          ])
    ));
  }
}
