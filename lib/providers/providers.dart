import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/managers/screen_navigation_manager.dart';
import 'package:socale/managers/snack_bar_message_manager.dart';
import 'package:socale/services/amplify_backend_service.dart';
import 'package:socale/services/local_database_service.dart';
import 'package:socale/services/notification_service.dart';
import 'package:socale/state_machines/states/app_state.dart';
import 'package:socale/types/auth/auth_action.dart';
import 'package:socale/types/auth/auth_login_action.dart';

final appStateProvider =
    StateNotifierProvider<AppStateNotifier, AppState>((ref) => AppStateNotifier());

final authActionProvider = StateProvider((ref) => AuthAction.noAction);
final authLoginActionProvider = StateProvider((ref) => AuthLoginAction.noAction);

// Service providers
final notificationServiceProvider = Provider((ProviderRef ref) => NotificationService());
final amplifyBackendServiceProvider = Provider((ProviderRef ref) => AmplifyBackendService(ref));
final localDatabaseServiceProvider = Provider((ProviderRef ref) => LocalDatabaseService(ref));

final screenNavigationManager =
    Provider.family((ProviderRef ref, BuildContext? context) => ScreenNavigationManager(context));
final snackBarMessageManager =
    Provider.family((ProviderRef ref, BuildContext? context) => SnackBarMessageManager(context));
