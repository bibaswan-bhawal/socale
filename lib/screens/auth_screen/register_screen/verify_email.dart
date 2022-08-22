import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/auth/auth_repository.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/translucent_background/translucent_background.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/enums/onboarding_fields.dart';
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

  getNextPage() async {
    bool isOnboardingDone = await onboardingService.checkIfUserIsOnboarded();
    OnboardingStep currentStep = await onboardingService.getOnboardingStep();

    if (isOnboardingDone) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      final user = await Amplify.Auth.getCurrentUser();
      await ref.read(userAsyncController.notifier).setUser(user.userId);
      ref.watch(userAsyncController).when(
            data: (_) {
              Get.offAllNamed('/main');
            },
            error: (err, _) {
              somethingWrong();
            },
            loading: () {},
          );
      return;
    } else if (currentStep == OnboardingStep.started) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      Get.offAllNamed('/email_verification');
      return;
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      Get.offAllNamed('/onboarding');
      return;
    }
  }

  void somethingWrong() {
    setState(() => isLoading = false);
    final errorSnackBar = SnackBar(
      content: Text(
        "Something went wrong signing in, please try again.",
        textAlign: TextAlign.center,
      ),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }

  userSignedInHandler(bool isSignedIn) async {
    if (isSignedIn) {
      setState(() => isLoading = false);
      print("user signed in: ${widget.email} ${widget.password}");
      authRepository.startAuthStreamListener();
      Amplify.DataStore.start();
      getNextPage();
    } else {
      setState(() => isLoading = false);
      final errorSnackBar = SnackBar(
        content: Text(
          "Something went wrong signing in, please try again.",
          textAlign: TextAlign.center,
        ),
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
    }
  }

  signIn() async {
    final loadingSnackBar = SnackBar(
      duration: Duration(days: 365),
      content: Row(
        children: [
          Expanded(
            child: Text(
              "Verifying Email",
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(loadingSnackBar);

    if (!isLoading) {
      setState(() => isLoading = true);
      await authRepository.signOutCurrentUser();
      final user = await Amplify.Auth.fetchAuthSession();
      if (!user.isSignedIn) {
        try {
          final result =
              await authRepository.login(widget.email, widget.password);

          if (result.nextStep?.signInStep == "CONFIRM_SIGN_UP") {
            setState(() => isLoading = false);
            final notVerifiedSnackBar = SnackBar(
              content: Text(
                "Email not verified",
                textAlign: TextAlign.left,
              ),
            );

            if (!mounted) return;
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(notVerifiedSnackBar);
          } else {
            if (result.isSignedIn) {
              userSignedInHandler(result.isSignedIn);
            }
          }
        } on AuthException catch (_) {
          somethingWrong();
        }
      } else {
        signIn();
      }
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
                            text: 'verify your ',
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
                        'Before getting started with socale please verify your email. We have sent a link the email you used to sign up.',
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
              child: PrimaryButton(
                width: size.width,
                height: 60,
                colors: [Color(0xFFFD6C00), Color(0xFFFFA133)],
                text: "Sign In",
                onClickEventHandler: signIn,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
          ),
        ],
      ),
    );
  }
}
