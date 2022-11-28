import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/services/amplify_backend_service.dart';
import 'package:socale/state_machines/states/auth_state.dart';
import 'package:socale/services/local_database_service.dart';
import 'package:socale/services/notification_service.dart';

// App State providers
final authStateProvider = StateProvider((ref) => AuthState.uninitialized);
final isAmplifyLoadedProvider = StateProvider((ref) => false);
final isLocalDatabaseLoadedProvider = StateProvider((ref) => false);

final appInitializerStateProvider = StateProvider((ref) {
  final isAmplifyLoaded = ref.watch(isAmplifyLoadedProvider);
  final isLocalDatabaseLoaded = ref.watch(isLocalDatabaseLoadedProvider);

  if (isAmplifyLoaded && isLocalDatabaseLoaded) return true;
  return false;
});

// Service providers
final notificationServiceProvider = Provider((ref) => NotificationService());
final amplifyBackendServiceProvider = Provider((ref) => AmplifyBackendService(ref));
final localDatabaseServiceProvider = Provider((ref) => LocalDatabaseService(ref));
