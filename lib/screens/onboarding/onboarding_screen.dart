import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/screens/onboarding/onboarding_router_screen.dart';

abstract class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  static List<OnboardingScreenState> allOnboardingScreens(BuildContext context) {
    final result = <OnboardingScreenState>[];

    void visitor(Element element) {
      if (element.widget is OnboardingScreen) {
        final onboardingScreenElement = element as StatefulElement;

        final OnboardingScreenState onboardingScreenState =
            onboardingScreenElement.state as OnboardingScreenState;

        result.add(onboardingScreenState);
      }
      // Don't perform transitions across different Animated Page Views.
      if (element.widget is OnboardingRouterScreen) return;

      element.visitChildren(visitor);
    }

    context.visitChildElements(visitor);

    return result;
  }
}

abstract class OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  Future<bool> onNext();
  Future<bool> onBack();
}
