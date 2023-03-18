import 'package:flutter/cupertino.dart';
import 'package:socale/navigation/onboarding_navigation/base_onboarding_navigation/pages/base_onboarding_pages.dart';
import 'package:socale/navigation/onboarding_navigation/base_onboarding_navigation/base_onboarding_route_path.dart';
import 'package:socale/screens/onboarding/base_onboarding/base_onboarding_screen_interface.dart';

class BaseOnboardingRouterDelegate extends RouterDelegate<BaseOnboardingRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BaseOnboardingRoutePath> {
  @override
  GlobalKey<NavigatorState>? navigatorKey;
  final HeroController heroController = HeroController();

  late List<BaseOnboardingPage> pages = [
    const BasicInfoPage(),
    const AcademicInfoPage(),
  ];

  int currentPage = 0;

  BaseOnboardingRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'onboarding navigator state key');

  void nextPage() async {
    var screens = BaseOnboardingScreen.allOnboardingScreens(navigatorKey!.currentState!.context);
    BaseOnboardingScreenState currentState = screens.last;

    if (!(await currentState.onNext())) return;

    currentPage = (currentPage + 1).clamp(0, pages.length - 1);
    notifyListeners();
  }

  void previousPage() async {
    var screens = BaseOnboardingScreen.allOnboardingScreens(navigatorKey!.currentState!.context);
    BaseOnboardingScreenState currentState = screens.last;

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
  Future<void> setNewRoutePath(BaseOnboardingRoutePath configuration) async {
    return;
  }
}
