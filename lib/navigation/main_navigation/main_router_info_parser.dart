import 'package:flutter/material.dart';
import 'package:socale/navigation/main_navigation/main_route_path.dart';

class MainRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  // new route path provided update state
  @override
  Future<AppRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    return MainRoutePath.splashScreen();
  }

  // new state provided update route path
  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    return const RouteInformation(location: '/');
  }
}
