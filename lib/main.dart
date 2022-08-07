import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/screens/onboarding/onboarding_screen/onboarding_screen.dart';
import 'utils/routes.dart';
import 'amplifyconfiguration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(ProviderScope(child: const SocaleApp()));
}

class SocaleApp extends StatefulWidget {
  const SocaleApp({Key? key}) : super(key: key);
  @override
  _SocaleAppState createState() => _SocaleAppState();
}

class _SocaleAppState extends State<SocaleApp> {
  bool _isAmplifyConfigured = false;

  Future<void> _configureAmplify() async {
    final analyticsPlugin = AmplifyAnalyticsPinpoint();
    final authPlugin = AmplifyAuthCognito();
    final apiPlugin = AmplifyAPI(modelProvider: ModelProvider.instance);
    final storagePlugin = AmplifyStorageS3();

    await Amplify.addPlugins([
      authPlugin,
      analyticsPlugin,
      apiPlugin,
    ]);

    try {
      await Amplify.configure(amplifyconfig);
      setState(() => _isAmplifyConfigured = true);
      _attemptAutoLogin();
    } on AmplifyAlreadyConfiguredException {
      print("Tried to reconfigure Amplify.");
    }
  }

  Future<void> _attemptAutoLogin() async {
    try {
      final sessions = await Amplify.Auth.fetchAuthSession();
    } catch (e) {
      rethrow;
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
        home: OnboardingScreen(),
      ),
    );
  }
}

// _isAmplifyConfigured
// ? (_isSignedIn
// ? EmailVerificationScreen()
//     : GetStartedScreen()) // Always goes to email verification to check
// : SplashScreen()
