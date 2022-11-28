import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/backgrounds/light_onboarding_background.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/text_fields/group_input_fields/group_input_form.dart';
import 'package:socale/components/text_fields/group_input_fields/group_input_form_field.dart';
import 'package:socale/components/text_fields/input_field/single_input_form.dart';
import 'package:socale/components/utils/keyboard_safe_area.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/resources/themes.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/utils/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  GlobalKey<FormState> formEmailKey = GlobalKey<FormState>();
  GlobalKey<FormState> formPinCodeKey = GlobalKey<FormState>();
  GlobalKey<FormState> formPasswordKey = GlobalKey<FormState>();

  GlobalKey<FormFieldState> emailFieldState = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> passwordFieldState = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> confirmPasswordFieldState = GlobalKey<FormFieldState>();

  PageController pageController = PageController();

  List<String> buttonText = ["Send Code", "Confirm Code", "Change Password", "Login"];
  List<LinearGradient> buttonBackground = [ColorValues.blackButtonGradient, ColorValues.orangeButtonGradient];

  bool formEmailError = false;
  String errorEmailMessage = "";

  bool formPasswordError = false;
  String errorPasswordMessage = "";

  String email = "";
  String password = "";
  String confirmPassword = "";
  String code = "";

  int pageIndex = 0;

  saveEmail(value) => email = value;
  savePassword(value) => password = value;
  saveConfirmPassword(value) => confirmPassword = value;
  saveCode(value) => code = value;

  Future<bool> onBack() async {
    if (pageIndex == 0) {
      return true;
    }

    setState(() {
      pageIndex--;
    });

    pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);

    return false;
  }

  void onNext() async {
    if (pageIndex == 3) {
      if (mounted) Navigator.pop(context);
      return;
    }

    if (pageIndex == 0) {
      final emailForm = formEmailKey.currentState!;
      if (emailForm.validate()) {
        setState(() => formEmailError = false);
        setState(() => errorEmailMessage = "");

        emailForm.save();
        AuthService.sendResetPasswordCode(email);
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        setState(() => pageIndex++);
        pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      } else {
        setState(() {
          formEmailError = true;
          errorEmailMessage = "Enter a valid email";
        });
        return;
      }
    }

    if (pageIndex == 1) {
      if (formPinCodeKey.currentState == null) {
        return;
      }

      final codeForm = formPinCodeKey.currentState!;
      if (codeForm.validate()) {
        codeForm.save();
      } else {
        return;
      }
    }

    if (pageIndex == 2) {
      final passwordForm = formPasswordKey.currentState!;
      if (passwordForm.validate()) {
        setState(() => formPasswordError = false);
        setState(() => errorPasswordMessage = "");

        passwordForm.save();

        if (password != confirmPassword) {
          print(password);
          print(confirmPassword);

          setState(() {
            formPasswordError = true;
            errorPasswordMessage = "Passwords don't match";
          });

          return;
        }

        try {
          await AuthService.confirmResetPassword(email, password, code);
          print("changed password");
        } on CodeMismatchException catch (e) {
          print(e);
          const snackBar = SnackBar(content: Text('Invalid one time code'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        } catch (e) {
          print(e);
          const snackBar = SnackBar(content: Text('Something went wrong try again in a few minutes.'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }

        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      } else {
        final passwordField = passwordFieldState.currentState!;
        final confirmPasswordField = confirmPasswordFieldState.currentState!;

        if (passwordField.errorText != null) {
          setState(() {
            formPasswordError = true;
            errorPasswordMessage = "Password must be at least 8 characters";
          });
        } else if (confirmPasswordField.errorText != null) {
          setState(() {
            formPasswordError = true;
            errorPasswordMessage = "Passwords don't match";
          });
        }
        return;
      }
    }

    setState(() => pageIndex++);
    pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: onBack,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const LightOnboardingBackground(),
            KeyboardSafeArea(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                reverse: true,
                child: SizedBox(
                  height: size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Image.asset('assets/forgot_password/cover_illustration.png'),
                        ),
                      ),
                      SizedBox(
                        height: 250,
                        width: size.width,
                        child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: pageController,
                          children: [
                            Column(
                              children: [
                                SimpleShadow(
                                  opacity: 0.1,
                                  offset: const Offset(1, 1),
                                  sigma: 1,
                                  child: Text(
                                    "Forgot Password?",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: (size.width * 0.058),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10, left: size.width * 0.10, right: size.width * 0.10, bottom: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Enter your email to receive an confirmation",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          fontSize: (size.width * 0.04),
                                          color: ColorValues.textSubtitle,
                                        ),
                                      ),
                                      Text(
                                        "code and reset your password.",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          fontSize: (size.width * 0.04),
                                          color: ColorValues.textSubtitle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05, top: 30),
                                  child: Form(
                                    key: formEmailKey,
                                    child: SingleInputForm(
                                      isError: formEmailError,
                                      errorMessage: errorEmailMessage,
                                      child: GroupInputFormField(
                                        key: emailFieldState,
                                        hintText: "Email Address",
                                        initialValue: email,
                                        textInputType: TextInputType.emailAddress,
                                        prefixIcon: SvgPicture.asset('assets/icons/email.svg', color: Color(0xFF808080), width: 16),
                                        onSaved: saveEmail,
                                        validator: Validators.validateEmail,
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SimpleShadow(
                                  opacity: 0.1,
                                  offset: const Offset(1, 1),
                                  sigma: 1,
                                  child: Text(
                                    "Forgot Password?",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: (size.width * 0.058),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10, left: size.width * 0.10, right: size.width * 0.10, bottom: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Enter the code that was sent to",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          fontSize: (size.width * 0.04),
                                          color: ColorValues.textSubtitle,
                                        ),
                                      ),
                                      Text(
                                        email,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          fontSize: (size.width * 0.04),
                                          color: ColorValues.textSubtitle,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 25),
                                  child: SizedBox(
                                    width: size.width * 0.8,
                                    child: Form(
                                      key: formPinCodeKey,
                                      child: PinCodeTextField(
                                        length: 6,
                                        useHapticFeedback: true,
                                        pinTheme: Themes.optPinTheme,
                                        cursorColor: Colors.black,
                                        hintCharacter: "0",
                                        animationType: AnimationType.none,
                                        autovalidateMode: AutovalidateMode.disabled,
                                        keyboardType: TextInputType.number,
                                        autoFocus: true,
                                        autoDismissKeyboard: true,
                                        appContext: context,
                                        errorTextSpace: 20,
                                        onSaved: saveCode,
                                        onChanged: (value) {},
                                        validator: Validators.validateCode,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SimpleShadow(
                                  opacity: 0.1,
                                  offset: const Offset(1, 1),
                                  sigma: 1,
                                  child: Text(
                                    "Forgot Password?",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: (size.width * 0.058),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10, left: size.width * 0.10, right: size.width * 0.10, bottom: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Change password for",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          fontSize: (size.width * 0.04),
                                          color: ColorValues.textSubtitle,
                                        ),
                                      ),
                                      Text(
                                        email,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.bold,
                                          fontSize: (size.width * 0.04),
                                          color: ColorValues.textSubtitle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05, top: 15),
                                  child: Form(
                                    key: formPasswordKey,
                                    child: GroupInputForm(
                                      isError: formPasswordError,
                                      errorMessage: errorPasswordMessage,
                                      children: [
                                        GroupInputFormField(
                                          key: passwordFieldState,
                                          hintText: "Password",
                                          initialValue: password,
                                          textInputType: TextInputType.visiblePassword,
                                          prefixIcon: SvgPicture.asset('assets/icons/lock.svg', color: Color(0xFF808080), width: 16),
                                          isObscured: true,
                                          onSaved: savePassword,
                                          validator: Validators.validatePassword,
                                          textInputAction: TextInputAction.done,
                                        ),
                                        GroupInputFormField(
                                          key: confirmPasswordFieldState,
                                          hintText: "Confirm Password",
                                          initialValue: confirmPassword,
                                          textInputType: TextInputType.visiblePassword,
                                          prefixIcon: SvgPicture.asset('assets/icons/lock.svg', color: Color(0xFF808080), width: 16),
                                          isObscured: true,
                                          onSaved: saveConfirmPassword,
                                          validator: Validators.validatePassword,
                                          textInputAction: TextInputAction.done,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Center(
                              child: Column(
                                children: [
                                  SimpleShadow(
                                    opacity: 0.1,
                                    offset: const Offset(1, 1),
                                    sigma: 1,
                                    child: Text(
                                      "Forgot Password?",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: (size.width * 0.058),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10, left: size.width * 0.10, right: size.width * 0.10, bottom: 20),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Your password for",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.roboto(
                                            fontSize: (size.width * 0.04),
                                            color: ColorValues.textSubtitle,
                                          ),
                                        ),
                                        Text(
                                          email,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.roboto(
                                            fontSize: (size.width * 0.04),
                                            color: ColorValues.textSubtitle,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "has been changed successfully, you can",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.roboto(
                                            fontSize: (size.width * 0.04),
                                            color: ColorValues.textSubtitle,
                                          ),
                                        ),
                                        Text(
                                          "login with your new password now.",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.roboto(
                                            fontSize: (size.width * 0.04),
                                            color: ColorValues.textSubtitle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 40 - MediaQuery.of(context).padding.bottom),
                        child: GradientButton(
                          width: size.width - 60,
                          height: 48,
                          linearGradient: buttonBackground[pageIndex == 3 ? 1 : 0],
                          buttonContent: Text(
                            buttonText[pageIndex],
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onClickEvent: onNext,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final result = await onBack();
                if (result) {
                  if (mounted) Navigator.pop(context);
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding: const EdgeInsets.only(left: 24, top: 60),
                child: SvgPicture.asset('assets/icons/back.svg'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
