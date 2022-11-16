import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:socale/resources/colors.dart';

class LightOnboardingBackground extends StatelessWidget {
  const LightOnboardingBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final circleRadius = size.width * 1.4;
    return Stack(
      children: [
        Container(
          color: Colors.white,
          width: size.width,
          height: size.height,
        ),
        drawCircles(circleRadius),
        Positioned(
          left: -40,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
            child: Container(
              color: Colors.white.withOpacity(0.85),
              width: size.width + 40,
              height: size.height,
            ),
          ),
        ),
      ],
    );
  }
}

Widget drawCircles(double circleRadius) {
  return Stack(
    children: [
      Positioned(
        top: -(circleRadius / 2.5),
        left: -(circleRadius / 2),
        child: Container(
          width: circleRadius,
          height: circleRadius,
          decoration: BoxDecoration(
            gradient: ColorValues.blueGradient,
            borderRadius: BorderRadius.circular(circleRadius / 2),
          ),
        ),
      ),
      Positioned(
        bottom: -(circleRadius / 2.5),
        right: -(circleRadius / 2),
        child: Container(
          width: circleRadius,
          height: circleRadius,
          decoration: BoxDecoration(
            gradient: ColorValues.purpleGradient,
            borderRadius: BorderRadius.circular(circleRadius / 2),
          ),
        ),
      )
    ],
  );
}
