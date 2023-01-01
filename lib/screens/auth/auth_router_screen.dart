import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/auth/auth_router_delegate.dart';

class AuthRouterScreen extends ConsumerStatefulWidget {
  const AuthRouterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthRouterScreen> createState() => _AuthRouterScreenState();
}

class _AuthRouterScreenState extends ConsumerState<AuthRouterScreen> {
  late ChildBackButtonDispatcher? _backButtonDispatcher;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _backButtonDispatcher = Router.of(context).backButtonDispatcher?.createChildBackButtonDispatcher();
  }

  @override
  Widget build(BuildContext context) {
    _backButtonDispatcher?.takePriority();

    return Router(
      routerDelegate: AuthRouterDelegate(ref),
      backButtonDispatcher: _backButtonDispatcher,
    );
  }
}
