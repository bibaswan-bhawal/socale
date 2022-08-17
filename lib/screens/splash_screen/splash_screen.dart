import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socale/values/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

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
