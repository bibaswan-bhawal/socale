import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/main/main_route_path.dart';
import 'package:socale/screens/screen_splash.dart';

class MainRouterDelegate extends RouterDelegate<MainRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<MainRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final WidgetRef ref;

  MainRouterDelegate(WidgetRef widgetRef)
      : ref = widgetRef,
        navigatorKey = GlobalKey<NavigatorState>();

  @override
  MainRoutePath get currentConfiguration {
    return MainRoutePath.splashScreen();
  }

  @override
  Future<void> setNewRoutePath(MainRoutePath configuration) async {}

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(child: SplashScreen()),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        return false;
      },
    );
  }
}
