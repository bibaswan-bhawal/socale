import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socale/theme/colors.dart';

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

    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: SocaleGradients.mainBackgroundGradient,
        ),
        child: Center(
          child: Image.asset(
            'assets/images/socale_logo_bw.png',
            width: size.width / 2,
          ),
        ),
      ),
    );
  }
}
