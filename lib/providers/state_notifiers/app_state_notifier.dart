import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/models/app_state.dart';

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState());

  void amplifyConfigured() => state = state.updateState(isAmplifyConfigured: true);
  void localDBConfigured() => state = state.updateState(isLocalDBConfigured: true);

  void login() => state = state.updateState(isLoggedIn: true);
  void signOut() => state = state.updateState(isLoggedIn: false);
}
