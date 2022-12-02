class MainRoutePath {
  final bool isUnknown;
  final bool isGetStarted;
  final bool isHome;

  MainRoutePath.app()
      : isUnknown = false,
        isGetStarted = false,
        isHome = false;
  MainRoutePath.splashScreen()
      : isUnknown = false,
        isGetStarted = false,
        isHome = false;
  MainRoutePath.getStartedScreen()
      : isUnknown = false,
        isGetStarted = false,
        isHome = false;
  MainRoutePath.home()
      : isUnknown = false,
        isGetStarted = false,
        isHome = false;
  MainRoutePath.unknown()
      : isUnknown = true,
        isGetStarted = false,
        isHome = false;
}
