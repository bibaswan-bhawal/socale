import 'package:flutter/cupertino.dart';

import '../screens/auth/screen_get_started.dart';
import '../screens/screen_splash.dart';

class Routes {
  static const String main = '/';
  static const String getStarted = 'get_started';

  static final Map<String, WidgetBuilder> appRoutes = {
    main: (context) => SplashScreen(),
    getStarted: (context) => GetStartedScreen(),
  };
}
