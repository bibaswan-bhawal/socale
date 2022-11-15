import 'dart:core';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/providers/providers.dart';
import 'package:socale/screens/auth/screen_get_started.dart';
import 'package:socale/screens/screen_splash.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  List<Widget> screen = [const SplashScreen(), const GetStartedScreen()];

  int mainScreenController = 0; // Page controller

  bool isAmplifyConfigured = false;
  bool isDatabaseLoaded = false;

  @override
  void initState() {
    super.initState();

    ref.read(notificationServiceProvider).initNotificationService();
    ref.read(amplifyBackendServiceProvider).configureAmplify();
    ref.read(localDatabaseServiceProvider).initLocalDatabase();
  }

  void onAppInitialized(_, state) {
    if (state == true) {
      setState(() {
        mainScreenController = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final isUserSignedIn = ref.watch(isSignedInProvider);
    ref.listen(appInitializerStateProvider, onAppInitialized);

    return mainUIBuilder();
  }

  Widget mainUIBuilder() {
    return MaterialApp(
      theme: ThemeData(canvasColor: Colors.transparent),
      debugShowCheckedModeBanner: false,
      title: 'Socale',
      home: PageTransitionSwitcher(
        transitionBuilder: (Widget child, Animation<double> primaryAnimation, Animation<double> secondaryAnimation) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: screen[mainScreenController],
      ),
    );
  }
}
