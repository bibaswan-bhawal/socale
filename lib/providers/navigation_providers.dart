import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/navigation/auth/auth_router_delegate.dart';
import 'package:socale/navigation/main/main_router_delegate.dart';

final mainRouterDelegateProvider = Provider((ref) => MainRouterDelegate(ref));
final authRouterDelegateProvider = Provider((ref) => AuthRouterDelegate(ref));
