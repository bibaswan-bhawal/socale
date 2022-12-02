import 'package:flutter/cupertino.dart';
import 'package:socale/navigation/auth/auth_route_path.dart';

class AuthRouteInformationParser extends RouteInformationParser<AuthRoutePath> {
  @override
  Future<AuthRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    return AuthRoutePath.getStarted();
  }
}
