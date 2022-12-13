import 'package:flutter/cupertino.dart';
import 'package:socale/navigation/auth/auth_route_path.dart';
import 'package:socale/types/auth/auth_action.dart';
import 'package:socale/types/auth/auth_login_action.dart';

class AuthRouteInformationParser extends RouteInformationParser<AuthRoutePath> {
  @override
  Future<AuthRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isEmpty) {
      return AuthRoutePath.getStarted();
    }

    if (uri.pathSegments.length == 1) {
      switch (uri.pathSegments[0]) {
        case 'login':
          return AuthRoutePath.signIn();
        case 'register':
          return AuthRoutePath.signUp();
        case 'reset_password':
          return AuthRoutePath.forgotPassword();
        case 'verify':
          return AuthRoutePath.verifyEmail();
      }
    }

    return AuthRoutePath.getStarted();
  }

  @override
  RouteInformation restoreRouteInformation(AuthRoutePath configuration) {
    if (configuration.authLoginAction == AuthLoginAction.forgotPassword) {
      return RouteInformation(location: '/reset_password');
    } else {
      if (configuration.authAction == AuthAction.noAction) {
        return RouteInformation(location: '/');
      }
      if (configuration.authAction == AuthAction.signIn) {
        return RouteInformation(location: '/login');
      }
      if (configuration.authAction == AuthAction.signUp) {
        return RouteInformation(location: '/register');
      }
    }

    return RouteInformation(location: '/');
  }
}
