import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/managers/snack_bar_message_manager.dart';
import 'package:socale/providers/state_notifiers/app_state.dart';
import 'package:socale/providers/state_notifiers/auth_state.dart';
import 'package:socale/services/amplify_backend_service.dart';
import 'package:socale/services/local_database_service.dart';
import 'package:socale/services/notification_service.dart';

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) => AppStateNotifier());
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) => AuthStateNotifier());

// Service providers
final notificationServiceProvider = Provider((ProviderRef ref) => NotificationService());
final amplifyBackendServiceProvider = Provider((ProviderRef ref) => AmplifyBackendService());
final localDatabaseServiceProvider = Provider((ProviderRef ref) => LocalDatabaseService(ref));

final snackBarMessageManager = Provider.family((ProviderRef ref, BuildContext? context) => SnackBarMessageManager(context));
