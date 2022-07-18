import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socale/theme/colors.dart';
import 'package:socale/theme/size_config.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: SocaleGradients.mainBackgroundGradient,
        ),
        child: Center(
          child: Image.asset(
            'assets/images/socale_logo_bw.png',
            width: sy * 60,
          ),
        ),
      ),
    );
  }
}
