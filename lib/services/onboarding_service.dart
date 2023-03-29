import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/college/college.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/providers/state_providers.dart';

class OnboardingService {
  final ProviderRef ref;

  const OnboardingService(this.ref);

  Future<bool> attemptAutoOnboard() async {
    return false;
  }

  Future<void> init() async {
    if (await attemptAutoOnboard()) {
      ref.read(appStateProvider.notifier).setOnboarded();
    } else {
      final onboardingUser = ref.read(onboardingUserProvider.notifier);

      final id = ref.read(currentUserProvider).id!;
      final email = ref.read(currentUserProvider).email!;

      onboardingUser.setId(id);
      onboardingUser.setEmail(email);

      College? userCollege = await getCollegeByEmail(email);
      bool hasCollegeEmail = userCollege != null;

      if (hasCollegeEmail) {
        await setCollegeEmail(email, userCollege);
      }
    }

    ref.read(appStateProvider.notifier).setAttemptAutoOnboard();
  }

  Future<void> setCollegeEmail(String email, College? college) async {
    final onboardingUser = ref.read(onboardingUserProvider.notifier);

    onboardingUser.setCollegeEmail(email);
    onboardingUser.setCollege(college);

    final (String username, String avatar) = await generateProfile();

    onboardingUser.setAnonymousUsername(username);
    onboardingUser.setAnonymousProfileImage(avatar);

    await addUserToCollege();
    onboardingUser.setIsCollegeEmailVerified(true);
  }

  Future<College?> getCollegeByEmail(String email) async {
    final apiService = ref.read(apiServiceProvider);
    final response = await apiService.sendGetRequest(endpoint: 'colleges/college/byEmail?email=$email');

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw Exception('Error(getCollegeByEmail): Server responded with ${response.statusCode}.'
          ' Failed to get college by email');
    }

    return response.body.isEmpty ? null : College.fromJson(jsonDecode(response.body));
  }

  Future<void> addUserToCollege() async {
    final onboardingUser = ref.read(onboardingUserProvider);

    final response = await ref
        .read(apiServiceProvider)
        .sendPostRequest(endpoint: 'user/${onboardingUser.id!}/addToCollege/${onboardingUser.college!.id}');

    await ref.read(authServiceProvider).getAuthTokens(forceRefresh: true);

    if (response.statusCode != 200) {
      throw Exception('Error(addUserToCollege): Server responded with ${response.statusCode}.'
          ' Failed to add user to college');
    }
  }

  Future<(String, String)> generateProfile() async {
    final onboardingUser = ref.read(onboardingUserProvider);

    final response = await ref
        .read(apiServiceProvider)
        .sendGetRequest(endpoint: 'user/generateProfile?collegeId=${onboardingUser.college!.id}');

    if (response.statusCode != 200) {
      throw Exception('Error(generateProfile): Server responded with ${response.statusCode}.'
          ' Failed to generate profile');
    }

    switch (jsonDecode(response.body)) {
      case {'username': String username, 'avatar': String avatar}:
        return (username, avatar);
      default:
        throw Exception('Error(generateProfile): Server responded with ${response.statusCode}.'
            ' Failed to generate profile');
    }
  }

  Future<void> onboardUser() async {
    final onboardingUser = ref.read(onboardingUserProvider);
    if (kDebugMode) print(onboardingUser);

    await ref.read(apiServiceProvider).sendPostRequest(endpoint: 'user/onboard');

    ref.read(appStateProvider.notifier).setOnboarded();
  }
}
