import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'app_state.freezed.dart';

@freezed
class AppState with _$AppState {
  const AppState._();

  const factory AppState({
    required bool initError,
    required bool isAmplifyConfigured,
    required bool isLocalDBConfigured,
    required bool attemptAutoOnboard,
    required bool attemptAutoLogin,
    required bool isLoggedIn,
    required bool showIntro,
    required bool isOnboarded,
  }) = _AppState;

  factory AppState.initial() => const AppState(
        initError: false,
        isAmplifyConfigured: false,
        isLocalDBConfigured: false,
        attemptAutoOnboard: false,
        attemptAutoLogin: false,
        showIntro: true,
        isLoggedIn: false,
        isOnboarded: false,
      );

  bool get isInitialized {
    bool isInitialized = false;
    if (isAmplifyConfigured && isLocalDBConfigured && attemptAutoLogin) isInitialized = true;

    if (attemptAutoLogin && isLoggedIn) {
      if (!attemptAutoOnboard) {
        isInitialized = false;
      }
    }

    return isInitialized;
  }
}
