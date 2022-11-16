import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/utils/size_config.dart';
import 'package:socale/utils/system_ui.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    SystemUI.setSystemUILight();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    SizeConfig().init(context);

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: ColorValues.orangeBackgroundGradient,
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/logo/white_logo.svg',
            width: size.width * 0.35,
          ),
        ),
      ),
    );
  }
}
