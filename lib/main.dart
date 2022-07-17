import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socale/models/ModelProvider.dart';
import 'package:socale/services/authentication_service.dart';

import 'firebase_options.dart';
import 'injection/injection.dart';
import 'riverpods/global/user_provider.dart';
import 'theme/size_config.dart';
import 'utils/routes.dart';

import 'amplifyconfiguration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  configureDependencies();

  runApp(ProviderScope(child: const SocaleApp()));
}

class SocaleApp extends ConsumerStatefulWidget {
  const SocaleApp({Key? key}) : super(key: key);
  @override
  SocaleAppState createState() => SocaleAppState();
}

class SocaleAppState extends ConsumerState<SocaleApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
    if (locator<AuthenticationService>().isUserLoggedIn) {
      final userStateNotifier = ref.read(userProvider.notifier);
      userStateNotifier
          .getUserData(locator<AuthenticationService>().currentUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return LayoutBuilder(builder: (context, constraints) {
      SizeConfig.init(constraints, Orientation.portrait);
      FirebaseAuth.instance.authStateChanges().listen((user) async {
        final userStateNotifier = ref.watch(userProvider.notifier);

        if (user == null) {
          userStateNotifier.reset();
          return;
        }

        userStateNotifier.getUserData(user.uid);
      });

      return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        child: GetMaterialApp(
          title: 'Socale',
          debugShowCheckedModeBanner: false,
          getPages: Routes.getPages(),
          initialRoute: Routes.getInitialRoute(),
        ),
      );
    });
  }

  Future<void> _configureAmplify() async {
    // Add any Amplify plugins you want to use
    final analyticsPlugin = AmplifyAnalyticsPinpoint();
    final authPlugin = AmplifyAuthCognito();
    final api = AmplifyAPI(modelProvider: ModelProvider.instance);
    final storage = AmplifyStorageS3();
    // You can use addPlugin if you are going to be adding only one plugin
    // await Amplify.addPlugin(authPlugin);
    await Amplify.addPlugins([authPlugin, analyticsPlugin, api, storage]);

    // Once Plugins are added, configure Amplify
    // Note: Amplify can only be configured once.
    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }
}
