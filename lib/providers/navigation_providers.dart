import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/auth_navigation/auth_router_delegate.dart';
import 'package:socale/navigation/main_navigation/main_router_delegate.dart';
import 'package:socale/navigation/onboarding_navigation/base_onboarding_navigation/base_onboarding_router_delegate.dart';

final mainRouterDelegateProvider = ChangeNotifierProvider.autoDispose((AutoDisposeChangeNotifierProviderRef ref) => MainRouterDelegate(ref));
final authRouterDelegateProvider = ChangeNotifierProvider.autoDispose((AutoDisposeChangeNotifierProviderRef ref) => AuthRouterDelegate(ref));

final baseOnboardingRouterDelegateProvider = ChangeNotifierProvider.autoDispose((ref) => BaseOnboardingRouterDelegate());
