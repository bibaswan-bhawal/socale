import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/auth/auth_router_delegate.dart';
import 'package:socale/navigation/main/main_router_delegate.dart';

final mainRouterDelegateProvider = Provider.autoDispose((ref) => MainRouterDelegate(ref));
final authRouterDelegateProvider = Provider.autoDispose((ref) {
  ref.onDispose(() {
    print('auth rebuild');
  });

  return AuthRouterDelegate(ref);
});
