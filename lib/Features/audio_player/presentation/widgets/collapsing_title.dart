import 'package:flutter/material.dart';

class CollapsingTitle extends StatelessWidget {
  final String title;

  const CollapsingTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(    //how much space widget currently has.
      builder: (context, constraints) {
        final progress =
            ((constraints.maxHeight - 64) / 96).clamp(0.0, 1.0);

            //the app bar's current height- collapsed / difference between expand and collapse
    //keeping the result between 0 to 1
    // 1.0 means fully expanded. 0.5 means halfway collapsed. 0.0 means fully collapsed.


        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: 16 + (50 * (1 - progress)),
              //          //expanded title on left + (how many pixels right ..)

              right: 16,
              bottom: 10 + (20 * progress),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 22 + (12 * progress),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}