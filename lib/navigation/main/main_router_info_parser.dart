import 'package:flutter/cupertino.dart';
import 'package:socale/navigation/main/main_route_path.dart';

class MainRouteInformationParser extends RouteInformationParser<MainRoutePath> {
  @override
  Future<MainRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isEmpty) {
      return MainRoutePath.app();
    }

    if (uri.pathSegments[0] != 'get_started') {
      return MainRoutePath.unknown();
    }

    return MainRoutePath.getStartedScreen();
  }

  @override
  RouteInformation? restoreRouteInformation(MainRoutePath configuration) {
    if (configuration.isUnknown) {
      return RouteInformation(location: '/404');
    }
    if (configuration.isHome) {
      return RouteInformation(location: '');
    }
    if (configuration.isGetStarted) {
      return RouteInformation(location: '/get_started');
    }

    return null;
  }
}
