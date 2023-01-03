import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/utils/debug_print_statements.dart';

class LocalDatabaseService {
  ProviderRef providerRef;

  LocalDatabaseService(this.providerRef);

  Future<void> initLocalDatabase() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      providerRef.read(appStateProvider.notifier).localDBConfigured();
    });
  }
}
