import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppState {
  final bool isAmplifyConfigured;
  final bool isLocalDBConfigured;

  final bool isLoggedIn;

  AppState({
    isAmplifyConfigured = false,
    isLocalDBConfigured = false,
    this.isLoggedIn = false,
    bool? isInitialized,
  })  : isLocalDBConfigured = isInitialized ?? isLocalDBConfigured,
        isAmplifyConfigured = isInitialized ?? isAmplifyConfigured;

  AppState updateState({bool? isAmplifyConfigured, bool? isLocalDBConfigured, bool? isLoggedIn}) {
    return AppState(
      isAmplifyConfigured: isAmplifyConfigured ?? this.isAmplifyConfigured,
      isLocalDBConfigured: isLocalDBConfigured ?? this.isLocalDBConfigured,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  bool isInitialized() {
    return isAmplifyConfigured && isLocalDBConfigured;
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState());

  void amplifyConfigured() => state = state.updateState(isAmplifyConfigured: true);
  void localDBConfigured() => state = state.updateState(isLocalDBConfigured: true);

  void login() => state = state.updateState(isLoggedIn: true);
  void signOut() => state = state.updateState(isLoggedIn: false);
}
