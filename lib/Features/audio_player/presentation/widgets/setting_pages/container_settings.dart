import 'package:flutter/material.dart';

class SettingsContainer extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final VoidCallback? onTap;
  final ThemeMode? themeMode;
final ValueChanged<ThemeMode>? onThemeModeChanged;

  const SettingsContainer({
    super.key,
    required this.title,
    this.subtitle,
    this.switchValue,
    this.onSwitchChanged,
    this.onTap, this.themeMode, this.onThemeModeChanged,
  });

  @override
Widget build(BuildContext context) {
  final colors = Theme.of(context).colorScheme;

  return InkWell(
    onTap: onTap,
     borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outline,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
    
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
               
              ],
            ),
          ),
          if (switchValue != null)
        Switch(
          value: switchValue!,
          onChanged: onSwitchChanged,
        ),
        ],
      ),
    ),
  );
}
}