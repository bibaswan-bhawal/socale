import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/state_providers.dart';

class LocalDatabaseService {
  ProviderRef providerRef;

  LocalDatabaseService(this.providerRef);

  Future<void> initLocalDatabase() async {
    Future.delayed(const Duration(milliseconds: 500), () {
      providerRef.read(appStateProvider.notifier).setLocalDBConfigured();
    });
  }
}
