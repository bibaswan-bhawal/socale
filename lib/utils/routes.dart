import 'package:get/get.dart';
import 'package:socale/screens/onboarding/get_started_screen/get_started_screen.dart';
import 'package:socale/screens/onboarding/login_screen/login_screen.dart';
import 'package:socale/screens/onboarding/register_screen/register_screen.dart';
import 'package:socale/signout.dart';
import 'package:socale/screens/onboarding/email_verification_screen/email_verification_screen.dart';
import 'package:socale/screens/onboarding/onboarding_screen/onboarding_screen.dart';
import 'package:socale/screens/splash_screen/splash_screen.dart';

class Routes {
  static List<GetPage> getPages() {
    return [
      GetPage(
        name: '/',
        page: () => SplashScreen(),
      ),
      GetPage(
        name: '/get_started',
        page: () => GetStartedScreen(),
      ),
      GetPage(
        name: '/login',
        page: () => LoginScreen(),
      ),
      GetPage(
        name: '/register',
        page: () => RegisterScreen(),
      ),
      GetPage(
        name: '/email_verification',
        page: () => EmailVerificationScreen(),
      ),
      GetPage(
        name: '/onboarding',
        page: () => OnboardingScreen(),
      ),
      GetPage(
        name: '/sign_out',
        page: () => SignOutScreen(),
      ),
    ];
  }

  static String getInitialRoute() {
    return '/';
  }
}
