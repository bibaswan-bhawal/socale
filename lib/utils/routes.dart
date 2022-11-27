import 'package:flutter/cupertino.dart';
import 'package:socale/screens/auth/verify_email_screen.dart';
import 'package:socale/screens/onboarding/onboarding_screen.dart';

import '../screens/auth/screen_get_started.dart';
import '../screens/screen_splash.dart';

class VerifyScreenArguments {
  final String email;

  VerifyScreenArguments(this.email);
}

class Routes {
  static const String main = '/';
  static const String getStarted = '/get_started';
  static const String verifyEmail = '/verify_email';
  static const String onboarding = '/onboarding';

  static final Map<String, WidgetBuilder> appRoutes = {
    main: (context) => SplashScreen(),
    getStarted: (context) => GetStartedScreen(),
    verifyEmail: (context) => VerifyEmailScreen(),
    onboarding: (context) => OnboardingScreen(),
  };
}
