import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/screens/onboarding/email_verification/email_verification_header.dart';
import 'package:socale/screens/onboarding/email_verification/email_verification_pager.dart';
import 'package:socale/screens/onboarding/onboarding_screen.dart';
import 'package:socale/services/onboarding_service.dart';

class EmailVerificationPage extends ConsumerStatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<EmailVerificationPage> createState() =>
      _EmailVerificationPageState();
}

class _EmailVerificationPageState extends ConsumerState<EmailVerificationPage> {
  final _formPageController = PageController();
  final _formEmailKey = GlobalObjectKey<FormState>('email');
  final _formOtpKey = GlobalObjectKey<FormState>('otp');
  late PageController _pageController;

  String _email = "";

  @override
  void initState() {
    super.initState();
  }

  // onSaved Methods
  void _onEmailSaved(value) {
    setState(() => _email = value);
    onboardingService.generateOTPAndSendEmail(value);
  }

  void _onOtpSaved(value) async {
    await onboardingService.setSchoolEmail(_email);
    _pageController.nextPage(
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  //Click handler
  void _onClickEventHandler() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_formPageController.page == 0) {
      final form = _formEmailKey.currentState;
      final isValid = form != null ? form.validate() : false;
      if (isValid) {
        form.save();
        _formPageController.nextPage(
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    } else {
      final form = _formOtpKey.currentState;
      final isValid = form != null ? form.validate() : false;
      if (isValid) {
        form.save();
      }
    }
  }

  // onBack handler
  Future<bool> _willPopScope() async {
    if (_formPageController.page == 1) {
      _formPageController.previousPage(
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      return false;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    _pageController = ref.watch(onboardingPageController);

    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: _willPopScope,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            SingleChildScrollView(
              reverse: true,
              physics: NeverScrollableScrollPhysics(),
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: EmailVerificationHeader(),
                    ),
                    EmailVerificationPager(
                      pageController: _formPageController,
                      formEmailKey: _formEmailKey,
                      formOptKey: _formOtpKey,
                      onSavedEmail: _onEmailSaved,
                      onOtpSaved: _onOtpSaved,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 20 + MediaQuery.of(context).padding.bottom),
                      child: PrimaryButton(
                        width: size.width,
                        height: 60,
                        colors: [Color(0xFF2F3136), Color(0xFF2F3136)],
                        text: "Verify",
                        onClickEventHandler:
                            _onClickEventHandler, // onClickEventHandler,
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
