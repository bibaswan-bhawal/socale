import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/providers/state_providers.dart';

class OnboardingService {
  ProviderRef ref;

  OnboardingService(this.ref);

  Future<bool> attemptAutoOnboard() async {
    return false;
  }

  Future<void> init() async {
    final isOnboarded = await attemptAutoOnboard();

    if (isOnboarded) {
      ref.read(appStateProvider.notifier).setOnboarded();
    } else {
      await checkCollegeEmailExists();
    }

    ref.read(appStateProvider.notifier).setAttemptAutoOnboard();
  }

  Future<void> checkCollegeEmailExists() async {
    final email = ref.read(currentUserProvider).email;
    final service = ref.read(emailVerificationProvider);
    final onboardingUser = ref.read(onboardingUserProvider.notifier);

    final verifyValidCollegeEmail = await service.verifyCollegeEmailValid(email);

    if (verifyValidCollegeEmail) {
      onboardingUser.setEmail(email: email);
      onboardingUser.setCollegeEmail(collegeEmail: email);
    }
  }
}
