import 'package:amplify_auth_cognito/amplify_auth_cognito.dart' hide AuthState;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:socale/state_machines/state_values/auth_state_values.dart';

class AuthService {
  static Future<AuthStateValue> autoLoginUser() async {
    AuthSession result = await Amplify.Auth.fetchAuthSession();
    if (result.isSignedIn) {
      return AuthStateValue.signedIn;
    }
    return AuthStateValue.signedOut;
  }

  static Future<AuthStateValue> signUpUser(String email, String password) async {
    try {
      await Amplify.Auth.signUp(username: email, password: password);
      return AuthStateValue.unverified;
    } on UsernameExistsException catch (_) {
      return await signInUser(email, password);
    } on AuthException catch (_) {
      return AuthStateValue.error;
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

  static Future<AuthStateValue> signInUser(String email, String password) async {
    try {
      final result = await Amplify.Auth.signIn(username: email, password: password);

      if (result.nextStep!.signInStep == "CONFIRM_SIGN_UP") {
        return AuthStateValue.unverified;
      }

      return AuthStateValue.signedIn;
    } on NotAuthorizedException catch (_) {
      return AuthStateValue.notAuthorized;
    } on UserNotFoundException catch (_) {
      return AuthStateValue.userDoesNotExist;
    } on AuthException catch (_) {
      return AuthStateValue.error;
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

  static Future<AuthStateValue> signOutUser() async {
    try {
      await Amplify.Auth.signOut();
      return AuthStateValue.signedOut;
    } on AuthException catch (e) {
      print(e.message);
      return AuthStateValue.error;
    }
  }
}
