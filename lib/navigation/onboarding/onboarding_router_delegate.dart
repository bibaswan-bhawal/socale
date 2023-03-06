import 'package:flutter/cupertino.dart';
import 'package:socale/models/onboarding_user.dart';
import 'package:socale/navigation/onboarding/onboarding_route_path.dart';
import 'package:socale/navigation/onboarding/pages/academic_info_major_page.dart';
import 'package:socale/navigation/onboarding/pages/academic_info_minor_page.dart';
import 'package:socale/navigation/onboarding/pages/basic_info_page.dart';
import 'package:socale/navigation/onboarding/pages/intro_page_one.dart';
import 'package:socale/navigation/onboarding/pages/intro_page_three.dart';
import 'package:socale/navigation/onboarding/pages/intro_page_two.dart';
import 'package:socale/navigation/onboarding/pages/onboarding_page.dart';
import 'package:socale/screens/onboarding/onboarding_screen.dart';

class OnboardingRouterDelegate extends RouterDelegate<OnboardingRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<OnboardingRoutePath> {
  @override
  GlobalKey<NavigatorState>? navigatorKey;

  final HeroController heroController = HeroController();

  late List<OnboardingPage> pages = [
    const IntroPageOne(),
    const IntroPageTwo(),
    const IntroPageThree(),
    const BasicInfoPage(),
    const AcademicInfoMajorPage(),
    const AcademicInfoMinorPage(),
  ];

  int currentPage = 0;

  OnboardingRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  void nextPage() async {
    var screens = OnboardingScreen.allOnboardingScreens(navigatorKey!.currentContext!);
    OnboardingScreenState currentState = screens.last;

    if (!(await currentState.onNext())) return;

    currentPage = (currentPage + 1).clamp(0, pages.length - 1);
    notifyListeners();
  }

  void previousPage() async {
    var screens = OnboardingScreen.allOnboardingScreens(navigatorKey!.currentContext!);
    OnboardingScreenState currentState = screens.last;

    if (!(await currentState.onBack())) return;

    currentPage = (currentPage - 1).clamp(0, pages.length - 1);
    notifyListeners();
  }

  bool isLast() {
    return currentPage == pages.length - 1;
  }

  List<Page> buildPageList() {
    List<Page> pagesToAdd = [];

    for (int i = 0; i <= currentPage; i++) {
      pagesToAdd.add(pages[i]);
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

        previousPage();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(OnboardingRoutePath configuration) async {
    return;
  }
}
