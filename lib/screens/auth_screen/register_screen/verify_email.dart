import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/primary_loading_button.dart';
import 'package:socale/components/snackbar/auth_snackbars.dart';
import 'package:socale/components/translucent_background/translucent_background.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/values/colors.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String email, password;
  const VerifyEmailScreen({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool isLoading = false;

  void trySignIn() async {
    if (!isLoading) {
      setState(() => isLoading = true);

      try {
        final result = await authService.signIn(
            widget.email, widget.password); // try signing in user.

        if (result.nextStep?.signInStep == "CONFIRM_SIGN_UP") {
          setState(() => isLoading = false);
          if (mounted) authSnackBar.emailNotVerifiedSnack(context);
        } else {
          userDataLoader(result.isSignedIn); // user is signed in load data
        }
      } on NotAuthorizedException catch (_) {
        setState(() => isLoading = false);
        authService.signOutCurrentUser(ref);
        authSnackBar.userNotAuthorizedSnackBar(context);
      } on UserNotFoundException catch (_) {
        setState(() => isLoading = false);
        authService.signOutCurrentUser(ref);
        authSnackBar.userNotFoundSnackBar(context);
      } on AuthException catch (_) {
        setState(() => isLoading = false);
        authService.signOutCurrentUser(ref);
        authSnackBar.defaultErrorMessageSnack(context);
      }
    }
  }

  void userDataLoader(bool isSignedIn) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (isSignedIn) {
      //authAnalytics.recordUserSignIn(); // record user signed in
      await Amplify.DataStore.start(); // load user data
      await ref.read(userAttributesAsyncController.notifier).setAttributes();
      checkIfOnboarded();
    }
  }

  void checkIfOnboarded() async {
    bool isOnboardingDone = await onboardingService.checkIfUserIsOnboarded();

    if (isOnboardingDone) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      final user = await Amplify.Auth.getCurrentUser();
      await ref.read(userAsyncController.notifier).setUser(user.userId);
      Get.offAllNamed('/main');
      return;
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      onboardingService.clearAll();
      Get.offAllNamed('/onboarding');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          TranslucentBackground(),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: Image.asset(
                      'assets/images/onboarding_illustration_5.png',
                      height: size.height / 2.2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Verify your ',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'Email',
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..shader = ColorValues.socaleOrangeGradient,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: SizedBox(
                      width: 300,
                      child: Text(
                        'Before getting started with Socale, please verify the link sent to your email.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          textStyle: TextStyle(
                            color: const Color(0xFF7A7A7A),
                            height: 1.4,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: PrimaryLoadingButton(
                width: size.width,
                height: 60,
                colors: [Color(0xFFFD6C00), Color(0xFFFFA133)],
                text: "Sign In",
                onClickEventHandler: trySignIn,
                isLoading: isLoading,
              ),
            ),
          ),
          Positioned(
            right: 30,
            top: 60,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                final isSignedOut = await authService.signOutCurrentUser(ref);
                if (isSignedOut && mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              child: Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  "Log Out",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorValues.socaleOrange),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          ),
        ],
      ),
    );
  }
}
