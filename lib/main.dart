import 'dart:async';

import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socale/auth/auth_repository.dart';
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/screens/auth_screen/auth_screen.dart';
import 'package:socale/screens/onboarding/email_verification_screen/email_verification_screen.dart';
import 'package:socale/screens/onboarding/onboarding_screen/onboarding_screen.dart';
import 'package:socale/screens/splash_screen/splash_screen.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/signout.dart';
import 'package:socale/utils/enums/onboarding_fields.dart';
import 'package:socale/utils/get_it_instance.dart';
import 'utils/routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'amplifyconfiguration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  configureDependencies();
  await Hive.initFlutter();
  runApp(ProviderScope(child: const SocaleApp()));
}

class SocaleApp extends StatefulWidget {
  const SocaleApp({Key? key}) : super(key: key);
  @override
  _SocaleAppState createState() => _SocaleAppState();
}

class _SocaleAppState extends State<SocaleApp> {
  List<Widget?> initialPage = [SplashScreen()];
  bool _isAmplifyConfigured = false;
  bool _isSignedIn = false;
  int _pageIndex = 0;

  Future<void> _configureAmplify() async {
    final analyticsPlugin = AmplifyAnalyticsPinpoint();
    final authPlugin = AmplifyAuthCognito();
    final apiPlugin = AmplifyAPI(modelProvider: ModelProvider.instance);
    final storagePlugin = AmplifyStorageS3();
    final dataStorePlugin = AmplifyDataStore(
      modelProvider: ModelProvider.instance,
    );

    await Amplify.addPlugins([
      authPlugin,
      analyticsPlugin,
      apiPlugin,
      storagePlugin,
      dataStorePlugin,
    ]);

    try {
      await Amplify.configure(amplifyconfig);
      setState(() => _isAmplifyConfigured = true);
      await _attemptAutoLogin();
      StreamSubscription<HubEvent> hubSubscription =
          Amplify.Hub.listen([HubChannel.Auth], (hubEvent) {
        switch (hubEvent.eventName) {
          case 'SIGNED_IN':
            print('USER IS SIGNED IN');
            break;
          case 'SIGNED_OUT':
            setState(() => _isSignedIn = false);
            getInitialPage();
            print('USER IS SIGNED OUT');
            break;
          case 'SESSION_EXPIRED':
            print('SESSION HAS EXPIRED');
            break;
          case 'USER_DELETED':
            print('USER HAS BEEN DELETED');
            break;
        }
      });
      await getInitialPage();
    } on AmplifyAlreadyConfiguredException {
      print("Tried to reconfigure Amplify.");
    }
  }

  Future<void> _attemptAutoLogin() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      setState(() => _isSignedIn = session.isSignedIn);
    } on NotAuthorizedException catch (_) {
      print("error");
    }
  }

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: GetMaterialApp(
        theme: ThemeData(
          canvasColor: Colors.transparent,
        ),
        title: 'Socale',
        debugShowCheckedModeBanner: false,
        getPages: Routes.getPages(),
        home: Scaffold(
          backgroundColor: Colors.white,
          body: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (
              Widget child,
              Animation<double> primaryAnimation,
              Animation<double> secondaryAnimation,
            ) {
              return FadeThroughTransition(
                child: child,
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
              );
            },
            child: initialPage[_pageIndex],
          ),
        ),
      ),
    );
  }

  getInitialPage() async {
    print("getting Page");
    if (_isAmplifyConfigured) {
      if (_isSignedIn) {
        bool isOnBoardingComplete =
            await onboardingService.checkIfUserIsOnboarded();
        OnboardingStep currentStep =
            await onboardingService.getOnboardingStep();
        if (isOnBoardingComplete) {
          setState(() => initialPage.insert(1, SignOutScreen()));
          setState(() => _pageIndex = 1);
        } else if (currentStep == OnboardingStep.started) {
          setState(() => initialPage.insert(1, EmailVerificationScreen()));
          setState(() => _pageIndex = 1);
        } else {
          setState(() => initialPage.insert(1, OnboardingScreen()));
          setState(() => _pageIndex = 1);
        }
      } else {
        setState(() => initialPage.insert(1, AuthScreen()));
        setState(() => _pageIndex = 1);
      }
    }
    print("is Configured " + _isAmplifyConfigured.toString());
    print("is signed in " + _isSignedIn.toString());
    print(initialPage);
    print(_pageIndex);
  }
}
