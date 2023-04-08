import 'package:socale/navigation/onboarding_navigation/base_onboarding_navigation/pages/base_onboarding_pages.dart';
import 'package:socale/screens/onboarding/onboarding_complete/onboarding_complete_screen.dart';

class OnboardingCompletePage extends BaseOnboardingPage {
  const OnboardingCompletePage({super.key = const ValueKey('onboarding_complete_page')});

  @override
  get child => const OnboardingCompleteScreen();

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
