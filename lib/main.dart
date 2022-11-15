import 'dart:async';

import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:animations/animations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/screens/auth_screen/auth_screen.dart';
import 'package:socale/screens/main/main_app.dart';
import 'package:socale/screens/onboarding/onboarding_screen.dart';
import 'package:socale/screens/onboarding/providers/academic_data_provider.dart';
import 'package:socale/screens/onboarding/providers/avatar_data_provider.dart';
import 'package:socale/screens/onboarding/providers/basic_data_provider.dart';
import 'package:socale/screens/onboarding/providers/describe_friend_data_provider.dart';
import 'package:socale/screens/onboarding/providers/personality_data_provider.dart';
import 'package:socale/screens/splash_screen/splash_screen.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/get_it_instance.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/utils/routes.dart';

import 'amplifyconfiguration.dart';
import 'firebase_options.dart';

const String appVersionNumber = "0.1.14";

final isLoggedInProvider = StateProvider<bool>((ref) => false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env"); // load environment vars

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
  List<Widget?> initialPage = [
    SplashScreen(),
    MainApp(transitionAnimation: false),
    OnboardingScreen(),
    AuthScreen(),
  ]; // page router list

  StreamSubscription<DataStoreHubEvent>? dsEventStream;
  StreamSubscription<AuthHubEvent>? authEventStream;

  StreamSubscription<ConnectivityResult>? subscription;

  bool _isAmplifyConfigured = false;
  bool _isDataStoreReady = true;
  int _pageIndex = 0;

  void observeAuthEvents() {
    authEventStream = Amplify.Hub.listen(HubChannel.Auth, (AuthHubEvent event) async {
      if (event.eventName == "SIGNED_OUT") {
        getInitialPage();
      }
    });
  }

  void observeDatastoreEvents() {
    dsEventStream = Amplify.Hub.listen(HubChannel.DataStore, (DataStoreHubEvent event) {
      if (event.eventName == "ready") {
        if (mounted) {
          setState(() {
            _isDataStoreReady = true;
          });
        } else {
          _isDataStoreReady = true;
        }

        getInitialPage();
      }

      if (event.eventName == "syncQueriesStarted") {
        if (mounted) {
          setState(() {
            _isDataStoreReady = false;
          });
        } else {
          _isDataStoreReady = false;
        }
      }
    });
  }

  @override
  void dispose() {
    dsEventStream?.cancel();
    authEventStream?.cancel();
    subscription?.cancel();
    super.dispose();
  }

  Future<void> _configureAmplify() async {
    AmplifyAnalyticsPinpoint pinpointPlugin = AmplifyAnalyticsPinpoint();
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    AmplifyAPI apiPlugin = AmplifyAPI(modelProvider: ModelProvider.instance);
    AmplifyStorageS3 storagePlugin = AmplifyStorageS3();
    AmplifyDataStore dataStorePlugin = AmplifyDataStore(
        modelProvider: ModelProvider.instance,
        conflictHandler: (ConflictData data) {
          final localData = data.local;
          return ConflictResolutionDecision.retry(localData);
        });

    await Amplify.addPlugins([
      authPlugin,
      apiPlugin,
      storagePlugin,
      dataStorePlugin,
      pinpointPlugin,
    ]);

    try {
      await Amplify.configure(amplifyconfig);
      setState(() => _isAmplifyConfigured = true);

      observeDatastoreEvents();
      observeAuthEvents();
      await checkAppVersion();
      await _attemptAutoLogin(); // attempt auto login
      getInitialPage();
    } on AmplifyAlreadyConfiguredException {
      throw ("Tried to reconfigure Amplify.");
    }
  }

  Future<void> checkAppVersion() async {
    final prefs = await SharedPreferences.getInstance();
    final appVersion = prefs.getString("appVersion");

    if (appVersion == null || appVersion != appVersionNumber) {
      print("appVersion: $appVersion");
      await Amplify.DataStore.clear();
      prefs.setString("appVersion", appVersionNumber);
    }

    await Amplify.DataStore.start();
  }

  Future<void> _attemptAutoLogin() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (session.isSignedIn == true) {
        authService.startAuthStreamListener(); // auth events listener
        await ref.read(userAttributesAsyncController.notifier).setAttributes();

      }

      ref.read(isLoggedInProvider.state).state = session.isSignedIn;
    } on NotAuthorizedException catch (_) {
      await Amplify.DataStore.clear();
      ref.read(isLoggedInProvider.state).state = false;
    } on UserNotFoundException catch (_) {
      await Amplify.DataStore.clear();
      ref.read(isLoggedInProvider.state).state = false;
    } on AuthException catch (_) {
      await Amplify.DataStore.clear();
      ref.read(isLoggedInProvider.state).state = false;
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
    if (_isAmplifyConfigured && _isDataStoreReady) {
      final isLoggedIn = ref.read(isLoggedInProvider);
      if (isLoggedIn) {
        bool isOnBoardingComplete = await onboardingService.checkIfUserIsOnboarded();

        if (isOnBoardingComplete) {
          final user = await Amplify.Auth.getCurrentUser();
          await ref.read(userAsyncController.notifier).setUser(user.userId);
          await ref.read(matchAsyncController.notifier).setMatches();
          setState(() => _pageIndex = 1);
        } else {
          setState(() => _pageIndex = 2);
        }
      } else {
        ref.read(academicDataProvider.notifier).clearData();
        ref.read(avatarDataProvider.notifier).clearData();
        ref.read(basicDataProvider.notifier).clearData();
        ref.read(describeFriendDataProvider.notifier).clearData();
        ref.read(personalityDataProvider.notifier).clearData();
        Amplify.DataStore.clear();
        onboardingService.clearAll();
        setState(() => _pageIndex = 3);
      }
    }
  }
}
