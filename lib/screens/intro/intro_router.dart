import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socale/components/paginators/page_view_controller.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/navigation/intro_navigation/intro_router_delegate.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/utils/system_ui.dart';

class IntroRouter extends ConsumerStatefulWidget {
  const IntroRouter({super.key});

  @override
  ConsumerState<IntroRouter> createState() => _IntroRouterState();
}

class _IntroRouterState extends ConsumerState<IntroRouter> {
  final IntroRouterDelegate _routerDelegate = IntroRouterDelegate();
  ChildBackButtonDispatcher? _backButtonDispatcher;

  @override
  void initState() {
    super.initState();
    _routerDelegate.addListener(updateState);
    SystemUI.setSystemUIDark();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _backButtonDispatcher = Router.of(context).backButtonDispatcher?.createChildBackButtonDispatcher();
  }

  @override
  void dispose() {
    _routerDelegate.removeListener(updateState);
    super.dispose();
  }

  void updateState() => setState(() {});

  void nextPage() {
    if (_routerDelegate.currentPage == _routerDelegate.maxPages - 1) {
      ref.read(appStateProvider.notifier).showIntro(false);
      return;
    }

    _routerDelegate.nextPage();
  }

  void previousPage() {
    if (_routerDelegate.currentPage == 0) {
      ref.read(appStateProvider.notifier).showIntro(false);
      return;
    }

    _routerDelegate.previousPage();
  }

  @override
  Widget build(BuildContext context) {
    _backButtonDispatcher?.takePriority();

    return ScreenScaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Hero(
              tag: 'auth_logo',
              child: Transform.scale(
                scale: 0.75,
                child: SvgPicture.asset('assets/logo/color_logo.svg'),
              ),
            ),
          ),
          Expanded(
            child: Router(
              routerDelegate: _routerDelegate,
              backButtonDispatcher: _backButtonDispatcher,
            ),
          ),
          PageViewController(
            currentPage: _routerDelegate.currentPage,
            pageCount: _routerDelegate.maxPages,
            back: previousPage,
            next: nextPage,
            nextText: _routerDelegate.currentPage == _routerDelegate.maxPages - 1 ? 'Sign In' : 'Next',
            backText: _routerDelegate.currentPage > 0 ? 'Back' : 'Sign In',
          ),
        ],
      ),
    );
  }
}
