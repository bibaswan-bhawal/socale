import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/onboarding_user.dart';

class OnboardingUserNotifier extends StateNotifier<OnboardingUser> {
  KeepAliveLink? disposeLink;

  AutoDisposeStateNotifierProviderRef ref;

  OnboardingUserNotifier(this.ref) : super(OnboardingUser()) {
    disposeLink = ref.keepAlive();
  }

  setCollege({college}) => state.college = college;

  @override
  dispose() {
    super.dispose();
    disposeLink?.close();
  }
}
