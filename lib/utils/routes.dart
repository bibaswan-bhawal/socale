import 'package:get/get.dart';
import 'package:socale/screens/auth_screen/auth_screen.dart';
import 'package:socale/screens/main/main_app.dart';
import 'package:socale/signout.dart';
import 'package:socale/screens/onboarding/email_verification_screen/email_verification_screen.dart';
import 'package:socale/screens/onboarding/onboarding_screen/onboarding_screen.dart';
import 'package:socale/utils/transitions/fade_through_transition.dart';

class Routes {
  static List<GetPage> getPages() {
    return [
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
        transitionDuration: Duration(milliseconds: 300),
      ),
      GetPage(
        name: '/auth',
        page: () => AuthScreen(),
        customTransition: FadeTransition(),
        transitionDuration: Duration(milliseconds: 300),
      ),
      GetPage(
        name: '/main',
        page: () => MainApp(),
        customTransition: FadeTransition(),
        transitionDuration: Duration(milliseconds: 300),
      )
    ];
  }
}
