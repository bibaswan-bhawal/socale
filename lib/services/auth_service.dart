import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/types/auth/results/auth_change_password_result.dart';
import 'package:socale/types/auth/results/auth_reset_password_result.dart';
import 'package:socale/types/auth/results/auth_flow_result.dart';
import 'package:socale/types/auth/results/auth_verify_email_result.dart';

class AuthService {
  final ProviderRef ref;

  const AuthService(this.ref);

  Future<void> loginSuccessful(BuildContext context) async {
    final userId = (await Amplify.Auth.getCurrentUser()).userId;
    final email = (await Amplify.Auth.fetchUserAttributes())
        .firstWhere((element) => element.userAttributeKey == CognitoUserAttributeKey.email)
        .value;

    final currentUser = ref.read(currentUserProvider.notifier);

    await getAuthTokens();

    currentUser.setId(userId);
    currentUser.setEmail(email);

    if (context.mounted) await ref.read(onboardingServiceProvider).init(context); // check if onboarded
    ref.read(appStateProvider.notifier).setLoggedIn(); // logged in
  }

  Future<AuthFlowResult> autoLoginUser() async {
    try {
      final result = await Amplify.Auth.fetchAuthSession();

      if (result.isSignedIn) return AuthFlowResult.success;

      return AuthFlowResult.notAuthorized;
    } on AuthException {
      return AuthFlowResult.genericError;
    } catch (e) {
      if (kDebugMode) print(e);
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
    } catch (e) {
      if (kDebugMode) print(e);
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
    // should force refresh token or not
    final options = forceRefresh ? FetchAuthSessionOptions(forceRefresh: forceRefresh) : null;

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

  Future<AuthResetPasswordResult> sendResetPasswordCode(String email) async {
    try {
      await Amplify.Auth.resetPassword(username: email);
      return AuthResetPasswordResult.codeDeliverySuccessful;
    } on UserNotFoundException {
      return AuthResetPasswordResult.userNotFound;
    } on LimitExceededException {
      return AuthResetPasswordResult.tooManyRequests;
    } on TooManyRequestsException {
      return AuthResetPasswordResult.tooManyRequests;
    } on CodeDeliveryFailureException {
      return AuthResetPasswordResult.codeDeliveryFailure;
    } catch (e) {
      if (kDebugMode) print(e);
      return AuthResetPasswordResult.unknownError;
    }
  }

  Future<AuthResetPasswordResult> confirmResetPassword({
    required String email,
    required String newPassword,
    required String code,
  }) async {
    try {
      ResetPasswordResult result = await Amplify.Auth.confirmResetPassword(
        username: email,
        newPassword: newPassword,
        confirmationCode: code,
      );
      if (result.isPasswordReset) {
        return AuthResetPasswordResult.success;
      } else {
        return AuthResetPasswordResult.unknownError;
      }
    } on CodeMismatchException {
      return AuthResetPasswordResult.codeMismatch;
    } on ExpiredCodeException {
      return AuthResetPasswordResult.expiredCode;
    } on TooManyRequestsException {
      return AuthResetPasswordResult.tooManyRequests;
    } catch (e) {
      if (kDebugMode) print(e);
      return AuthResetPasswordResult.unknownError;
    }
  }

  Future<AuthChangePasswordResult> changePassword({
    required String currentPassword,
    required String newPassword,
    String? email,
  }) async {
    AuthChangePasswordResult response;

    try {
      if (email != null) {
        await Amplify.Auth.signIn(username: email, password: currentPassword);
      }

      await Amplify.Auth.updatePassword(newPassword: newPassword, oldPassword: currentPassword);

      response = AuthChangePasswordResult.success;
    } on AuthNotAuthorizedException {
      response = AuthChangePasswordResult.notAuthorized;
    } on UserNotFoundException {
      response = AuthChangePasswordResult.userNotFound;
    } on InvalidPasswordException {
      response = AuthChangePasswordResult.invalidPassword;
    } on LimitExceededException {
      response = AuthChangePasswordResult.timeout;
    } on TooManyRequestsException {
      response = AuthChangePasswordResult.tooManyRequests;
    } catch (e) {
      if (kDebugMode) print(e);
      response = AuthChangePasswordResult.unknownError;
    }

    try {
      if (email != null) {
        await Amplify.Auth.signOut(options: const SignOutOptions(globalSignOut: true));
      }
    } catch (e) {
      if (kDebugMode) print(e);
      response = AuthChangePasswordResult.unknownError;
    }

    return response;
  }

  Future<AuthVerifyEmailResult> resendVerifyLink(String email) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: email);
      return AuthVerifyEmailResult.codeDeliverySuccessful;
    } on CodeDeliveryFailureException {
      return AuthVerifyEmailResult.codeDeliveryFailure;
    } on LimitExceededException {
      return AuthVerifyEmailResult.limitExceeded;
    } on TooManyRequestsException {
      return AuthVerifyEmailResult.limitExceeded;
    } on InvalidParameterException {
      return AuthVerifyEmailResult.userAlreadyConfirmed;
    } catch (e) {
      if (kDebugMode) print(e);
      return AuthVerifyEmailResult.unknownError;
    }
  }

  Future<bool> signOutUser() async {
    try {
      await Amplify.Auth.signOut();
      ref.read(appStateProvider.notifier).setLoggedOut();
      return true;
    } on AuthException {
      return false;
    }
  }
}
