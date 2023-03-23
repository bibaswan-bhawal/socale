import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/buttons/action_group.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/buttons/outlined_button.dart';
import 'package:socale/components/text/gradient_headline.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/types/auth/state/auth_step_state.dart';

class GetStartedScreen extends ConsumerStatefulWidget {
  const GetStartedScreen({super.key});

  @override
  ConsumerState<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends ConsumerState<GetStartedScreen> with SingleTickerProviderStateMixin {
  late CurvedAnimation animation;
  late AnimationController animationController;

  void goToLogin() => ref
      .read(authStateProvider.notifier)
      .setAuthStep(newStep: AuthStepState.login, previousStep: AuthStepState.getStarted);

  void goToRegister() => ref
      .read(authStateProvider.notifier)
      .setAuthStep(newStep: AuthStepState.register, previousStep: AuthStepState.getStarted);

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: const Duration(seconds: 8), vsync: this);
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeInOutSine);

    Future.delayed(const Duration(seconds: 1), () {
      animationController.repeat(reverse: true);
    });
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
      body: Column(
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
          Flexible(
            flex: 3,
            child: RepaintBoundary(
              child: SizedBox(
                width: size.width,
                height: size.width,
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.translate(
                      offset: Offset(0, -(animation.value - 0.5) * 30),
                      child: child,
                    );
                  },
                  child: Image.asset(
                    'assets/illustrations/illustration_1.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const GradientHeadline(headlinePlain: 'Ready to get', headlineColored: 'Started?'),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Sign in or register to discover what your\ncollege community has to offer.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: (size.width * 0.034),
                      color: ColorValues.textSubtitle,
                    ),
                  ),
                ),
              ],
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
    );
  }
}
