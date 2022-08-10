import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socale/screens/onboarding/email_verification_screen/email_verification_header.dart';
import 'package:socale/screens/onboarding/email_verification_screen/email_verification_pager.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/translucent_background/translucent_background.dart';
import 'package:socale/services/onboarding_service.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final formEmailKey = GlobalObjectKey<FormState>('email');
  final formCodeKey = GlobalObjectKey<FormState>('code');
  final pageController = PageController();

  String _email = "";

  @override
  Widget build(BuildContext context) {
    onClickEventHandler() {
      if (pageController.page == 0) {
        final form = formEmailKey.currentState;
        final isValid = form != null ? form.validate() : false;
        if (isValid) {
          form.save();
          pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      } else {
        final form = formCodeKey.currentState;
        final isValid = form != null ? form.validate() : false;
        if (isValid) {
          form.save();
        }
      }
    }

    onSavedEmail(value) {
      setState(() => _email = value);
      onboardingService.generateOTPAndSendEmail(value!);
    }

    onSavedCode(value) async {
      await onboardingService.setSchoolEmail(_email);
      Get.offAllNamed('/onboarding');
    }

    Future<bool> _willPopScope() async {
      if (pageController.page == 1) {
        pageController.previousPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        return false;
      } else {
        return true;
      }
    }

    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: _willPopScope,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            TranslucentBackground(),
            SafeArea(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                reverse: true,
                child: Column(
                  children: [
                    EmailVerificationHeader(size: size),
                    EmailVerificationPager(
                      formEmailKey: formEmailKey,
                      formCodeKey: formCodeKey,
                      pageController: pageController,
                      onSavedEmail: onSavedEmail,
                      onSavedCode: onSavedCode,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 25),
                      child: PrimaryButton(
                        width: size.width,
                        height: 60,
                        colors: [Color(0xFF2F3136), Color(0xFF2F3136)],
                        text: "Verify",
                        onClickEventHandler: onClickEventHandler,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
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
