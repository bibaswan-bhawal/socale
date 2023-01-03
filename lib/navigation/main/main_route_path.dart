import 'package:socale/models/app_state.dart';

class MainRoutePath extends AppRoutePath {
  AppState appState;

  MainRoutePath.splashScreen() : appState = AppState();
  MainRoutePath.app() : appState = AppState(isInitialized: true, isLoggedIn: false);
}

abstract class AppRoutePath {}
