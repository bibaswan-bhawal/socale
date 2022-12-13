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
      }
    }

    return AuthRoutePath.getStarted();
  }

  @override
  RouteInformation restoreRouteInformation(AuthRoutePath configuration) {
    if (configuration.authLoginAction == AuthLoginAction.forgotPassword) {
      return RouteInformation(location: '/reset_password');
    } else {
      switch (configuration.authAction) {
        case AuthAction.noAction:
          return RouteInformation(location: '/');
        case AuthAction.signIn:
          return RouteInformation(location: '/login');
        case AuthAction.signUp:
          return RouteInformation(location: '/register');
        case AuthAction.verify:
          return RouteInformation(location: '/verify');
      }
    }
  }
}
