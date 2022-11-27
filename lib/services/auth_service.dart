import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class AuthService {
  static Future<void> signUpUser(String email, String password) async {
    try {
      final userAttributes = <CognitoUserAttributeKey, String>{CognitoUserAttributeKey.email: email};

      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: CognitoSignUpOptions(userAttributes: userAttributes),
      );

      print("is signup complete: ${result.isSignUpComplete}");
    } on UsernameExistsException catch (_) {
      print("User already Exists sign them in");
    } on AuthException catch (e) {
      safePrint("[AUTH SERVICE]: ${e.message}");
    }
  }

  Future<void> confirmUser(String email, String password) async {
    // confirm user verified
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
}
