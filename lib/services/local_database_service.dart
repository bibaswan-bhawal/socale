import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/providers.dart';
import 'package:socale/utils/debug_print_statements.dart';

class LocalDatabaseService {
  ProviderRef providerRef;

  LocalDatabaseService(this.providerRef);

  Future<void> initLocalDatabase() async {
    DateTime startTime = DateTime.now();

    await Future.delayed(const Duration(seconds: 3), () {
      providerRef.read(isLocalDatabaseLoadedProvider.notifier).state = true;
    });

    printRunTime(startTime, "Local DB initialisation");
  }
}
