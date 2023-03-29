import 'package:socale/navigation/onboarding_navigation/base_onboarding_navigation/pages/onboarding_page_interface.dart';
import 'package:socale/screens/onboarding/base_onboarding/intro/intro_screen.dart';

class OnboardingIntroPage extends BaseOnboardingPage {
  const OnboardingIntroPage({super.key = const ValueKey('onboarding_intro_page')});

  @override
  get child => const OnboardingIntroScreen();

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideHorizontalTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }
}
