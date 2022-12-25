import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppState {
  final bool isAmplifyConfigured;
  final bool isLocalDBConfigured;

  final bool isLoggedIn;

  AppState({
    this.isAmplifyConfigured = false,
    this.isLocalDBConfigured = false,
    this.isLoggedIn = false,
  });

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
  void login() {
    print("User signed in");
    state = state.updateState(isLoggedIn: true);
  }

  void signOut() => state = state.updateState(isLoggedIn: false);
}
