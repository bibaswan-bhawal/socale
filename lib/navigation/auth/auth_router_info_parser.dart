import 'package:flutter/cupertino.dart';
import 'package:socale/navigation/auth/auth_route_path.dart';
import 'package:socale/providers/state_notifiers/auth_state.dart';
import 'package:socale/types/auth/auth_action.dart';

class AuthRouteInformationParser {
  static AuthRoutePath? parseRouteInformation(RouteInformation routeInformation) {
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
        case 'reset-password':
          return AuthRoutePath.forgotPassword();
        default:
          return AuthRoutePath.getStarted();
      }
    }

    return null;
  }

  static RouteInformation restoreRouteInformation(AuthRoutePath configuration) {
    AuthState state = configuration.appState;

    if (state.notVerified) return RouteInformation(location: '/verify');
    if (state.resetPassword) return RouteInformation(location: '/reset-password');

    switch (state.authAction) {
      case AuthAction.signIn:
        return RouteInformation(location: '/login');
      case AuthAction.signUp:
        return RouteInformation(location: '/register');
      default:
        return RouteInformation(location: '/get-started');
    }
  }
}
