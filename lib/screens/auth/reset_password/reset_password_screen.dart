import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/buttons/icon_button.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/auth/reset_password/reset_password_code_view.dart';
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

  final List<LinearGradient> buttonBackground = [ColorValues.blackButtonGradient, ColorValues.orangeButtonGradient];

  int pageIndex = 0;

  String email = '';
  String password = '';

  bool isLoading = false;

  void saveEmail(String value) => email = value;

  void savePassword(String value) => password = value;

  Future<bool> onWillPop() async {
    if (isLoading) return false;
    if (pageIndex == 0) return true;
    return onBack();
  }

  void onNext() async {
    setState(() => isLoading = true);

    final views = ResetPasswordView.allResetPasswordViews(context);
    final result = await views.last.onNext();

    setState(() => isLoading = false);

    if (result) {
      if (pageIndex == buildPages().length - 1) return;
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => pageIndex++);
    }
  }

  Future<bool> onBack() async {
    if (isLoading) return false;

    pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() => pageIndex--);

    return false;
  }

  List<ResetPasswordView> buildPages() {
    return [
      ResetPasswordEmailView(saveEmail: saveEmail),
      ResetPasswordNewPassView(savePassword: savePassword, email: email),
      ResetPasswordCodeView(password: password, email: email),
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
                      onPressed: () => Navigator.of(context).pop(context),
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
