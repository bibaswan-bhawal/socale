import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/providers/state_providers.dart';

class OnboardingService {
  ProviderRef ref;

  late String apiHost;

  OnboardingService(this.ref) {
    apiHost = const String.fromEnvironment('BACKEND_URL');
  }

  Future<bool> attemptAutoOnboard() async {
    return false;
  }

  Future<void> init() async {
    final isOnboarded = await attemptAutoOnboard();

    if (isOnboarded) {
      ref.read(appStateProvider.notifier).setOnboarded();
    } else {
      bool hasCollegeEmail = await checkCollegeEmailExists();

      final currentUser = ref.read(currentUserProvider);
      final onboardingUser = ref.read(onboardingUserProvider.notifier);
      onboardingUser.setEmail(email: currentUser.email);

      if (hasCollegeEmail) {
        final (idToken, _, _) = await ref.read(authServiceProvider).getAuthTokens();
        if(idToken.groups.isEmpty) {
          await addUserToCollege();
        }
      }
    }
    print('Hello, World!');

    ref.read(appStateProvider.notifier).setAttemptAutoOnboard();
  }

  Future<bool> checkCollegeEmailExists() async {
    final email = ref.read(currentUserProvider).email;
    final service = ref.read(emailVerificationProvider);
    final onboardingUser = ref.read(onboardingUserProvider.notifier);

    final verifyValidCollegeEmail = await service.verifyCollegeEmailValid(email);

    if (verifyValidCollegeEmail) {
      onboardingUser.setCollegeEmail(collegeEmail: email);
      return true;
    }

    return false;
  }

  Future<bool> addUserToCollege() async {
    final (idToken, _, _) = await ref.read(authServiceProvider).getAuthTokens();
    final onboardingUser = ref.read(onboardingUserProvider);

    final userId = (await Amplify.Auth.getCurrentUser()).userId;

    final response = await http.get(
      Uri.parse('$apiHost/api/add_user_to_college'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${idToken.raw}',
        'username': userId,
        'college': onboardingUser.college!.id,
      },
    );

    await ref.read(authServiceProvider).getAuthTokens(forceRefresh: true);

    if (response.statusCode == 200) return true;
    return false;
  }
}
