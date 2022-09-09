import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:get/get.dart';
import 'package:socale/services/onboarding_service.dart';

class AuthService {
  void startAuthStreamListener() {
    StreamSubscription<HubEvent> hubSubscription = Amplify.Hub.listen<dynamic, AuthHubEvent>(HubChannel.Auth, (hubEvent) {
      print(hubEvent.eventName);
    });
  }

  Future<bool> signInWithSocialWebUI(AuthProvider provider) async {
    try {
      final result = await Amplify.Auth.signInWithWebUI(provider: provider);
      return result.isSignedIn;
    } catch (e) {
      print(e);
      return false;
    }
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
    } on AuthException catch (e) {
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

  Future<void> signOutCurrentUser() async {
    try {
      final SignOutResult res = await Amplify.Auth.signOut(
        options: const SignOutOptions(globalSignOut: true),
      );

      Get.offAllNamed('/auth');
      onboardingService.clearAll();
    } on SignedOutException catch (e) {
      throw ("Error could not sign out");
    } on AuthException catch (e) {
      return;
    } on NotAuthorizedException {
      return;
    }
  }
}

final authService = AuthService();
