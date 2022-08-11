import 'package:animations/animations.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:socale/components/translucent_background/translucent_background.dart';
import 'package:socale/screens/auth_screen/get_started_screen/get_started_screen.dart';
import 'package:socale/screens/auth_screen/login_screen/login_screen.dart';
import 'package:socale/screens/auth_screen/register_screen/register_screen.dart';
import 'package:socale/utils/enums/auth_pages.dart';

class AuthScreen extends StatefulWidget {
  final AuthPages initialScreen;
  const AuthScreen({Key? key, this.initialScreen = AuthPages.getStarted})
      : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _reverse = false;
  late AuthPages _currentScreen;

  @override
  initState() {
    super.initState();
    _currentScreen = widget.initialScreen;
  }

  getScreen(value) {
    switch (value) {
      case AuthPages.login:
        return LoginScreen(
          back: goToGetStarted,
        );
      case AuthPages.register:
        return RegisterScreen(
          back: goToGetStarted,
        );
      case AuthPages.getStarted:
        return GetStartedScreen(
          goToLogin: goToLogin,
          goToRegister: goToRegister,
        );
    }
  }

  goToRegister() {
    setState(() => _reverse = false);
    setState(() => _currentScreen = AuthPages.register);
  }

  goToLogin() {
    setState(() => _reverse = false);
    setState(() => _currentScreen = AuthPages.login);
  }

  goToGetStarted() {
    setState(() => _reverse = true);
    setState(() => _currentScreen = AuthPages.getStarted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          TranslucentBackground(),
          ColorfulSafeArea(
            child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 300),
              reverse: _reverse,
              transitionBuilder: (
                Widget child,
                Animation<double> primaryAnimation,
                Animation<double> secondaryAnimation,
              ) {
                return SharedAxisTransition(
                  child: child,
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal,
                );
              },
              child: getScreen(_currentScreen),
            ),
          ),
        ],
      ),
    );
  }
}
