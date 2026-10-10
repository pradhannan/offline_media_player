import 'package:flutter/material.dart';

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
          SliverList(
            delegate: SliverChildListDelegate([
              const ListTile(title: Text('Appearance')),
              const ListTile(title: Text('Playback')),
              const ListTile(title: Text('Audio')),
            ]),
          ),
        ],
      ),
    );
  }
}
