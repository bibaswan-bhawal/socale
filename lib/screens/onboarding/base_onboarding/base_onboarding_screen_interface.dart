import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/screens/onboarding/base_onboarding/base_onboarding_router.dart';

abstract class BaseOnboardingScreen extends ConsumerStatefulWidget {
  const BaseOnboardingScreen({super.key});

  static List<BaseOnboardingScreenState> allOnboardingScreens(BuildContext context) {
    final result = <BaseOnboardingScreenState>[];

    void visitor(Element element) {
      if (element.widget is BaseOnboardingScreen) {
        final onboardingScreenElement = element as StatefulElement;

        final BaseOnboardingScreenState onboardingScreenState = onboardingScreenElement.state as BaseOnboardingScreenState;

        result.add(onboardingScreenState);
      }
      // Don't perform transitions across different Animated Page Views.
      if (element.widget is BaseOnboardingRouter) return;

      element.visitChildren(visitor);
    }

    context.visitChildElements(visitor);

    return result;
  }
}

abstract class BaseOnboardingScreenState extends ConsumerState<BaseOnboardingScreen> {
  Future<bool> onNext();

  Future<bool> onBack();
}
