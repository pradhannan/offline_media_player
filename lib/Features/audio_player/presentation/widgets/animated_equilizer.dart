import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedEqualizer extends StatelessWidget {
  const AnimatedEqualizer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Container(
          width: 3,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(),
            )
            .scaleY(
              begin: 0.4,
              end: 1.8,
              duration: Duration(milliseconds: 300 + index * 150),
              alignment: Alignment.bottomCenter,
            );
      }),
    );
  }
}