import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/paginators/page_view_controller.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/providers/navigation_providers.dart';
import 'package:socale/providers/repositories/onboarding_options_repository.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/utils/system_ui.dart';

class BaseOnboardingRouter extends ConsumerStatefulWidget {
  const BaseOnboardingRouter({super.key});

  @override
  ConsumerState<BaseOnboardingRouter> createState() => _BaseOnboardingRouterState();
}

class _BaseOnboardingRouterState extends ConsumerState<BaseOnboardingRouter> {
  ChildBackButtonDispatcher? _backButtonDispatcher;

  @override
  void initState() {
    super.initState();

    initOnboardingOptionsData();
  }

  void initOnboardingOptionsData() {
    ref.read(fetchMajorsProvider);
    ref.read(fetchMinorsProvider);
    ref.read(fetchInterestsProvider);
    ref.read(fetchLanguagesProvider);
    ref.read(fetchClubsProvider);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _backButtonDispatcher = Router.of(context).backButtonDispatcher!.createChildBackButtonDispatcher();
  }

  void next() {
    final currentPage = ref.read(baseOnboardingRouterDelegateProvider).currentPage;
    final maxPages = ref.read(baseOnboardingRouterDelegateProvider).pages.length;

    if (currentPage == maxPages - 1) return;

    ref.read(baseOnboardingRouterDelegateProvider).nextPage();
  }

  void back() {
    final currentPage = ref.read(baseOnboardingRouterDelegateProvider).currentPage;

    switch (currentPage) {
      case 0:
        ref.read(authServiceProvider).signOutUser();
        return;
      default:
        ref.read(baseOnboardingRouterDelegateProvider).previousPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemUI.setSystemUIDark();

    final delegate = ref.watch(baseOnboardingRouterDelegateProvider);
    final currentPage = delegate.currentPage;
    final maxPages = delegate.pages.length;

    _backButtonDispatcher?.takePriority();

    return ScreenScaffold(
      body: Column(
        children: [
          Expanded(
            child: Router(
              routerDelegate: delegate,
              backButtonDispatcher: _backButtonDispatcher,
            ),
          ),
          PageViewController(
            currentPage: currentPage,
            pageCount: maxPages,
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
