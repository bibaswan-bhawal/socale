import 'package:amplify_auth_cognito/amplify_auth_cognito.dart' hide AuthState;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:socale/state_machines/states/auth_state.dart';

class AuthService {
  static Future<AuthState> autoLoginUser() async {
    AuthSession result = await Amplify.Auth.fetchAuthSession();
    if (result.isSignedIn) {
      return AuthState.signedIn;
    }
    return AuthState.signedOut;
  }

  static Future<AuthState> signUpUser(String email, String password) async {
    try {
      await Amplify.Auth.signUp(username: email, password: password);
      return AuthState.unverified;
    } on UsernameExistsException catch (_) {
      return await signInUser(email, password);
    } on AuthException catch (_) {
      return AuthState.error;
    }
  }

  static Future<bool> resendVerifyLink(String email) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: email);
      return true;
    } on LimitExceededException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<AuthState> signInUser(String email, String password) async {
    try {
      final result = await Amplify.Auth.signIn(username: email, password: password);

      if (result.nextStep!.signInStep == "CONFIRM_SIGN_UP") {
        return AuthState.unverified;
      }

      return AuthState.signedIn;
    } on NotAuthorizedException catch (_) {
      return AuthState.notAuthorized;
    } on UserNotFoundException catch (_) {
      return AuthState.userDoesNotExist;
    } on AuthException catch (_) {
      return AuthState.error;
    }
  }

  static Future<bool> sendResetPasswordCode(String email) async {
    try {
      final result = await Amplify.Auth.resetPassword(username: email);
      return result.isPasswordReset;
    } on AmplifyException catch (e) {
      safePrint(e);
    }

    return false;
  }

  static Future<void> confirmResetPassword(String email, String newPassword, String code) async {
    await Amplify.Auth.confirmResetPassword(username: email, newPassword: newPassword, confirmationCode: code);
  }

  static Future<AuthState> signOutUser() async {
    try {
      await Amplify.Auth.signOut();
      return AuthState.signedOut;
    } on AuthException catch (e) {
      print(e.message);
      return AuthState.error;
    }
  }
}
