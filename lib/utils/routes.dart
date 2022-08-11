import 'package:animations/animations.dart';
import 'package:get/get.dart';
import 'package:socale/screens/auth_screen/login_screen/login_screen.dart';
import 'package:socale/screens/auth_screen/register_screen/register_screen.dart';
import 'package:socale/signout.dart';
import 'package:socale/screens/onboarding/email_verification_screen/email_verification_screen.dart';
import 'package:socale/screens/onboarding/onboarding_screen/onboarding_screen.dart';
import 'package:socale/screens/splash_screen/splash_screen.dart';
import 'package:socale/utils/transitions/fade_through_transition.dart';
import 'package:socale/utils/transitions/shared_x_axis_transition.dart';

import '../screens/auth_screen/get_started_screen/get_started_screen.dart';

class Routes {
  static List<GetPage> getPages() {
    return [
      GetPage(
        name: '/',
        page: () => SplashScreen(),
        customTransition: FadeTransition(),
        transitionDuration: Duration(milliseconds: 600),
      ),
      GetPage(
        name: '/email_verification',
        page: () => EmailVerificationScreen(),
        customTransition: FadeTransition(),
        transitionDuration: Duration(milliseconds: 600),
      ),
      GetPage(
        name: '/onboarding',
        page: () => OnboardingScreen(),
        customTransition: FadeTransition(),
        transitionDuration: Duration(milliseconds: 600),
      ),
      GetPage(
        name: '/sign_out',
        page: () => SignOutScreen(),
        customTransition: FadeTransition(),
        transitionDuration: Duration(milliseconds: 600),
      ),
    ];
  }
}
