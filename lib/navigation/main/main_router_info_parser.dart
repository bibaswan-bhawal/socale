import 'package:flutter/cupertino.dart';
import 'package:socale/navigation/main/main_route_path.dart';

class MainRouteInformationParser extends RouteInformationParser<MainRoutePath> {
  @override
  Future<MainRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    return MainRoutePath.getStartedScreen();
  }

  @override
  RouteInformation restoreRouteInformation(MainRoutePath configuration) {
    return RouteInformation(location: '/');
  }
}
