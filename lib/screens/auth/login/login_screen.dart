import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socale/theme/colors.dart';
import 'package:socale/theme/text_styles.dart';
import '../../../injection/injection.dart';
import '../../../services/authentication_service.dart';
import '../../../theme/size_config.dart';
import '../../components/gap.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        Get.offAllNamed('/home');
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: SocaleGradients.mainBackgroundGradient,
        ),
        height: sx * 100,
        width: sy * 100,
        child: SafeArea(
          child: Column(
            children: [
              Gap(height: 2),
              Image.asset(
                'assets/images/Socale-Splash-Logo.png',
                height: sx * 5,
              ),
              Expanded(
                flex: 5,
                child: Image.asset('assets/images/Login-Illustration.png'),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: sy * 4),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 6),
                          blurRadius: 15,
                          color: SocaleColors.mainShadowColor,
                        ),
                      ],
                      gradient:
                          SocaleGradients.loginScreenBottomSectionGradient,
                      borderRadius: BorderRadius.circular(sy * 10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: sy * 7, vertical: sx * 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Making Networking Easier',
                                  style: SocaleTextStyles.loginScreenHeading,
                                ),
                                Gap(height: 2),
                                Text(
                                  'Boost your social and professional connections with the power of Socale.', // Added comment
                                  style: SocaleTextStyles.supportingText,
                                ),
                                Gap(height: 4),
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await locator<AuthenticationService>()
                                          .signInWithGoogle();
                                    } on FirebaseAuthException catch (e) {
                                      Get.snackbar(
                                        'An error occurred',
                                        e.message ??
                                            'Could not log in at this moment',
                                      );
                                    }
                                  },
                                  child: const Text('Sign in with google'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Get.offAllNamed('/home');

//HookConsumer(builder: (context, ref, child) {
//                                   FirebaseAuth.instance
//                                       .authStateChanges()
//                                       .listen((user) {
//                                     if (user != null) {
//
//                                     }
//                                   });
//                                   return SignInButton(
//                                     Buttons.Google,
//                                     onPressed: () async {
//                                       try {
//                                         return await locator<
//                                                 AuthenticationService>()
//                                             .signInWithGoogle();
//                                       } on FirebaseAuthException catch (e) {
//                                         Get.snackbar(
//                                           'An error occurred',
//                                           e.message ??
//                                               'Could not log in at this moment',
//                                         );
//                                       }
//                                     },
//                                   );
//                                 }),
