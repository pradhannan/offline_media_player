import 'package:flutter/material.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/player_artwork.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/player_primary_controls.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/player_progress_bar.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/player_secondary_control.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/player_top_bar.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/progress_bar_style.dart';
import 'package:media_player_app/Features/audio_player/presentation/widgets/song_info.dart';

class FullPlayerScreen extends StatelessWidget {
  const FullPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //TOp bar (arrow+sleep)
              PlayerTopBar(onSleepTimerTap: () {}),
              

              //artwork
              Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: PlayerArtwork(imageUrl: null, onTap: () {}),
              )),
              

              //info
              Align(
                alignment: Alignment.centerLeft,
                child: SongInfo(title: "PLACE", artist: "PLACE", onTap: () {}),
              ),
              
              //progress
              PlayerProgressSection(
                position: const Duration(seconds: 45),
                duration: const Duration(minutes: 3, seconds: 45),
                style: ProgressBarStyle.linear,
                onSeek: (newPosition) {},
              ),
              //primary control
              PlayerPrimaryControls(
                isPlaying: false,
                onPlayPause: () {},
                onPrevious: () {},
                onNext: () {},
              ),
              //secondary control
              PlayerSecondaryControls(
                isFavorite: false,
                isShuffle: false,
                isRepeat: false,
                onFavoriteToggle: () {},
                onShuffleToggle: () {},
                onRepeatToggle: () {},
                onQueueTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
