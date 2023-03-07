import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/backgrounds/light_background.dart';
import 'package:socale/navigation/main_navigation/main_route_path.dart';
import 'package:socale/navigation/main_navigation/pages/main_pages.dart';
import 'package:socale/providers/state_providers.dart';

class MainRouterDelegate extends RouterDelegate<AppRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  AutoDisposeChangeNotifierProviderRef ref;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  MainRouterDelegate(this.ref) : navigatorKey = GlobalKey<NavigatorState>();

  void updateDelegate(_, __) => notifyListeners();

  List<Page> buildPages() {
    final List<Page> pages = [];

    final appState = ref.read(appStateProvider);

    if (appState.isInitialized) {
      if (!appState.isLoggedIn) {
        pages.add(const AuthPage());
        return pages;
      }

      if (!appState.isOnboarded) {
        pages.add(const OnboardingPage());
        return pages;
      }

      pages.add(const MaterialPage(child: Center(child: Text('Home')))); // TODO: Add Home Page
      return pages;
    }

    pages.add(const SplashPage());
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(appStateProvider, updateDelegate);

    return Stack(
      children: [
        const LightBackground(),
        Navigator(
          key: navigatorKey,
          pages: buildPages(),
          onPopPage: (route, result) => route.didPop(result),
        ),
      ],
    );
  }

  // new state update route path
  @override
  AppRoutePath get currentConfiguration {
    return MainRoutePath.splashScreen();
  }

  // new route path requested update state
  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {}
}
