import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/college/college.dart';
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

  Future<void> init(BuildContext context) async {
    if (kDebugMode) print('Initializing Onboarding Service...');

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
        if (context.mounted) await setCollegeEmail(email, userCollege, context);
      }
    }

    ref.read(appStateProvider.notifier).setAttemptAutoOnboard();
  }

  Future<void> setCollegeEmail(String email, College? college, BuildContext context) async {
    final onboardingUser = ref.read(onboardingUserProvider.notifier);

    onboardingUser.setCollegeEmail(email);
    onboardingUser.setCollege(college);

    if (ref.read(onboardingUserProvider).college!.profileImage != null) {
      await precacheImage(ref.read(onboardingUserProvider).college!.profileImage!.image, context);
    }

    await addUserToCollege();
    onboardingUser.setIsCollegeEmailVerified(true);
  }

  Future<College?> getCollegeByEmail(String email) async {
    final apiService = ref.read(apiServiceProvider);
    final response = await apiService.sendGetRequest(endpoint: 'colleges/college/byEmail?email=$email');

    if (response.statusCode != 200) throw Exception('Error: Server responded with status code: ${response.statusCode}');
    if (kDebugMode) print('Does College Exist: ${response.body.isNotEmpty}');
    if (kDebugMode) print('College: ${response.body}');

    return response.body.isEmpty ? null : College.fromJson(jsonDecode(response.body));
  }

  Future<void> addUserToCollege() async {
    final onboardingUser = ref.read(onboardingUserProvider);

    final response = await ref
        .read(apiServiceProvider)
        .sendPostRequest(endpoint: 'user/${onboardingUser.id!}/add/college/${onboardingUser.college!.id}');

    await ref.read(authServiceProvider).getAuthTokens(forceRefresh: true);

    if (response.statusCode == 200) return;

    throw Exception('Failed to add user to college');
  }

  Future<void> onboardUser() async {
    final onboardingUser = ref.read(onboardingUserProvider);
    if (kDebugMode) print(onboardingUser);

    ref.read(appStateProvider.notifier).setOnboarded();
  }
}
