import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class AuthRepository {
  Future<String?> _getUserIdFromAttributes() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final userId = attributes
          .firstWhere((element) => element.userAttributeKey == 'email')
          .value;

      print(userId);
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> attemptAutoLogin() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();

      return session.isSignedIn ? (await _getUserIdFromAttributes()) : null;
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

  Future<bool?> signup(String email, String password) async {
    print("signup called");
    final userAttributes = <CognitoUserAttributeKey, String>{
      CognitoUserAttributeKey.email: email,
    };

    final result = await Amplify.Auth.signUp(
      username: email.trim(),
      password: password.trim(),
      options: CognitoSignUpOptions(userAttributes: userAttributes),
    );

    print(result.isSignUpComplete);
    return result.isSignUpComplete;
  }
}
