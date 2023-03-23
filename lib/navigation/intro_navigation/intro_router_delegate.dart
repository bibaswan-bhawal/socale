import 'package:flutter/material.dart';
import 'package:socale/navigation/intro_navigation/intro_route_path.dart';
import 'package:socale/navigation/intro_navigation/pages/intro_page.dart';

class IntroRouterDelegate extends RouterDelegate<IntroRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<IntroRoutePath> {
  final int maxPages = 3;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  int currentPage = 0;

  IntroRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  void nextPage() {
    currentPage = (currentPage + 1).clamp(0, maxPages);
    notifyListeners();
  }

  void previousPage() {
    currentPage = (currentPage - 1).clamp(0, maxPages);
    notifyListeners();
  }

  List<Page> buildPages() {
    final List<Page> pages = [];

    for (int i = 0; i <= currentPage; i++) {
      switch (i) {
        case 0:
          pages.add(IntroPage.first());
        case 1:
          pages.add(IntroPage.second());
        case 2:
          pages.add(IntroPage.third());
        default:
      }
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: buildPages(),
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        previousPage();
        return true;
      },
    );
  }

  @override
  IntroRoutePath get currentConfiguration {
    return IntroRoutePath();
  }

  @override
  Future<void> setNewRoutePath(IntroRoutePath configuration) async {
    return;
  }
}
