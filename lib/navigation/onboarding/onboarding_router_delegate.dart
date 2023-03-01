import 'package:flutter/cupertino.dart';
import 'package:socale/navigation/onboarding/onboarding_route_path.dart';

class OnboardingRouterDelegate extends RouterDelegate<OnboardingRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<OnboardingRoutePath> {
  @override
  GlobalKey<NavigatorState>? navigatorKey;

  List<Page> buildPageList() {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: buildPageList(),
      onPopPage: (route, result) {
        return route.didPop(result);
      },
    );
  }

  @override
  Future<void> setNewRoutePath(OnboardingRoutePath configuration) {
    throw UnimplementedError();
  }
}
