import 'package:flutter/material.dart';

class LightOnboardingBackground extends StatelessWidget {
  const LightOnboardingBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      child: Image.asset(
        'assets/background/light_background.png',
        width: size.width,
        height: size.height,
        fit: BoxFit.fill,
      ),
    );
  }
}
