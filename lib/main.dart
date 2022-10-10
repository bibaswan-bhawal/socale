import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/screens/auth_screen/auth_screen.dart';
import 'package:socale/screens/main/main_app.dart';
import 'package:socale/screens/onboarding/onboarding_screen.dart';
import 'package:socale/screens/splash_screen/splash_screen.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/get_it_instance.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/utils/routes.dart';

import 'firebase_options.dart';
import 'amplifyconfiguration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env"); // load environment variables files
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // initialize firebase for FCM

  await Hive.initFlutter(); // initialize local key storage
  configureDependencies(); // configure routing dependencies
  runApp(ProviderScope(child: SocaleApp()));
}

class SocaleApp extends ConsumerStatefulWidget {
  const SocaleApp({Key? key}) : super(key: key);

  @override
  SocaleAppState createState() => SocaleAppState();
}

class SocaleAppState extends ConsumerState<SocaleApp> {
  List<Widget?> initialPage = [SplashScreen(), MainApp(transitionAnimation: false), OnboardingScreen(), AuthScreen()]; // page router list

  bool _isAmplifyConfigured = false;
  bool _isSignedIn = false;
  int _pageIndex = 0;

  Future<void> _configureAmplify() async {
    //AmplifyAnalyticsPinpoint analyticsPlugin = AmplifyAnalyticsPinpoint(); // library currently broken so can't use
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    AmplifyAPI apiPlugin = AmplifyAPI(modelProvider: ModelProvider.instance);
    AmplifyStorageS3 storagePlugin = AmplifyStorageS3();
    AmplifyDataStore dataStorePlugin = AmplifyDataStore(modelProvider: ModelProvider.instance);

    await Amplify.addPlugins([
      authPlugin,
      apiPlugin,
      storagePlugin,
      dataStorePlugin,
      //analyticsPlugin, // library currently broken so can't use
    ]);

    try {
      await Amplify.configure(amplifyconfig);
      setState(() => _isAmplifyConfigured = true);
      await _attemptAutoLogin(); // attempt auto login
      await getInitialPage(); // get initial page after splash screen
    } on AmplifyAlreadyConfiguredException {
      throw ("Tried to reconfigure Amplify.");
    }
  }

  Future<void> _attemptAutoLogin() async {

    try {
      final session = await Amplify.Auth.fetchAuthSession();

      if (session.isSignedIn == true) {
        authService.startAuthStreamListener(); // auth events listener

        await ref.read(userAttributesAsyncController.notifier).setAttributes(); // set user attributes
        await Amplify.DataStore.start(); // start datastore
        await Amplify.DataStore.clear();
      }

      setState(() => _isSignedIn = session.isSignedIn);
    } on NotAuthorizedException catch (_) {
      setState(() => _isSignedIn = false);
    } on UserNotFoundException catch (_) {
      setState(() => _isSignedIn = false);
    } on AuthException catch (e) {
      setState(() => _isSignedIn = false);
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide'); // hide keyboard at start
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
        theme: ThemeData(canvasColor: Colors.transparent),
        title: 'Socale',
        debugShowCheckedModeBanner: false,
        getPages: Routes.getPages(),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (
              Widget child,
              Animation<double> primaryAnimation,
              Animation<double> secondaryAnimation,
            ) {
              return FadeThroughTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
            child: initialPage[_pageIndex],
          ),
        ),
      ),
    );
  }

  getInitialPage() async {
    if (_isAmplifyConfigured) {
      if (_isSignedIn) {
        bool isOnBoardingComplete = await onboardingService.checkIfUserIsOnboarded();
        if (isOnBoardingComplete) {
          final user = await Amplify.Auth.getCurrentUser();
          await ref.read(userAsyncController.notifier).setUser(user.userId);
          await ref.read(matchAsyncController.notifier).setMatches(user.userId);

          setState(() => _pageIndex = 1);
        } else {
          setState(() => _pageIndex = 2);
        }
      } else {
        setState(() => _pageIndex = 3);
      }
    }
  }
}
