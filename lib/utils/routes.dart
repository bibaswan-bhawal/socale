import 'package:get/get.dart';
import 'package:socale/screens/onboarding/get_started_screen/get_started.dart';
import 'package:socale/screens/onboarding/login_screen/login_screen.dart';
import 'package:socale/screens/onboarding/register_screen/register_screen.dart';
import 'package:socale/screens/home/chat/chat_screen/chat_screen.dart';
import '../injection/injection.dart';
import '../screens/home/home_screen/home_screen.dart';
import '../screens/splash_screen/splash_screen.dart';
import '../services/authentication_service.dart';

class Routes {
  static List<GetPage> getPages() {
    return [
      GetPage(
        name: '/',
        page: () => SplashScreen(),
      ),
      GetPage(
        name: '/login',
        page: () => LoginScreen(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: '/register',
        page: () => RegisterScreen(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: '/home',
        page: () => HomeScreen(),
      ),
      GetPage(
        name: '/chat',
        page: () => ChatScreen(),
      ),
      GetPage(
        name: '/get_started',
        page: () => GetStartedScreen(),
      )
    ];
  }

  static String getInitialRoute() {
    if (locator<AuthenticationService>().isUserLoggedIn) {
      return '/home';
    }
    return '/';
  }
}
