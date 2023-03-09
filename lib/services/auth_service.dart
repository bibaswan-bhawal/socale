import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/types/auth/auth_result.dart';

class AuthService {
  ProviderRef ref;

  AuthService(this.ref);

  loginSuccessful(email) async {
    final currentUser = ref.read(currentUserProvider.notifier);

    await getAuthTokens();

    currentUser.setEmail(email);

    await ref.read(onboardingServiceProvider).init(); // check if onboarded
    ref.read(appStateProvider.notifier).setLoggedIn(); // logged in
  }

  autoLoginUser() async {
    try {
      final result = await Amplify.Auth.fetchAuthSession();

      if (result.isSignedIn) return AuthFlowResult.success;

      return AuthFlowResult.notAuthorized;
    } on AuthException catch (_) {
      return AuthFlowResult.genericError;
    }
  }

  signUpUser(String email, String password) async {
    try {
      await Amplify.Auth.signUp(username: email, password: password);
      return AuthFlowResult.unverified;
    } on UsernameExistsException catch (_) {
      return await signInUser(email, password);
    } on AuthException catch (_) {
      return AuthFlowResult.genericError;
    }
  }

  signInUser(String email, String password) async {
    try {
      final result = await Amplify.Auth.signIn(username: email, password: password);

      if (result.nextStep.signInStep == AuthSignInStep.confirmSignUp) {
        return AuthFlowResult.unverified;
      }

      return AuthFlowResult.success;
    } on AuthNotAuthorizedException catch (_) {
      return AuthFlowResult.notAuthorized;
    } on UserNotFoundException catch (_) {
      return AuthFlowResult.userNotFound;
    } on AuthException catch (_) {
      return AuthFlowResult.genericError;
    }
  }

  Future<(JsonWebToken, JsonWebToken, String)> getAuthTokens({bool forceRefresh = false}) async {
    final options = forceRefresh? CognitoSessionOptions(forceRefresh: forceRefresh) : null;
    CognitoAuthSession authSession = await Amplify.Auth.fetchAuthSession(options: options) as CognitoAuthSession;

    final authTokens = authSession.userPoolTokensResult.value;

    JsonWebToken idToken = authTokens.idToken;
    JsonWebToken accessToken = authTokens.accessToken;
    String refreshToken = authTokens.refreshToken;

    ref.read(currentUserProvider.notifier).setTokens(
      idToken: idToken,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    return (idToken, accessToken, refreshToken);
  }

  Future<void> sendResetPasswordCode(String email) async {
      final result = await Amplify.Auth.resetPassword(username: email);
      if(result.isPasswordReset) return;

      throw Exception('Failed to send reset password code');
  }

  resendVerifyLink(String email) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: email);
      return true;
    } on LimitExceededException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  confirmResetPassword(String email, String newPassword, String code) async {
    await Amplify.Auth.confirmResetPassword(
        username: email, newPassword: newPassword, confirmationCode: code);
  }

  signOutUser() async {
    try {
      await Amplify.Auth.signOut();
      ref.read(appStateProvider.notifier).setLoggedOut();
      return true;
    } on AuthException catch (_) {
      return false;
    }
  }
}
