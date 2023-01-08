import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:socale/services/amplify_backend_service.dart';
import 'package:socale/services/local_database_service.dart';
import 'package:socale/services/notification_service.dart';

final notificationServiceProvider = Provider((ProviderRef ref) => NotificationService());
final amplifyBackendServiceProvider = Provider((ProviderRef ref) => AmplifyBackendService(ref));
final localDatabaseServiceProvider = Provider((ProviderRef ref) => LocalDatabaseService(ref));