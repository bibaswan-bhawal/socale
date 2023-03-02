import 'package:flutter/material.dart';

class LightBackground extends StatelessWidget {
  const LightBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(
      top: -5,
      left: -5,
      child: Image.asset(
        'assets/background/light_background.png',
        width: size.width + 10,
        height: size.height + 10,
        fit: BoxFit.fill,
      ),
    );
  }
}
