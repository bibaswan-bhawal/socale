import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:animations/animations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/ButtonGroups/SocialSignInButtonGroup.dart';
import 'package:socale/components/Buttons/primary_loading_button.dart';
import 'package:socale/components/Dividers/signInDivider.dart';
import 'package:socale/components/Headers/login_header.dart';
import 'package:socale/components/TextFields/singleLineTextField/form_text_field.dart';
import 'package:get/get.dart';
import 'package:socale/components/snackbar/auth_snackbars.dart';
import 'package:socale/screens/auth_screen/register_screen/verify_email.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/enums/onboarding_fields.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/utils/validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final Function() back;

  const LoginScreen({Key? key, required this.back}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = "", _password = "";
  bool isLoading = false;

  updateEmail(value) => setState(() => _email = value);
  updatePassword(value) => setState(() => _password = value);

  // Handlers
  void emailSignInHandler() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!isLoading) {
      // Validate input data and try signing in
      final form = _formKey.currentState;
      final isValid = form != null ? form.validate() : false;

      if (isValid) {
        form.save();
        setState(() => isLoading = true);
        trySignIn();
      } else {
        setState(() => isLoading = false);
      }
    }
  }

  // Navigators
  void goToVerifySignUpEmail() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => VerifyEmailScreen(
          email: _email,
          password: _password,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
      ),
    );
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
      Get.offAllNamed('/onboarding');
      return;
    }
  }

  void trySignIn() async {
    try {
      final result = await authService.signIn(_email, _password); // try signing in user.

      if (result.nextStep?.signInStep == "CONFIRM_SIGN_UP") {
        goToVerifySignUpEmail(); // user exists but isn't verified navigate to verify email page
      } else {
        userDataLoader(result.isSignedIn); // user is signed in load data
      }
    } on NotAuthorizedException catch (_) {
      setState(() => isLoading = false);
      authSnackBar.userNotAuthorizedSnackBar(context);
    } on UserNotFoundException catch (_) {
      setState(() => isLoading = false);
      authSnackBar.userNotFoundSnackBar(context);
    } on AuthException catch (_) {
      setState(() => isLoading = false);
      authSnackBar.defaultErrorMessageSnack(context);
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

  socialSignInHandler(AuthProvider oAuth) async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        widget.back();
        return false;
      },
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(15, 30, 0, 0),
            child: IconButton(
              onPressed: widget.back,
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LoginHeader(),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: SizedBox(
                            height: 80,
                            child: FormTextField(
                              hint: "Email Address",
                              autoFillHints: {'email', 'email address'},
                              icon: "assets/icons/email_icon.svg",
                              onSave: updateEmail,
                              validator: (value) {
                                return Validators.validateEmail(value);
                              },
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: SizedBox(
                            height: 80,
                            child: FormTextField(
                              hint: "Password",
                              autoFillHints: {'password'},
                              icon: "assets/icons/lock_icon.svg",
                              obscureText: true,
                              onSave: updatePassword,
                              validator: Validators.validatePassword,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(70, 0, 70, 0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Forgot Password',
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.3),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => {
                                          // implement onClick
                                        },
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: PrimaryLoadingButton(
                            isLoading: isLoading,
                            width: size.width,
                            height: 60,
                            colors: [Color(0xFFFD6C00), Color(0xFFFFA133)],
                            text: "Login",
                            onClickEventHandler: () => {emailSignInHandler()},
                          ),
                        ),
                      ],
                    ),
                  ),
                  SignInDivider(),
                  SocialSignInButtonGroup(
                    handler: socialSignInHandler,
                    text: "Sign In",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
