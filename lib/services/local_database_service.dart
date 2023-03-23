import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/state_providers.dart';

class LocalDatabaseService {
  final ProviderRef ref;

  const LocalDatabaseService(this.ref);

  Future<void> configureDb() async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      ref.read(appStateProvider.notifier).setLocalDBConfigured();
    });
  }
}
