class AppState {
  final bool _isAmplifyConfigured;
  final bool _isLocalDBConfigured;

  final bool _isLoggedIn;

  AppState({
    isAmplifyConfigured = false,
    isLocalDBConfigured = false,
    isLoggedIn = false,
    bool? isInitialized,
  })  : _isLocalDBConfigured = isInitialized ?? isLocalDBConfigured,
        _isAmplifyConfigured = isInitialized ?? isAmplifyConfigured,
        _isLoggedIn = isLoggedIn;

  AppState updateState({bool? isAmplifyConfigured, bool? isLocalDBConfigured, bool? isLoggedIn}) {
    return AppState(
      isAmplifyConfigured: isAmplifyConfigured ?? _isAmplifyConfigured,
      isLocalDBConfigured: isLocalDBConfigured ?? _isLocalDBConfigured,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  bool get isInitialized => _isAmplifyConfigured && _isLocalDBConfigured;
  bool get isLoggedIn => isInitialized && _isLoggedIn;

  @override
  String toString() =>
      '\t\tAppState:\n\t\t\t\tamplifyInit: $_isAmplifyConfigured\n\t\t\t\tlocalDBInit: $_isLocalDBConfigured\n\t\t\t\tisLoggedIn: $_isLoggedIn';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AppState && other.isInitialized == isInitialized && other.isLoggedIn == isLoggedIn;

  @override
  int get hashCode => Object.hash(super.hashCode, _isAmplifyConfigured, _isLocalDBConfigured, _isLoggedIn);
}
