import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/backgrounds/light_onboarding_background.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/buttons/outlined_button.dart';
import 'package:socale/main.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/utils/debug_print_statements.dart';
import 'package:socale/utils/size_config.dart';
import 'package:socale/utils/system_ui.dart';

class GetStartedScreen extends ConsumerStatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends ConsumerState<GetStartedScreen> with SingleTickerProviderStateMixin {
  late CurvedAnimation animation;
  late AnimationController animationController;

  void goToLogin() async {}
  goToRegister() async {}

  @override
  void initState() {
    super.initState();
    SystemUI.setSystemUIDark();
    animationController = AnimationController(duration: const Duration(seconds: 5), vsync: this);
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeInOutSine)
      ..addListener(() {
        setState(() {});
      });

    animationController.repeat(reverse: true);

    printRunTime(appStartTime, "total app startTime");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          const LightOnboardingBackground(),
          SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SvgPicture.asset('assets/logo/color_logo.svg'),
                  ),
                  Expanded(
                    child: Transform.translate(
                      offset: Offset(0, ((size.height * 0.04) * (animation.value - 0.5))),
                      child: Center(
                        child: SimpleShadow(
                          opacity: 0.10,
                          offset: const Offset(1, 1),
                          sigma: 2,
                          child: Image.asset('assets/get_started/cover_illustration.png'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SimpleShadow(
                      opacity: 0.1,
                      offset: const Offset(1, 1),
                      sigma: 1,
                      child: Text(
                        "Networking Made Easy",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: (size.width * 0.058),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      left: size.width * 0.14,
                      right: size.width * 0.14,
                      bottom: 20,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Boost your social and professional",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: (size.width * 0.04),
                          ),
                        ),
                        Text(
                          "connections with the power of Socale.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: (size.width * 0.04),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SimpleShadow(
                      opacity: 0.25,
                      offset: const Offset(1, 1),
                      sigma: 3,
                      child: GradientButton(
                        width: size.width - 60,
                        height: 48,
                        linearGradient: ColorValues.socaleGradient,
                        buttonContent: Text(
                          "Sign In",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        onClickEvent: goToLogin,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: MediaQuery.of(context).padding.bottom != 0 ? 10 : 20),
                    child: OutlineButton(
                      width: size.width - 60,
                      height: 48,
                      buttonContent: Text(
                        "Register",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      onClickEvent: goToRegister,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
