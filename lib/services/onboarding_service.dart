import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
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
    DateTime startTime = DateTime.now();

    if (await attemptAutoOnboard()) {
      ref.read(appStateProvider.notifier).setOnboarded();
    } else {
      final onboardingUser = ref.read(onboardingUserProvider.notifier);

      final id = ref
          .read(currentUserProvider)
          .id!;

      final email = ref
          .read(currentUserProvider)
          .email!;

      onboardingUser.setId(id);
      onboardingUser.setEmail(email);

      College? userCollege = await getCollegeByEmail(email);
      bool hasCollegeEmail = userCollege != null;

      if (hasCollegeEmail) {
        await setCollegeEmail(email, userCollege);
      }
    }

    ref.read(appStateProvider.notifier).setAttemptAutoOnboard();

    if (kDebugMode) {
      print('OnboardingService.init() took ${DateTime
          .now()
          .difference(startTime)
          .inMilliseconds}ms');
    }
  }

  Future<void> setCollegeEmail(String email, College? college) async {
    DateTime startTime = DateTime.now();

    final onboardingUser = ref.read(onboardingUserProvider.notifier);

    onboardingUser.setCollegeEmail(email);
    onboardingUser.setCollege(college);

    final (String username, String avatar) = await generateProfile();

    onboardingUser.setAnonymousUsername(username);
    onboardingUser.setAnonymousProfileImage(avatar);

    await addUserToCollege();
    onboardingUser.setIsCollegeEmailVerified(true);

    if (kDebugMode) {
      print('OnboardingService.setCollegeEmail() took ${DateTime
          .now()
          .difference(startTime)
          .inMilliseconds}ms');
    }
  }

  Future<College?> getCollegeByEmail(String email) async {
    DateTime startTime = DateTime.now();

    final apiService = ref.read(apiServiceProvider);
    final response = await apiService.sendGetRequest(endpoint: 'colleges/college/byEmail?email=$email');

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw Exception('Error(getCollegeByEmail): Server responded with ${response.statusCode}.'
          ' Failed to get college by email');
    }

    if (kDebugMode) {
      print('OnboardingService.getCollegeEmail() took ${DateTime
          .now()
          .difference(startTime)
          .inMilliseconds}ms');
    }

    return response.body.isEmpty ? null : College.fromJson(jsonDecode(response.body));
  }

  Future<void> addUserToCollege() async {
    DateTime startTime = DateTime.now();

    final onboardingUser = ref.read(onboardingUserProvider);
    final currentUser = ref.read(currentUserProvider);

    // don't add user to college if they are already in it because this is a costly api call
    if (currentUser.idToken!.groups.contains(onboardingUser.college!.id.split(':')[1])) {
      if (kDebugMode) {
        print('OnboardingService.addUserToCollege() took ${DateTime
            .now()
            .difference(startTime)
            .inMilliseconds}ms (skipped)');
      }

      return;
    }

    final response = await ref
        .read(apiServiceProvider)
        .sendPostRequest(endpoint: 'user/${onboardingUser.id!}/addToCollege/${onboardingUser.college!.id}');

    await ref.read(authServiceProvider).getAuthTokens(forceRefresh: true);


    if (response.statusCode != 200) {
      throw Exception('Error(addUserToCollege): Server responded with ${response.statusCode}.'
          ' Failed to add user to college');
    }

    if (kDebugMode) {
      print('OnboardingService.addUserToCollege() took ${DateTime
          .now()
          .difference(startTime)
          .inMilliseconds}ms');
    }
  }

  Future<(String, String)> generateProfile() async {
    DateTime startTime = DateTime.now();

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
        if (kDebugMode) {
          print('OnboardingService.generateProfile() took ${DateTime
              .now()
              .difference(startTime)
              .inMilliseconds}ms');
        }
        return (username, avatar);
      default:
        throw Exception('Error(generateProfile): Server responded with ${response.statusCode}.'
            ' Failed to generate profile');
    }
  }

  Future<void> onboardUser() async {
    final onboardingUser = ref.read(onboardingUserProvider);

    try {
      final response = await ref.read(apiServiceProvider).sendPostRequest(
        endpoint: 'user/onboard',
        headers: {'collegeId': onboardingUser.college!.id},
        body: jsonEncode(onboardingUser.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Error(onboardUser): Server responded with ${response.statusCode}.'
            ' Failed to onboard user');
      }
    } catch (e) {
      rethrow;
    }
  }
}
