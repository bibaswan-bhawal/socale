import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class AuthRepository {
  Future<List<AuthUserAttribute>?> fetchCurrentUserAttributes() async {
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      return result;
    } on AuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<bool> signInWithSocialWebUI(AuthProvider provider) async {
    try {
      final result = await Amplify.Auth.signInWithWebUI(provider: provider);
      return result.isSignedIn;
    } on AmplifyException catch (e) {
      return false;
    }
  }

  Future<bool> signUpWithSocialWebUI(AuthProvider provider) async {
    try {
      final result = await Amplify.Auth.signInWithWebUI(provider: provider);
      return result.isSignedIn;
    } on AmplifyException catch (e) {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email.trim(),
        password: password.trim(),
      );
      return result.isSignedIn;
    } catch (e) {
      return false;
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

      return result.isSignUpComplete;
    } on UsernameExistsException catch (_) {
      return false;
    } on AuthException catch (e) {
      print(e.message);
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
