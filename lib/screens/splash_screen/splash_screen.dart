import 'package:flutter/material.dart';
import 'package:socale/utils/system_ui_setter.dart';
import 'package:socale/values/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setSystemUILight();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: ColorValues.socaleOrange,
        ),
        child: Center(
          child: Image.asset(
            'assets/images/socale_logo_splash.png',
            width: 1152,
          ),
        ),
      ),
    );
  }
}
