import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socale/auth/auth_repository.dart';
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/screens/onboarding/email_verification_screen/email_verification_screen.dart';
import 'package:socale/screens/onboarding/get_started_screen/get_started_screen.dart';
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

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

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
  bool _isAmplifyConfigured = false;
  bool _isSignedIn = false;
  Widget? _initialPage;

  Future<void> _configureAmplify() async {
    final analyticsPlugin = AmplifyAnalyticsPinpoint();
    final authPlugin = AmplifyAuthCognito();
    final apiPlugin = AmplifyAPI(modelProvider: ModelProvider.instance);
    final storagePlugin = AmplifyStorageS3();
    final dataStorePlugin =
        AmplifyDataStore(modelProvider: ModelProvider.instance);

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
      await getInitialPage();
    } on AmplifyAlreadyConfiguredException {
      print("Tried to reconfigure Amplify.");
    } on NotAuthorizedException {
      print("bob");
    }
  }

  Future<void> _attemptAutoLogin() async {
    try {
      final sessions = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: false));
      setState(() => _isSignedIn = sessions.isSignedIn);
    } on NotAuthorizedException catch (e) {
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
        title: 'Socale',
        debugShowCheckedModeBanner: false,
        getPages: Routes.getPages(),
        home: _initialPage ?? SplashScreen(),
      ),
    );
  }

  getInitialPage() async {
    if (_isAmplifyConfigured) {
      if (_isSignedIn) {
        bool isOnBoardingComplete =
            await onboardingService.checkIfUserIsOnboarded();
        OnboardingStep currentStep =
            await onboardingService.getOnboardingStep();
        if (isOnBoardingComplete) {
          setState(() => _initialPage = SignOutScreen());
        } else if (currentStep == OnboardingStep.started) {
          setState(() => _initialPage = EmailVerificationScreen());
        } else {
          setState(() => _initialPage = OnboardingScreen());
        }
      } else {
        setState(() => _initialPage = GetStartedScreen());
      }
    }
  }
}
