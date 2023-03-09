import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/foundation.dart';
import 'package:socale/models/user/user.dart';

@immutable
class CurrentUser extends User {
  final JsonWebToken? _idToken;
  final JsonWebToken? _accessToken;
  final String? _refreshToken;

  const CurrentUser({
    super.email,
    super.firstName,
    super.lastName,
    JsonWebToken? idToken,
    JsonWebToken? accessToken,
    String? refreshToken,
  })  : _idToken = idToken,
        _accessToken = accessToken,
        _refreshToken = refreshToken;

  JsonWebToken get idToken => _idToken!;

  JsonWebToken get accessToken => _accessToken!;

  String get refreshToken => _refreshToken!;

  @override
  CurrentUser copyWith({
    String? email,
    String? firstName,
    String? lastName,
    JsonWebToken? idToken,
    JsonWebToken? accessToken,
    String? refreshToken,
  }) {
    return CurrentUser(
      email: email ?? super.email,
      firstName: firstName ?? super.firstName,
      lastName: lastName ?? super.lastName,
      idToken: idToken ?? _idToken,
      accessToken: accessToken ?? _accessToken,
      refreshToken: refreshToken ?? _refreshToken,
    );
  }

  @override
  String toString() {
    return '${super.toString()}\n';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentUser &&
          runtimeType == other.runtimeType &&
          super.email == other.email &&
          super.firstName == other.firstName &&
          super.lastName == other.lastName &&
          _idToken == other._idToken &&
          _accessToken == other._accessToken &&
          _refreshToken == other._refreshToken;

  @override
  int get hashCode =>
      super.email.hashCode ^
      super.firstName.hashCode ^
      super.lastName.hashCode ^
      _idToken.hashCode ^
      _accessToken.hashCode ^
      _refreshToken.hashCode;
}
