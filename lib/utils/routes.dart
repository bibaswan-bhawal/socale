import 'package:get/get.dart';
import 'package:socale/screens/home/chat/chat_screen/chat_screen.dart';
import '../injection/injection.dart';
import '../screens/home/home_screen/home_screen.dart';
import '../screens/splash_screen/splash_screen.dart';
import '../screens/auth/login/login_screen.dart';
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
        name: '/home',
        page: () => HomeScreen(),
      ),
      GetPage(
        name: '/chat',
        page: () => ChatScreen(),
      ),
    ];
  }

  static Future<String> getInitialRoute() async {
    if (locator<AuthenticationService>().isUserLoggedIn) {
      return '/home';
    }
    return '/';
  }
}
