import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_bloc.dart';
import 'package:media_player_app/Features/audio_player/Logic/Player/player_state.dart';

class PlayerTopBar extends StatelessWidget {
  final VoidCallback onSleepTimerTap;
  const PlayerTopBar({super.key, required this.onSleepTimerTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.keyboard_arrow_down)),

        IconButton(onPressed: onSleepTimerTap, icon: BlocBuilder<PlayerBloc, PlayerState>(
  builder: (context, state) {
    final isSleepTimerActive =
        state is PlayerStatusState && state.isSleepTimerActive;

    return Icon(
      isSleepTimerActive
          ? Icons.nights_stay_rounded
          : Icons.punch_clock,
      color: isSleepTimerActive
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onSurface,
    );
  },
))
        
      ],
    );
  }
}