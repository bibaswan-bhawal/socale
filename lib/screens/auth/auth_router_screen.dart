import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/auth/auth_router_delegate.dart';
import 'package:socale/navigation/auth/auth_router_info_parser.dart';

class AuthRouterScreen extends ConsumerWidget {
  const AuthRouterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Router(
      routerDelegate: AuthRouterDelegate(ref),
      routeInformationParser: AuthRouteInformationParser(),
    );
  }
}
