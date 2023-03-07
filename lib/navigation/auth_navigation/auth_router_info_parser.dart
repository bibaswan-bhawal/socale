import 'package:flutter/cupertino.dart';
import 'package:socale/navigation/auth_navigation/auth_route_path.dart';

class AuthRouteInformationParser {
  // new route path requested update state
  static AuthRoutePath? parseRouteInformation(RouteInformation routeInformation) {
    return null;
  }

  // new state update route path
  static RouteInformation restoreRouteInformation(AuthRoutePath configuration) {
    return const RouteInformation(location: '/get-started');
  }
}
