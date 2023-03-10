import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/types/auth/auth_reset_password.dart';
import 'package:socale/types/auth/auth_result.dart';

class AuthService {
  final ProviderRef ref;

  const AuthService(this.ref);

  Future<void> loginSuccessful(email) async {
    final currentUser = ref.read(currentUserProvider.notifier);

    await getAuthTokens();

    currentUser.setEmail(email);

    await ref.read(onboardingServiceProvider).init(); // check if onboarded
    ref.read(appStateProvider.notifier).setLoggedIn(); // logged in
  }

  Future<AuthFlowResult> autoLoginUser() async {
    try {
      final result = await Amplify.Auth.fetchAuthSession();
      if (result.isSignedIn) return AuthFlowResult.success;

      return AuthFlowResult.notAuthorized;
    } on AuthException {
      return AuthFlowResult.genericError;
    }
  }

  Future<AuthFlowResult> signUpUser(String email, String password) async {
    try {
      await Amplify.Auth.signUp(username: email, password: password);
      return AuthFlowResult.unverified;
    } on UsernameExistsException catch (_) {
      return await signInUser(email, password);
    } on AuthException {
      return AuthFlowResult.genericError;
    }
  }

  Future<AuthFlowResult> signInUser(String email, String password) async {
    try {
      final result = await Amplify.Auth.signIn(username: email, password: password);
      if (result.nextStep.signInStep == AuthSignInStep.confirmSignUp) return AuthFlowResult.unverified;
      return AuthFlowResult.success;
    } on AuthNotAuthorizedException {
      return AuthFlowResult.notAuthorized;
    } on UserNotFoundException {
      return AuthFlowResult.userNotFound;
    } on AuthException {
      return AuthFlowResult.genericError;
    }
  }

  Future<(JsonWebToken, JsonWebToken, String)> getAuthTokens({bool forceRefresh = false}) async {
    final options = forceRefresh ? CognitoSessionOptions(forceRefresh: forceRefresh) : null;
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

  Future<AuthResetPassword> sendResetPasswordCode(String email) async {
    try {
      ResetPasswordResult result = await Amplify.Auth.resetPassword(username: email);
      return AuthResetPassword.codeDeliverySuccessful;
    } on LimitExceededException {
      return AuthResetPassword.tooManyRequests;
    } on TooManyRequestsException {
      return AuthResetPassword.tooManyRequests;
    } on CodeDeliveryFailureException {
      return AuthResetPassword.codeDeliveryFailure;
    } catch (e) {
      if (kDebugMode) print(e);
      return AuthResetPassword.unknownError;
    }
  }

  Future<AuthResetPassword> confirmResetPassword(String email, String newPassword, String code) async {
    try {
      ResetPasswordResult result = await Amplify.Auth.confirmResetPassword(
        username: email, newPassword: newPassword, confirmationCode: code,);
      if (result.isPasswordReset) {
        return AuthResetPassword.success;
      } else {
        return AuthResetPassword.unknownError;
      }
    } on CodeMismatchException {
      return AuthResetPassword.codeMismatch;
    } on ExpiredCodeException {
      return AuthResetPassword.expiredCode;
    } on TooManyRequestsException {
      return AuthResetPassword.tooManyRequests;
    } catch (e) {
      if (kDebugMode) print(e);
      return AuthResetPassword.unknownError;
    }
  }

  Future<void> resendVerifyLink(String email) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: email);
      return;
    } catch (e) {
      if (kDebugMode) print(e);
    }
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
