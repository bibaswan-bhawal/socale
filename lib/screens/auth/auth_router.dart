import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/navigation_providers.dart';
import 'package:socale/utils/system_ui.dart';

class AuthRouter extends ConsumerStatefulWidget {
  const AuthRouter({super.key});

  @override
  ConsumerState<AuthRouter> createState() => _AuthRouterState();
}

class _AuthRouterState extends ConsumerState<AuthRouter> {
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
    _backButtonDispatcher?.takePriority();

    return Router(
      routerDelegate: ref.watch(authRouterDelegateProvider),
      backButtonDispatcher: _backButtonDispatcher,
    );
  }
}
