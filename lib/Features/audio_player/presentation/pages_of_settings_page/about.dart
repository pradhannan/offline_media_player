import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
              title: const Text('About'),
  centerTitle: false,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                children: [
                  // App icon temp
                  Container(
                    height: 96,
                    width: 96,
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Icon(
                      Icons.music_note_rounded,
                      size: 52,
                      color: colors.onPrimaryContainer,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // App name
                  Text(
                    'S U R  T A A L',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: colors.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Version
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'A simple offline music player designed to give '
                    'you a clean and enjoyable way to listen to your '
                    'local music.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bitcountInk(
                      color: colors.onSurfaceVariant,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  Divider(
                    color: colors.outlineVariant,
                  ),

                  const SizedBox(height: 24),

                  // Developer
                  _AboutItem(
                    icon: Icons.person_outline,
                    title: 'Developed by',
                    value: 'The Pradhan',
                  ),

                  const SizedBox(height: 20),

                  // Framework
                  _AboutItem(
                    icon: Icons.code_rounded,
                    title: 'Built with',
                    value: 'Flutter',
                  ),

                  const SizedBox(height: 28),

                  Divider(
                    color: colors.outlineVariant,
                  ),

                  const SizedBox(height: 20),

                  // Libraries
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading:Icon(
    Icons.code_rounded,
    color: colors.primary,
  ),
                    title: Text(
    'GitHub',
    style: TextStyle(
      color: colors.onSurface,
      fontWeight: FontWeight.w600,
    ),
  ),
                    subtitle: Text(
                      'View the project source code \n https://github.com/pradhannan/offline_media_player',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                 
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.description_outlined,
                      color: colors.primary,
                    ),
                    title: Text(
                      'Licenses',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'View third-party licenses',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: colors.onSurfaceVariant,
                    ),
                    onTap: () {
                      showLicensePage(
                        context: context,
                        applicationName: 'S U R  T A A L',
                        applicationVersion: '1.0.0',
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  Text(
                    'Made with Flutter ❤️',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 13,
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

class _AboutItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _AboutItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          color: colors.primary,
          size: 24,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: GoogleFonts.kablammo(
                color: colors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}