import 'package:flutter/cupertino.dart';
import 'package:socale/models/auth_state.dart';
import 'package:socale/navigation/auth/auth_route_path.dart';
import 'package:socale/types/auth/auth_step.dart';

class AuthRouteInformationParser {
  // new route path requested update state
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

  // new state update route path
  static RouteInformation restoreRouteInformation(AuthRoutePath configuration) {
    AuthState state = configuration.appState;

    switch (state.step) {
      case AuthStep.login:
        return const RouteInformation(location: '/login');
      case AuthStep.forgotPassword:
        return const RouteInformation(location: '/reset-password');
      case AuthStep.register:
        return const RouteInformation(location: '/register');
      case AuthStep.verifyEmail:
        return const RouteInformation(location: '/verify');
      default:
        return const RouteInformation(location: '/get-started');
    }
  }
}
