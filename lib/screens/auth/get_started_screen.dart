import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/buttons/action_group.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/buttons/outlined_button.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/types/auth/auth_step.dart';
import 'package:socale/utils/system_ui.dart';

class GetStartedScreen extends ConsumerStatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends ConsumerState<GetStartedScreen> with SingleTickerProviderStateMixin {
  late CurvedAnimation animation;
  late AnimationController animationController;

  void goToLogin() => ref.read(authStateProvider.notifier).setAuthStep(newStep: AuthStep.login, previousStep: AuthStep.getStarted);
  void goToRegister() => ref.read(authStateProvider.notifier).setAuthStep(newStep: AuthStep.register, previousStep: AuthStep.getStarted);

  @override
  void initState() {
    super.initState();
    SystemUI.setSystemUIDark();
    animationController = AnimationController(duration: const Duration(seconds: 8), vsync: this);
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeInOutSine)
      ..addListener(() {
        setState(() {});
      });

    animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.stop(canceled: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ScreenScaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Hero(
                tag: 'auth_logo',
                child: SvgPicture.asset('assets/logo/color_logo.svg'),
              ),
            ),
            Expanded(
              child: RepaintBoundary(
                child: Transform.translate(
                  offset: Offset(0, ((size.height * 0.04) * (animation.value - 0.5))),
                  child: Center(
                    child: Image.asset('assets/illustrations/get_started/cover_illustration.png'),
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
                  'Networking made easy',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: (size.width * 0.058),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: SizedBox(
                child: Column(
                  children: [
                    Text(
                      'Boost your social and professional',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: (size.width * 0.038),
                        color: ColorValues.textSubtitle,
                      ),
                    ),
                    Text(
                      'connections with the power of Socale.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: (size.width * 0.038),
                        color: ColorValues.textSubtitle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 36, bottom: 40 - MediaQuery.of(context).viewPadding.bottom),
              child: ActionGroup(
                actions: [
                  GradientButton(
                    text: 'Sign In',
                    onPressed: goToLogin,
                    linearGradient: ColorValues.orangeButtonGradient,
                  ),
                  OutlineButton(
                    text: 'Register',
                    onPressed: goToRegister,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
