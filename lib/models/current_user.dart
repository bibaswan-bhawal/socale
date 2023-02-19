import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:socale/models/user.dart';

class CurrentUser extends User {
  JsonWebToken? _idToken;
  JsonWebToken? _accessToken;
  String? _refreshToken;

  CurrentUser();

  JsonWebToken get idToken => _idToken!;

  JsonWebToken get accessToken => _accessToken!;

  String get refreshToken => _refreshToken!;

  setTokens({idToken, accessToken, refreshToken}) {
    _idToken = idToken;
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  @override
  String toString() {
    return 'Id Token: ${_idToken?.raw}\nAccess Token: ${_accessToken?.raw}\nRefreshToken: $_refreshToken';
  }
}
