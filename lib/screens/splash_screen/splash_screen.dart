import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socale/theme/colors.dart';
import 'package:socale/theme/size_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer timer = Timer(Duration(seconds: 2), () {
    Get.offAllNamed('/login');
  });

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: SocaleGradients.mainBackgroundGradient,
        ),
        child: Center(
          child: Image.asset(
            'assets/images/Socale-Splash-Logo.png',
            width: sy * 60,
          ),
        ),
      ),
    );
  }
}
