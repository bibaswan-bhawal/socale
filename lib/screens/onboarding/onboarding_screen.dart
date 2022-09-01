import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/translucent_background/translucent_background.dart';
import 'package:socale/screens/onboarding/basic_info_page.dart';
import 'package:socale/screens/onboarding/email_verification/email_verification_page.dart';
import 'package:socale/screens/onboarding/get_started_page.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/providers/providers.dart';

final onboardingPageController = Provider((_) => PageController());

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late PageController _pageController;
  bool resize = true;
  bool isSchoolEmail = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
      );
    } else if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark));
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    changePage();
  }

  changePage() {
    final prov = ref.watch(userAttributesAsyncController);
    prov.whenData((value) {
      final email = value.where((element) => element.userAttributeKey == CognitoUserAttributeKey.email).first.value;
      if (email.contains("ucsd.edu")) {
        setState(() => isSchoolEmail = true);
        onboardingService.setSchoolEmail(email);
      }
    });
  }

  onPageChange(page) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (page == 0) {
      setState(() => resize = true);
      return;
    }

    setState(() => resize = false);
    return;
  }

  Future<bool> _willPopScope() async {
    if (_pageController.page != 0) {
      _pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _pageController = ref.watch(onboardingPageController);
    return WillPopScope(
      onWillPop: _willPopScope,
      child: Scaffold(
        resizeToAvoidBottomInset: resize,
        body: Stack(
          children: [
            TranslucentBackground(),
            SafeArea(
              child: PageView(
                controller: _pageController,
                onPageChanged: onPageChange,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  if (!isSchoolEmail) EmailVerificationPage(),
                  GetStartPage(),
                  BasicInfoPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
