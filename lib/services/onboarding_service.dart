import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/providers/state_providers.dart';

class OnboardingService {
  final ProviderRef ref;

  const OnboardingService(this.ref);

  Future<bool> attemptAutoOnboard() async {
    if (kDebugMode) print('Checking if user is already onboarded...');
    return false;
  }

  Future<void> init() async {
    if (kDebugMode) print('Initializing Onboarding Service...');

    if (await attemptAutoOnboard()) {
      ref.read(appStateProvider.notifier).setOnboarded();
    } else {
      final onboardingUser = ref.read(onboardingUserProvider.notifier);

      final id = ref.read(currentUserProvider).id!;
      final email = ref.read(currentUserProvider).email!;

      bool hasCollegeEmail = await checkCollegeEmailExists();

      onboardingUser.setId(id: id);
      onboardingUser.setEmail(email: email);

      if (hasCollegeEmail) {
        final (idToken, _, _) = await ref.read(authServiceProvider).getAuthTokens();
        if (idToken.groups.isEmpty) {
          await addUserToCollege();
        }
      }
    }

    ref.read(appStateProvider.notifier).setAttemptAutoOnboard();
  }

  Future<bool> checkCollegeEmailExists() async {
    final email = ref.read(currentUserProvider).email!;

    final service = ref.read(emailVerificationProvider);
    final onboardingUser = ref.read(onboardingUserProvider.notifier);

    onboardingUser.setEmail(email: email);

    if (await service.verifyCollegeEmailValid(email)) {
      onboardingUser.setCollegeEmail(collegeEmail: email);
      onboardingUser.setIsCollegeEmailVerified(isCollegeEmailVerified: true);
      return true;
    }

    return false;
  }

  Future<bool> addUserToCollege() async {
    final onboardingUser = ref.read(onboardingUserProvider);

    final response = await ref.read(apiServiceProvider).sendRequest(
      endpoint: 'add_user_to_college',
      headers: {
        'username': onboardingUser.id!,
        'college': onboardingUser.college!.id,
      },
    );

    await ref.read(authServiceProvider).getAuthTokens(forceRefresh: true);

    if (response.statusCode == 200) return true;
    return false;
  }

  Future<void> onboardUser() async {
    final onboardingUser = ref.read(onboardingUserProvider);
    if (kDebugMode) print(onboardingUser);

    ref.read(appStateProvider.notifier).setOnboarded();
  }
}
