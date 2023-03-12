import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/providers/model_providers.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/onboarding/verify_college/verify_college_code_page.dart';
import 'package:socale/screens/onboarding/verify_college/verify_college_email_page.dart';
import 'package:socale/transitions/curves.dart';

class VerifyCollegeScreen extends ConsumerStatefulWidget {
  const VerifyCollegeScreen({super.key});

  @override
  ConsumerState<VerifyCollegeScreen> createState() => _VerifyCollegeScreenState();
}

class _VerifyCollegeScreenState extends ConsumerState<VerifyCollegeScreen> {
  final PageController pageController = PageController();

  final Duration timerDuration = const Duration(seconds: 150);

  String? email;

  Timer? countdownTimer;

  int currentPage = 0;

  late Duration timeLeft;

  @override
  void initState() {
    super.initState();
    timeLeft = timerDuration;
  }

  saveEmail(String? email) => setState(() => this.email = email);

  void setCountDown() {
    setState(() {
      final seconds = timeLeft.inSeconds - 1;

      if (seconds < 0) {
        timeLeft = timerDuration;
        countdownTimer!.cancel();
      } else {
        timeLeft = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    countdownTimer?.cancel();
    timeLeft = timerDuration;
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
    setCountDown();
    setState(() {});
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  next() {
    // user verified as student
    if (pageController.page == 1) {
      ref.read(onboardingUserProvider.notifier).setCollegeEmail(collegeEmail: email!);
    }

    // go to code page
    pageController.nextPage(duration: const Duration(milliseconds: 500), curve: emphasized);
    setState(() => currentPage = (currentPage + 1).clamp(0, 1));
  }

  back() {
    if (currentPage == 0) return ref.read(authServiceProvider).signOutUser();

    pageController.previousPage(duration: const Duration(milliseconds: 500), curve: emphasized);
    setState(() => currentPage = (currentPage - 1).clamp(0, 1));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
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
                  padding: EdgeInsets.only(left: 25, top: 24 + MediaQuery.of(context).viewPadding.top),
                  child: SizedBox(
                    height: 28,
                    child: InkResponse(
                      radius: 20,
                      splashFactory: InkRipple.splashFactory,
                      onTap: back,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: currentPage == 0
                            ? Text(
                                'Sign Out',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: ColorValues.socaleOrange,
                                ),
                              )
                            : SvgPicture.asset('assets/icons/back.svg', width: 28, height: 28, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: size.width,
                height: size.width,
                child: Center(
                  child: Image.asset('assets/illustrations/illustration_6.png'),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    VerifyCollegeEmailPage(
                      email: email,
                      next: next,
                      timerDuration: timeLeft,
                      saveEmail: saveEmail,
                      startTimer: startTimer,
                    ),
                    VerifyCollegeCodePage(
                      next: next,
                      email: email,
                      timerDuration: timeLeft,
                      startTimer: startTimer,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
