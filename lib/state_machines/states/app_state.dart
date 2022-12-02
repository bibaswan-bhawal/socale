import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppState {
  final bool isAmplifyConfigured;
  final bool isLocalDBConfigured;

  AppState({this.isAmplifyConfigured = false, this.isLocalDBConfigured = false});

  AppState updateState({bool? isAmplifyConfigured, bool? isLocalDBConfigured}) {
    return AppState(
      isAmplifyConfigured: isAmplifyConfigured ?? false,
      isLocalDBConfigured: isLocalDBConfigured ?? false,
    );
  }

  bool isAppInitialized() {
    return isAmplifyConfigured && isLocalDBConfigured;
  }

  @override
  String toString() {
    return "isAmplifyConfigured: $isAmplifyConfigured, isLocalDBConfigured: $isLocalDBConfigured";
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState());

  void amplifyConfigured() => state = state.updateState(isAmplifyConfigured: true, isLocalDBConfigured: state.isLocalDBConfigured);
  void localDBConfigured() => state = state.updateState(isAmplifyConfigured: state.isAmplifyConfigured, isLocalDBConfigured: true);
}
