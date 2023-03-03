import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/paginators/page_view_controller.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/providers/navigation_providers.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/utils/system_ui.dart';

class OnboardingRouterScreen extends ConsumerStatefulWidget {
  const OnboardingRouterScreen({super.key});

  @override
  ConsumerState<OnboardingRouterScreen> createState() => _OnboardingRouterScreenState();
}

class _OnboardingRouterScreenState extends ConsumerState<OnboardingRouterScreen> {
  ChildBackButtonDispatcher? _backButtonDispatcher;

  @override
  void initState() {
    super.initState();
    SystemUI.setSystemUIDark();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _backButtonDispatcher =
        Router.of(context).backButtonDispatcher?.createChildBackButtonDispatcher();
  }

  back() {
    final currentPage = ref.read(onboardingRouterDelegateProvider).currentPage;

    if (currentPage == 0) {
      AuthService.signOutUser();
      ref.read(appStateProvider.notifier).signOut();
    } else {
      ref.read(onboardingRouterDelegateProvider).previousPage();
      setState(() {});
    }
  }

  next() {
    ref.read(onboardingRouterDelegateProvider).nextPage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentPage =
        ref.read(onboardingRouterDelegateProvider.select((delegate) => delegate.currentPage));

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
            currentPage: currentPage,
            pageCount: ref.read(onboardingRouterDelegateProvider).pages.length,
            back: back,
            next: next,
            nextText: 'Next',
            backText: currentPage == 0 ? 'Sign Out' : 'Back',
          ),
        ],
      ),
    );
  }
}
