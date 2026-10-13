import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_player_app/Features/Core/color_palettes.dart';
import 'package:media_player_app/Features/audio_player/Logic/Theme/theme_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Theme/theme_event.dart';
import 'package:media_player_app/Features/audio_player/Logic/Theme/theme_state.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/setting_pages/color_combination_circles.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/setting_pages/container_settings.dart';

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text('Appearance'),
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CHANGED: Test SettingsContainer
                  BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, state) {
                      return SettingsContainer(
                        title: 'Theme',
                        subtitle: 'Choose how the app looks',
                        switchValue: state.themeMode == ThemeMode.dark,
                        onSwitchChanged: (value) {
                          context.read<ThemeBloc>().add(
                            ThemeModeChanged(
                              value ? ThemeMode.dark : ThemeMode.light,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  SettingsContainer(
                    title: 'Cat Theme',
                    subtitle: 'Give your player a cat-inspired look',
                    switchValue: false,
                    onSwitchChanged: (value) {},
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.outline),
                      boxShadow: const [
                        BoxShadow(blurRadius: 6, offset: Offset(0, 3)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Color Scheme',
                          style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Choose the look for your music player",
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),

                        

                        BlocBuilder<ThemeBloc, ThemeState>(
                          builder: (context, state) {
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: colorPalettes.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1.0,
                                  ),
                              itemBuilder: (context, index) {
                                final palette = colorPalettes[index];
                                return ColorPalette(
                                  name: palette.name,
                                  colors: [
                                    palette.darkBackground,
                                    palette.darkPrimary,
                                  ],
                                  isSelected:
                                      state.selectedPalette == palette.name,
                                  onTap: () {
                                    context.read<ThemeBloc>().add(
                                      ColorPaletteChanged(palette.name),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
