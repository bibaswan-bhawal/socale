import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:socale/screens/onboarding/providers/academic_data_provider.dart';
import 'package:socale/screens/onboarding/providers/basic_data_provider.dart';
import 'package:socale/screens/onboarding/providers/personality_data_provider.dart';
import 'package:socale/services/onboarding_service.dart';

import '../screens/onboarding/providers/avatar_data_provider.dart';
import '../screens/onboarding/providers/describe_friend_data_provider.dart';

class AuthService {
  void startAuthStreamListener() {}

  Future<bool> signInWithSocialWebUI(AuthProvider provider) async {
    try {
      final result = await Amplify.Auth.signInWithWebUI(provider: provider);
      return result.isSignedIn;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updatePassword(String currentPassword, String newPassword) async {
    try {
      await Amplify.Auth.updatePassword(
        newPassword: newPassword,
        oldPassword: currentPassword,
      );
    } on NotAuthorizedException catch (e) {
      return false;
    } on AmplifyException catch (e) {
      print(e);
      return false;
    }

    return false;
  }

  Future<bool> signUpWithSocialWebUI(AuthProvider provider) async {
    try {
      final result = await Amplify.Auth.signInWithWebUI(provider: provider);
      return result.isSignedIn;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<SignInResult> signIn(String email, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email.trim(),
        password: password.trim(),
      );

      return result;
    } on AuthException catch (_) {
      rethrow;
    }
  }

  Future<SignUpResult> signup(String email, String password) async {
    final userAttributes = <CognitoUserAttributeKey, String>{
      CognitoUserAttributeKey.email: email,
    };

    try {
      final result = await Amplify.Auth.signUp(
        username: email.trim(),
        password: password.trim(),
        options: CognitoSignUpOptions(userAttributes: userAttributes),
      );

      return result;
    } on UsernameExistsException catch (_) {
      rethrow;
    } on AuthException catch (e) {
      throw (e.message);
    }
  }

  Future<void> signOutCurrentUser(WidgetRef ref) async {
    try {
      await Amplify.Auth.signOut(
        options: const SignOutOptions(globalSignOut: true),
      );
      Amplify.DataStore.clear();
      Get.offAllNamed('/auth');
      onboardingService.clearAll();
      ref.read(academicDataProvider.notifier).clearData();
      ref.read(avatarDataProvider.notifier).clearData();
      ref.read(basicDataProvider.notifier).clearData();
      ref.read(describeFriendDataProvider.notifier).clearData();
      ref.read(personalityDataProvider.notifier).clearData();
    } on SignedOutException catch (_) {
      throw ("Error could not sign out");
    } on AuthException catch (_) {
      return;
    } on NotAuthorizedException {
      return;
    }
  }
}

final authService = AuthService();
