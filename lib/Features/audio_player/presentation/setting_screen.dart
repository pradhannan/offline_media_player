import 'package:flutter/material.dart';
import 'package:media_player_app/Features/audio_player/presentation/pages_of_settings_page/about.dart';
import 'package:media_player_app/Features/audio_player/presentation/pages_of_settings_page/appearance_setting.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/setting_pages/container_settings.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('Settings'),
              titlePadding: EdgeInsets.only(left: 16, bottom: 16),
              collapseMode: CollapseMode.pin,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SettingsContainer(
                  title: 'Appearance',
                  subtitle: 'Theme and visual style',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppearanceSettingsScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                SettingsContainer(
                  title: 'UI',
                  subtitle: 'Player interface and controls',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                SettingsContainer(
                  title: 'About',
                  subtitle: 'App information and licenses',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutScreen(),
                      ),
                    );
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
