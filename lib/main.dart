import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socale/services/authentication_service.dart';

import 'firebase_options.dart';
import 'injection/injection.dart';
import 'riverpods/global/user_provider.dart';
import 'theme/size_config.dart';
import 'utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(systemNavigationBarColor: const Color(0xff1F2124)));
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
}
