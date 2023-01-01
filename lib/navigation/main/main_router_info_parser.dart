import 'package:flutter/cupertino.dart';
import 'package:socale/navigation/auth/auth_route_path.dart';
import 'package:socale/navigation/auth/auth_router_info_parser.dart';
import 'package:socale/navigation/main/main_route_path.dart';
import 'package:socale/providers/state_notifiers/app_state.dart';

class MainRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final authRoutePath = AuthRouteInformationParser.parseRouteInformation(routeInformation);
    if (authRoutePath == null) return MainRoutePath.splashScreen();
    return authRoutePath;
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    if (configuration is AuthRoutePath) {
      return AuthRouteInformationParser.restoreRouteInformation(configuration);
    }

    if (configuration is MainRoutePath) {
      AppState state = configuration.appState;

      if (state.isInitialized() && state.isLoggedIn) {
        return RouteInformation(location: '/app');
      }
    }

    return null;
  }
}
