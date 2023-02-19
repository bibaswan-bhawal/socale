import 'package:flutter/cupertino.dart';
import 'package:socale/models/state/app_state.dart';
import 'package:socale/navigation/auth/auth_route_path.dart';
import 'package:socale/navigation/auth/auth_router_info_parser.dart';
import 'package:socale/navigation/main/main_route_path.dart';

class MainRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  // new route path provided update state
  @override
  Future<AppRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    if (routeInformation.location == null) return MainRoutePath.splashScreen();
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isEmpty) {
      return MainRoutePath.splashScreen();
    }

    final authRoutePath = AuthRouteInformationParser.parseRouteInformation(routeInformation);
    if (authRoutePath == null) return MainRoutePath.splashScreen();
    return authRoutePath;
  }

  // new state provided update route path
  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    if (configuration is AuthRoutePath) {
      return AuthRouteInformationParser.restoreRouteInformation(configuration);
    }

    if (configuration is MainRoutePath) {
      AppState state = configuration.appState;

      if (state.isInitialized && state.isLoggedIn) {
        return const RouteInformation(location: '/app');
      }
    }

    return const RouteInformation(location: '/');
  }
}
