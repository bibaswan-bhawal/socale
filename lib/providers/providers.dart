import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/managers/snack_bar_message_manager.dart';
import 'package:socale/services/amplify_backend_service.dart';
import 'package:socale/services/local_database_service.dart';
import 'package:socale/services/notification_service.dart';
import 'package:socale/managers/screen_navigation_manager.dart';
import 'package:socale/state_machines/state_values/auth/auth_action_value.dart';
import 'package:socale/state_machines/state_values/auth/auth_login_action_value.dart';
import 'package:socale/state_machines/state_values/auth/auth_state_value.dart';
import 'package:socale/state_machines/states/app_state.dart';

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) => AppStateNotifier());

final authStateProvider = StateProvider((ref) => AuthState.notAuthorised);
final authActionProvider = StateProvider((ref) => AuthAction.noAction);
final authLoginActionProvider = StateProvider((ref) => AuthLoginAction.noAction);

// Service providers
final notificationServiceProvider = Provider((ProviderRef ref) => NotificationService());
final amplifyBackendServiceProvider = Provider((ProviderRef ref) => AmplifyBackendService(ref));
final localDatabaseServiceProvider = Provider((ProviderRef ref) => LocalDatabaseService(ref));

final screenNavigationManager = Provider.family((ProviderRef ref, BuildContext? context) => ScreenNavigationManager(context));
final snackBarMessageManager = Provider.family((ProviderRef ref, BuildContext? context) => SnackBarMessageManager(context));
