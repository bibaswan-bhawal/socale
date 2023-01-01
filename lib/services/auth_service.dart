import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:socale/types/auth/auth_result.dart';

class AuthService {
  static Future<AuthResult> autoLoginUser() async {
    try {
      AuthSession result = await Amplify.Auth.fetchAuthSession();

      if (result.isSignedIn) {
        return AuthResult.success;
      }

      return AuthResult.notAuthorized;
    } on AuthException catch (e) {
      return AuthResult.genericError;
    }
  }

  static Future<AuthResult> signUpUser(String email, String password) async {
    try {
      await Amplify.Auth.signUp(username: email, password: password);
      return AuthResult.unverified;
    } on UsernameExistsException catch (_) {
      return await signInUser(email, password);
    } on AuthException catch (_) {
      return AuthResult.genericError;
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

  static Future<AuthResult> signInUser(String email, String password) async {
    try {
      final result = await Amplify.Auth.signIn(username: email, password: password);

      if (result.nextStep!.signInStep == "CONFIRM_SIGN_UP") {
        return AuthResult.unverified;
      }

      return AuthResult.success;
    } on NotAuthorizedException catch (_) {
      return AuthResult.notAuthorized;
    } on UserNotFoundException catch (_) {
      return AuthResult.userNotFound;
    } on AuthException catch (_) {
      return AuthResult.genericError;
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

  static Future<bool> signOutUser() async {
    try {
      await Amplify.Auth.signOut();
      return true;
    } on AuthException catch (e) {
      print(e.message);
      return false;
    }
  }
}
