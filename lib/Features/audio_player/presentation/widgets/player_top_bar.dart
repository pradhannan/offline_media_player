import 'package:flutter/material.dart';

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

        IconButton(onPressed: onSleepTimerTap, icon: Icon(Icons.timer_off_outlined))
        
      ],
    );
  }
}