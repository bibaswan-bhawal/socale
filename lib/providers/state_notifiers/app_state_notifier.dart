import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/state/app_state/app_state.dart';
import 'package:socale/providers/model_providers.dart';

class AppStateNotifier extends StateNotifier<AppState> {
  StateNotifierProviderRef ref;

  AppStateNotifier(this.ref) : super(AppState());

  void setAmplifyConfigured() => state = state.copyWith(isAmplifyConfigured: true);

  void setLocalDBConfigured() => state = state.copyWith(isLocalDBConfigured: true);

  void setAttemptAutoLogin() => state = state.copyWith(attemptAutoLogin: true);

  void setAttemptAutoOnboard() => state = state.copyWith(attemptAutoOnboard: true);

  void setLoggedIn() => state = state.copyWith(isLoggedIn: true);

  void setOnboarded() {
    ref.read(onboardingUserProvider.notifier).disposeState();
    state = state.copyWith(isOnboarded: true);
  }

  void setLoggedOut() {
    ref.read(currentUserProvider.notifier).disposeState();
    ref.read(onboardingUserProvider.notifier).disposeState();

    state = state.copyWith(isLoggedIn: false);
  }
}
