import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/buttons/action_group.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/text_fields/form_fields/text_input_form_field.dart';
import 'package:socale/components/text_fields/input_forms/default_input_form.dart';
import 'package:socale/components/utils/screen_safe_area.dart';
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

  List<String> buttonText = ['Send Code', 'Confirm Code', 'Change Password', 'Login'];
  List<LinearGradient> buttonBackground = [
    ColorValues.blackButtonGradient,
    ColorValues.orangeButtonGradient
  ];

  String? errorEmailMessage;
  String? errorPasswordMessage;

  bool isLoading = false;

  String email = '';
  String password = '';
  String confirmPassword = '';
  String code = '';

  int pageIndex = 0;

  saveEmail(value) => email = value;

  savePassword(value) => password = value;

  saveConfirmPassword(value) => confirmPassword = value;

  saveCode(value) => code = value;

  Future<bool> onBack() async {
    if (pageIndex == 0) return true;
    if (pageIndex == 3) return false;

    setState(() => pageIndex--);

    pageController.animateToPage(pageIndex,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

    return false;
  }

  void onNext() async {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

    if (pageIndex == 3) {
      if (mounted) Navigator.pop(context);
      return;
    }

    if (pageIndex == 0) {
      final emailForm = formEmailKey.currentState!;
      if (emailForm.validate()) {
        setState(() => errorEmailMessage = null);

        emailForm.save();
        AuthService.sendResetPasswordCode(email);
        setState(() => pageIndex++);
        pageController.animateToPage(pageIndex,
            duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      } else {
        setState(() => errorEmailMessage = 'Enter a valid email');
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
      setState(() => isLoading = true);
      final passwordForm = formPasswordKey.currentState!;
      if (passwordForm.validate()) {
        setState(() => errorPasswordMessage = null);

        passwordForm.save();

        if (password != confirmPassword) {
          setState(() => errorPasswordMessage = "Passwords don't match");

          return;
        }

        try {
          await AuthService.confirmResetPassword(email, password, code);
        } on CodeMismatchException catch (_) {
          const snackBar =
              SnackBar(content: Text('Invalid one time code', textAlign: TextAlign.center));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        } catch (_) {
          const snackBar = SnackBar(
              content: Text('Something went wrong try again in a few minutes.',
                  textAlign: TextAlign.center));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }

        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      } else {
        final passwordField = passwordFieldState.currentState!;
        final confirmPasswordField = confirmPasswordFieldState.currentState!;

        if (passwordField.errorText != null) {
          setState(() => errorPasswordMessage = 'Password must be at least 8 characters');
        } else if (confirmPasswordField.errorText != null) {
          setState(() => errorPasswordMessage = "Passwords don't match");
        }
        return;
      }

      setState(() => isLoading = false);
    }

    setState(() => pageIndex++);
    pageController.animateToPage(pageIndex,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: onBack,
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              reverse: true,
              child: ScreenSafeArea(
                body: Column(
                  children: [
                    Visibility(
                      visible: pageIndex != 3,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 30,
                            top: 50 + MediaQuery.of(context).viewPadding.top,
                          ),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: InkResponse(
                              radius: 20,
                              splashFactory: InkRipple.splashFactory,
                              child: SvgPicture.asset('assets/icons/back.svg', fit: BoxFit.fill),
                              onTap: () => Navigator.maybePop(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Image.asset(
                            'assets/illustrations/forgot_password/cover_illustration.png')),
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      height: pageIndex != 3 ? 260 : 150,
                      width: size.width,
                      child: PageView(
                        controller: pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Column(
                            children: [
                              SimpleShadow(
                                opacity: 0.1,
                                offset: const Offset(1, 1),
                                sigma: 1,
                                child: Text(
                                  'Forgot Password?',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: (size.width * 0.058),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 20),
                                child: Column(
                                  children: [
                                    Text(
                                      'Enter your email to receive a confirmation',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                        fontSize: (size.width * 0.038),
                                        color: ColorValues.textSubtitle,
                                      ),
                                    ),
                                    Text(
                                      'code and reset your password.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                        fontSize: (size.width * 0.038),
                                        color: ColorValues.textSubtitle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                                child: Form(
                                  key: formEmailKey,
                                  child: DefaultInputForm(
                                    errorMessage: errorEmailMessage,
                                    children: [
                                      TextInputFormField(
                                        key: emailFieldState,
                                        hintText: 'Email Address',
                                        initialValue: email,
                                        textInputType: TextInputType.emailAddress,
                                        autofillHints: const [AutofillHints.email],
                                        prefixIcon: SvgPicture.asset(
                                          'assets/icons/email.svg',
                                          colorFilter: const ColorFilter.mode(
                                            Color(0xFF808080),
                                            BlendMode.srcIn,
                                          ),
                                          width: 16,
                                        ),
                                        onSaved: saveEmail,
                                        validator: Validators.validateEmail,
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ],
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
                                  'Reset Code',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: (size.width * 0.058),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 20),
                                child: Column(
                                  children: [
                                    Text(
                                      'Enter the code that was sent to',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                        fontSize: (size.width * 0.038),
                                        color: ColorValues.textSubtitle,
                                      ),
                                    ),
                                    Text(
                                      email,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                        fontSize: (size.width * 0.038),
                                        color: ColorValues.textSubtitle,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 25, left: 50, right: 50),
                                child: SizedBox(
                                  width: 300,
                                  child: Form(
                                    key: formPinCodeKey,
                                    child: PinCodeTextField(
                                      length: 6,
                                      appContext: context,
                                      useHapticFeedback: true,
                                      pinTheme: Themes.optPinTheme,
                                      cursorColor: Colors.black,
                                      hintCharacter: '0',
                                      autovalidateMode: AutovalidateMode.disabled,
                                      keyboardType: TextInputType.number,
                                      autoFocus: true,
                                      autoDismissKeyboard: true,
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
                                  'New Password',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: (size.width * 0.058),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 20),
                                child: Column(
                                  children: [
                                    Text(
                                      'Change password for',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                        fontSize: (size.width * 0.038),
                                        color: ColorValues.textSubtitle,
                                      ),
                                    ),
                                    Text(
                                      email,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontSize: (size.width * 0.038),
                                        color: ColorValues.textSubtitle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
                                child: Form(
                                  key: formPasswordKey,
                                  child: DefaultInputForm(
                                    errorMessage: errorPasswordMessage,
                                    children: [
                                      TextInputFormField(
                                        key: passwordFieldState,
                                        hintText: 'New Password',
                                        initialValue: password,
                                        textInputType: TextInputType.visiblePassword,
                                        textInputAction: TextInputAction.next,
                                        autofillHints: const [AutofillHints.password],
                                        prefixIcon: SvgPicture.asset(
                                          'assets/icons/lock.svg',
                                          colorFilter: const ColorFilter.mode(
                                            Color(0xFF808080),
                                            BlendMode.srcIn,
                                          ),
                                          width: 16,
                                        ),
                                        isObscured: true,
                                        onSaved: savePassword,
                                        validator: Validators.validatePassword,
                                      ),
                                      TextInputFormField(
                                        key: confirmPasswordFieldState,
                                        hintText: 'Confirm Password',
                                        initialValue: confirmPassword,
                                        textInputType: TextInputType.visiblePassword,
                                        textInputAction: TextInputAction.done,
                                        autofillHints: const [AutofillHints.password],
                                        prefixIcon: SvgPicture.asset(
                                          'assets/icons/lock.svg',
                                          colorFilter: const ColorFilter.mode(
                                            Color(0xFF808080),
                                            BlendMode.srcIn,
                                          ),
                                          width: 16,
                                        ),
                                        isObscured: true,
                                        onSaved: saveConfirmPassword,
                                        validator: Validators.validatePassword,
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
                                    'Successfully Changed!',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: (size.width * 0.058),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Your password for',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          fontSize: (size.width * 0.038),
                                          color: ColorValues.textSubtitle,
                                        ),
                                      ),
                                      Text(
                                        email,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          fontSize: (size.width * 0.038),
                                          color: ColorValues.textSubtitle,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'has been changed successfully, you can',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          fontSize: (size.width * 0.04),
                                          color: ColorValues.textSubtitle,
                                        ),
                                      ),
                                      Text(
                                        'login with your new password now.',
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
                      padding: EdgeInsets.only(
                          top: 10, bottom: 40 - MediaQuery.of(context).viewPadding.bottom),
                      child: ActionGroup(
                        actions: [
                          GradientButton(
                            onPressed: onNext,
                            isLoading: isLoading,
                            text: buttonText[pageIndex],
                            linearGradient: buttonBackground[pageIndex == 3 ? 1 : 0],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
