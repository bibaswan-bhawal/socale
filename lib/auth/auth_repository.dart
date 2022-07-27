import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:get/get.dart';

class AuthRepository {
  Future<void> signInWithSocialWebUI(AuthProvider provider) async {
    try {
      final result = await Amplify.Auth.signInWithWebUI(provider: provider);
      if (result.isSignedIn) {
        // USER IS SIGNED IN
      }
    } on AmplifyException catch (e) {
      print(e.message);
    }
  }

  Future<void> signUpWithSocialWebUI(AuthProvider provider) async {
    try {
      final result = await Amplify.Auth.signInWithWebUI(provider: provider);
      if (result.isSignedIn) {
        Get.offAllNamed('/email_verification');
      }
    } on AmplifyException catch (e) {
      print(e.message);
    }
  }

  Future<String?> _getUserIdFromAttributes() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final userId = attributes
          .firstWhere((element) => element.userAttributeKey == 'sub')
          .value;

      print(userId);
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email.trim(),
        password: password.trim(),
      );
      return result.isSignedIn ? (await _getUserIdFromAttributes()) : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signup(String email, String password) async {
    final userAttributes = <CognitoUserAttributeKey, String>{
      CognitoUserAttributeKey.email: email,
    };

    try {
      final result = await Amplify.Auth.signUp(
        username: email.trim(),
        password: password.trim(),
        options: CognitoSignUpOptions(userAttributes: userAttributes),
      );

      print("Is sign up complete: " + result.isSignUpComplete.toString());
      return result.isSignUpComplete;
    } on UsernameExistsException catch (_, e) {
      print("User name exists");
      return false;
    }
  }

  Future<void> signOutCurrentUser() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      print(e.message);
    }
  }
}
