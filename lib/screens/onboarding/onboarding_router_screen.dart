import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/navigation_providers.dart';
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
    _backButtonDispatcher = Router.of(context).backButtonDispatcher?.createChildBackButtonDispatcher();
  }

  @override
  Widget build(BuildContext context) {
    return Router(
      routerDelegate: ref.watch(onboardingRouterDelegateProvider),
      backButtonDispatcher: _backButtonDispatcher,
    );
  }
}
