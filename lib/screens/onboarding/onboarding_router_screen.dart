import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/paginators/page_view_controller.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/providers/navigation_providers.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/screens/onboarding/verify_college/verify_college_screen.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/utils/system_ui.dart';
import 'package:animations/animations.dart';

class OnboardingRouterScreen extends ConsumerStatefulWidget {
  const OnboardingRouterScreen({super.key});

  @override
  ConsumerState<OnboardingRouterScreen> createState() => _OnboardingRouterScreenState();
}

class _OnboardingRouterScreenState extends ConsumerState<OnboardingRouterScreen> {
  ChildBackButtonDispatcher? _backButtonDispatcher;

  Widget? currentPage;

  @override
  void initState() {
    super.initState();
    SystemUI.setSystemUIDark();

    currentPage = VerifyCollegeScreen(
      onComplete: verifyEmailComplete,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _backButtonDispatcher = Router.of(context).backButtonDispatcher?.createChildBackButtonDispatcher();
  }

  void verifyEmailComplete() => setState(() => currentPage = buildOnboardingFlow());

  void next() {
    final currentPage = ref.read(onboardingRouterDelegateProvider).currentPage;

    switch (currentPage) {
      default:
        setState(() => ref.read(onboardingRouterDelegateProvider).nextPage());
        break;
    }
  }

  void back() {
    final currentPage = ref.read(onboardingRouterDelegateProvider).currentPage;

    switch (currentPage) {
      case 0:
        AuthService.signOutUser();
        ref.read(appStateProvider.notifier).signOut();
        break;
      default:
        setState(() => ref.read(onboardingRouterDelegateProvider).previousPage());
    }
  }

  Widget buildOnboardingFlow() {
    final currentPageNumber = ref.read(onboardingRouterDelegateProvider.select((delegate) => delegate.currentPage));

    return ScreenScaffold(
      body: Column(
        children: [
          Expanded(
            child: Router(
              routerDelegate: ref.watch(onboardingRouterDelegateProvider),
              backButtonDispatcher: _backButtonDispatcher,
            ),
          ),
          PageViewController(
            currentPage: currentPageNumber,
            pageCount: ref.read(onboardingRouterDelegateProvider).pages.length,
            back: back,
            next: next,
            nextText: 'Next',
            backText: currentPageNumber == 0 ? 'Sign Out' : 'Back',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation, Animation<double> secondaryAnimation) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      child: currentPage,
    );
  }
}
