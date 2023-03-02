import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/paginators/page_view_controller.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/providers/navigation_providers.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/services/auth_service.dart';

class OnboardingIntroScreen extends ConsumerWidget {
  final String illustration;
  final String titleBlack;
  final String titleOrange;
  final String message;

  const OnboardingIntroScreen({
    super.key,
    required this.illustration,
    required this.titleBlack,
    required this.titleOrange,
    required this.message,
  });

  back(ref) {
    final onboardingUser = ref.read(onboardingRouterDelegateProvider).onboardingUser;

    if (onboardingUser.currentStep == 0) {
      AuthService.signOutUser();
      ref.read(appStateProvider.notifier).signOut();
    } else {
      ref.read(onboardingRouterDelegateProvider).previousPage();
    }
  }

  next(ref) {
    ref.read(onboardingRouterDelegateProvider).nextPage();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final onboardingUser = ref.watch(onboardingRouterDelegateProvider.select((delegate) => delegate.onboardingUser));

    return ScreenScaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Center(
              child: Image.asset(illustration),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SimpleShadow(
                  opacity: 0.1,
                  offset: const Offset(1, 1),
                  sigma: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        titleBlack,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: size.width * 0.058,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [ColorValues.socaleDarkOrange, ColorValues.socaleOrange],
                        ).createShader(bounds),
                        child: Text(
                          titleOrange,
                          style: GoogleFonts.poppins(fontSize: size.width * 0.058, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 34),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: (size.width * 0.036),
                      color: ColorValues.textSubtitle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Hero(
            tag: 'page_navigator',
            child: Material(
              type: MaterialType.transparency,
              child: PageViewController(
                currentPage: onboardingUser.currentStep,
                pageCount: ref.read(onboardingRouterDelegateProvider).pages.length,
                back: () => back(ref),
                next: () => next(ref),
                nextText: 'Next',
                backText: onboardingUser.currentStep == 0 ? 'Sign Out' : 'Back',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
