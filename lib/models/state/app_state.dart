class AppState {
  final bool isAmplifyConfigured;
  final bool isLocalDBConfigured;

  final bool attemptAutoLogin;
  final bool attemptAutoOnboard;

  final bool isLoggedIn;

  final bool isOnboarded;

  AppState({
    this.isAmplifyConfigured = false,
    this.isLocalDBConfigured = false,
    this.attemptAutoLogin = false,
    this.attemptAutoOnboard = false,
    this.isLoggedIn = false,
    this.isOnboarded = false,
  });

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

  AppState copyWith({
    bool? isAmplifyConfigured,
    bool? isLocalDBConfigured,
    bool? attemptAutoLogin,
    bool? attemptAutoOnboard,
    bool? isLoggedIn,
    bool? isOnboarded,
  }) =>
      AppState(
        isAmplifyConfigured: isAmplifyConfigured ?? this.isAmplifyConfigured,
        isLocalDBConfigured: isLocalDBConfigured ?? this.isLocalDBConfigured,
        attemptAutoLogin: attemptAutoLogin ?? this.attemptAutoLogin,
        attemptAutoOnboard: attemptAutoOnboard ?? this.attemptAutoOnboard,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        isOnboarded: isOnboarded ?? this.isOnboarded,
      );

  @override
  String toString() {
    return 'AppState{isAmplifyConfigured: $isAmplifyConfigured,'
        ' isLocalDBConfigured: $isLocalDBConfigured,'
        ' attemptAutoLogin: $attemptAutoLogin,'
        ' attemptAutoOnboard: $attemptAutoOnboard,'
        ' isLoggedIn: $isLoggedIn,'
        ' isOnboarded: $isOnboarded}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isAmplifyConfigured == other.isAmplifyConfigured &&
          isLocalDBConfigured == other.isLocalDBConfigured &&
          attemptAutoLogin == other.attemptAutoLogin &&
          attemptAutoOnboard == other.attemptAutoOnboard &&
          isLoggedIn == other.isLoggedIn &&
          isOnboarded == other.isOnboarded;

  @override
  int get hashCode =>
      isAmplifyConfigured.hashCode ^
      isLocalDBConfigured.hashCode ^
      attemptAutoLogin.hashCode ^
      attemptAutoOnboard.hashCode ^
      isLoggedIn.hashCode ^
      isOnboarded.hashCode;
}
