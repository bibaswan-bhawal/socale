import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'app_state.freezed.dart';

@freezed
class AppState with _$AppState {
  const AppState._();

  const factory AppState({
    @Default(false) bool isAmplifyConfigured,
    @Default(false) bool isLocalDBConfigured,
    @Default(false) bool attemptAutoOnboard,
    @Default(false) bool isLoggedIn,
    @Default(false) bool attemptAutoLogin,
    @Default(false) bool isOnboarded,
  }) = _AppState;

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
