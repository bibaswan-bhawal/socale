import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socale/types/auth/auth_result.dart';

class AuthService {
  static autoLoginUser() async {
    try {
      final result = await Amplify.Auth.fetchAuthSession();

      if (result.isSignedIn) return AuthFlowResult.success;

      return AuthFlowResult.notAuthorized;
    } on AuthException catch (_) {
      return AuthFlowResult.genericError;
    }
  }

  static signUpUser(String email, String password) async {
    try {
      await Amplify.Auth.signUp(username: email, password: password);
      return AuthFlowResult.unverified;
    } on UsernameExistsException catch (_) {
      return await signInUser(email, password);
    } on AuthException catch (_) {
      return AuthFlowResult.genericError;
    }
  }

  static signInUser(String email, String password) async {
    try {
      final result = await Amplify.Auth.signIn(username: email, password: password);

      if (result.nextStep.signInStep == 'CONFIRM_SIGN_UP') {
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

  static getAuthTokens() async {
    CognitoAuthSession authSession = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
    final authTokens = authSession.userPoolTokensResult.value;

    JsonWebToken idToken = authTokens.idToken;
    JsonWebToken accessToken = authTokens.accessToken;
    String refreshToken = authTokens.refreshToken;

    return (idToken, accessToken, refreshToken);
  }

  static sendResetPasswordCode(String email) async {
    try {
      final result = await Amplify.Auth.resetPassword(username: email);
      return result.isPasswordReset;
    } on AmplifyException catch (e) {
      safePrint(e);
    }

    return false;
  }

  static resendVerifyLink(String email) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: email);
      return true;
    } on LimitExceededException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  static confirmResetPassword(String email, String newPassword, String code) async {
    await Amplify.Auth.confirmResetPassword(
        username: email, newPassword: newPassword, confirmationCode: code);
  }

  static signOutUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Amplify.Auth.signOut();
      await prefs.setBool('isSignedIn', true);
      return true;
    } on AuthException catch (_) {
      return false;
    }
  }
}
