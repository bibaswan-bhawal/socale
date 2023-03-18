import 'package:flutter/material.dart';
import 'package:socale/navigation/intro_navigation/intro_route_path.dart';

class IntroRouterInformationParser {
  static IntroRoutePath? parseRouteInformation(RouteInformation routeInformation) {
    return null;
  }

  static RouteInformation restoreRouteInformation(IntroRoutePath configuration) {
    return const RouteInformation(location: '/introduction');
  }
}
