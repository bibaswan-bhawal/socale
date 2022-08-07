import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/translucent_background/translucent_background.dart';
import 'package:socale/values/colors.dart';

class OnboardingIntroScreen extends StatelessWidget {
  const OnboardingIntroScreen({Key? key}) : super(key: key);

  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          TranslucentBackground(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 60),
                child: PrimaryButton(
                  width: size.width - 60,
                  height: 60,
                  colors: [Color(0xFFFD6C00), Color(0xFFFFA133)],
                  text: "Get Started",
                  onClickEventHandler: () => {
                    Get.toNamed('/onboarding'),
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
