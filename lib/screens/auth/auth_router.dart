import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/navigation_providers.dart';

class AuthRouter extends ConsumerStatefulWidget {
  const AuthRouter({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthRouter> createState() => _AuthRouterState();
}

class _AuthRouterState extends ConsumerState<AuthRouter> {
  ChildBackButtonDispatcher? _backButtonDispatcher;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _backButtonDispatcher =
        Router.of(context).backButtonDispatcher?.createChildBackButtonDispatcher();
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
