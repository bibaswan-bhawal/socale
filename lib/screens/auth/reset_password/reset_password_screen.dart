import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/buttons/icon_button.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/auth/reset_password/reset_password_code_view.dart';
import 'package:socale/screens/auth/reset_password/reset_password_complete_view.dart';
import 'package:socale/screens/auth/reset_password/reset_password_email_view.dart';
import 'package:socale/screens/auth/reset_password/reset_password_new_pass_view.dart';
import 'package:socale/screens/auth/reset_password/reset_password_view.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final PageController pageController = PageController();

  final List<LinearGradient> buttonBackground = [
    ColorValues.blackButtonGradient,
    ColorValues.orangeButtonGradient,
  ];

  late String email;
  late String tempPassword;

  int pageIndex = 0;

  bool isLoading = false;

  void saveEmail(String value) => email = value;

  void saveTempPassword(String value) => tempPassword = value;

  Future<bool> onWillPop() async {
    if (isLoading) return false;
    if (pageIndex == 0) return true;

    await onBack();
    return false;
  }

  Future<void> onNext() async {
    setState(() => isLoading = true);

    final views = ResetPasswordView.allResetPasswordViews(context);
    final result = await views.last.onNext();

    setState(() => isLoading = false);

    if (!result) return;

    FocusManager.instance.primaryFocus?.unfocus();

    pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() => pageIndex++);
  }

  Future<void> onBack() async {
    if (isLoading) return;

    final views = ResetPasswordView.allResetPasswordViews(context);
    final result = await views.last.onBack();

    if (!result) return;

    FocusManager.instance.primaryFocus?.unfocus();

    pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() => pageIndex--);
  }

  List<ResetPasswordView> buildPages() {
    return [
      ResetPasswordEmailView(saveEmail: saveEmail),
      ResetPasswordCodeView(tempPassword: saveTempPassword, email: email),
      ResetPasswordNewPassView(tempPassword: tempPassword, email: email),
      ResetPasswordCompleteView(email: email)
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          reverse: true,
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30, top: 24 + MediaQuery.of(context).viewPadding.top),
                    child: RippleIconButton(
                      onPressed: () => Navigator.of(context).maybePop(context),
                      icon: SvgPicture.asset('assets/icons/back.svg'),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width,
                  height: size.width,
                  child: Center(
                    child: Image.asset('assets/illustrations/illustration_7.png'),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: PageView(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: buildPages(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 40, right: 36, left: 36),
                  child: GradientButton(
                    onPressed: onNext,
                    isLoading: isLoading,
                    text: 'Continue',
                    linearGradient: buttonBackground[pageIndex == 3 ? 1 : 0],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}