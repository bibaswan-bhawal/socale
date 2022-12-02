import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/managers/snack_bar_message_manager.dart';
import 'package:socale/services/amplify_backend_service.dart';
import 'package:socale/services/local_database_service.dart';
import 'package:socale/services/notification_service.dart';
import 'package:socale/managers/screen_navigation_manager.dart';
import 'package:socale/state_machines/state_values/auth_state_values.dart';
import 'package:socale/state_machines/states/app_state.dart';
import 'package:socale/state_machines/states/auth_flow_state.dart';

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) => AppStateNotifier());
final authFlowStateProvider = StateNotifierProvider<AuthFlowStateNotifier, AuthFlowState>((ref) => AuthFlowStateNotifier());

final authStateProvider = StateProvider((StateProviderRef ref) => AuthStateValue.uninitialized);

// Service providers
final notificationServiceProvider = Provider((ProviderRef ref) => NotificationService());
final amplifyBackendServiceProvider = Provider((ProviderRef ref) => AmplifyBackendService(ref));
final localDatabaseServiceProvider = Provider((ProviderRef ref) => LocalDatabaseService(ref));

final screenNavigationManager = Provider.family((ProviderRef ref, BuildContext? context) => ScreenNavigationManager(context));
final snackBarMessageManager = Provider.family((ProviderRef ref, BuildContext? context) => SnackBarMessageManager(context));
