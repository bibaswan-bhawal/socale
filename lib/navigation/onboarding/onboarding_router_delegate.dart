import 'package:flutter/cupertino.dart';
import 'package:socale/models/onboarding_user.dart';
import 'package:socale/navigation/onboarding/onboarding_route_path.dart';
import 'package:socale/navigation/onboarding/pages/basic_info_page.dart';
import 'package:socale/navigation/onboarding/pages/intro_page_one.dart';
import 'package:socale/navigation/onboarding/pages/intro_page_three.dart';
import 'package:socale/navigation/onboarding/pages/intro_page_two.dart';

class OnboardingRouterDelegate extends RouterDelegate<OnboardingRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<OnboardingRoutePath> {
  @override
  GlobalKey<NavigatorState>? navigatorKey;

  final HeroController heroController = HeroController();
  final OnboardingUser onboardingUser = OnboardingUser();

  late List<Page> pages;

  int currentPage = 0;

  OnboardingRouterDelegate() {
    navigatorKey = GlobalKey<NavigatorState>();

    pages = [
      const IntroPageOne(),
      const IntroPageTwo(),
      const IntroPageThree(),
      const BasicInfoPage(),
    ];
  }

  void nextPage() {
    if (onboardingUser.currentStep == pages.length - 1) return;
    onboardingUser.nextStep();
    notifyListeners();
  }

  void previousPage() {
    if (onboardingUser.currentStep == 0) return;
    onboardingUser.previousStep();
    notifyListeners();
  }

  List<Page> buildPageList() {
    List<Page> pagesToAdd = [];

    for (int page = 0; page <= onboardingUser.currentStep; page++) {
      pagesToAdd.add(pages[page]);
    }

    return pagesToAdd;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      observers: [heroController],
      pages: buildPageList(),
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;

        onboardingUser.previousStep();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(OnboardingRoutePath configuration) async {
    return;
  }
}
