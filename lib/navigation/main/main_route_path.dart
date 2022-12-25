class MainRoutePath {
  final bool isGetStarted;
  final bool isApp;

  MainRoutePath.splashScreen()
      : isGetStarted = false,
        isApp = false;
  MainRoutePath.auth()
      : isGetStarted = true,
        isApp = false;
  MainRoutePath.app()
      : isGetStarted = false,
        isApp = true;
}
