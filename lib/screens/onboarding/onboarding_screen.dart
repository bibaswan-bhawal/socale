import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/buttons/link_button.dart';
import 'package:socale/components/paginators/page_paginator.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/models/onboarding_user.dart';
import 'package:socale/navigation/transitions/curves.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/onboarding/academic_info_page.dart';
import 'package:socale/screens/onboarding/basic_info_page.dart';
import 'package:socale/screens/onboarding/intro_page.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/utils/system_ui.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController pageController = PageController();
  final OnboardingUser onboardingUser = OnboardingUser();

  final GlobalKey<BasicInfoPageState> basicInfoPageKey = GlobalKey<BasicInfoPageState>();
  final GlobalKey<AcademicInfoPageState> academicInfoPageKey = GlobalKey<AcademicInfoPageState>();

  late int currentPage;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();

    currentPage = pageController.initialPage;

    pages = [
      const IntroPage(
        illustration: 'assets/illustrations/onboarding_intro/cover_page_1.png',
        titleBlack: 'Welcome to ',
        titleOrange: 'Socale',
        message: 'Looking for classmates or just trying to\n'
            'keep up with clubs and events? You can\n'
            'do it all on Socale. The all-in-one college\n'
            'app for students, made by students!',
      ),
      const IntroPage(
        illustration: 'assets/illustrations/onboarding_intro/cover_page_2.png',
        titleBlack: 'Made for ',
        titleOrange: 'you',
        message: 'Every day we will recommend 5 people who\n'
            'we think you will find interesting based on\n'
            'your profile. The more you use the app, the\n'
            'better your recommendations will be.',
      ),
      const IntroPage(
        illustration: 'assets/illustrations/onboarding_intro/cover_page_3.png',
        titleBlack: 'One more ',
        titleOrange: 'thing...',
        message: 'The best part about Socale is that you are \n'
            'completely anonymous. You have the ability\n'
            'to choose who can see your profile and we \n'
            'will never share your personal information\n'
            'with anyone without your permission.',
      ),
      BasicInfoPage(
        key: basicInfoPageKey,
        onboardingUser: onboardingUser,
      ),
      AcademicInfoPage(
        key: academicInfoPageKey,
        onboardingUser: onboardingUser,
      ),
    ];

    SystemUI.setSystemUIDark();

    pageController.addListener(() => currentPage != pageController.page!.round()
        ? setState(() => currentPage = pageController.page!.round())
        : null);
  }

  next() {
    if (currentPage == 3) {
      if (!basicInfoPageKey.currentState!.validateForm()) {
        return;
      }
    }

    if (currentPage == 4) {
      setState(() => currentPage++);
      academicInfoPageKey.currentState?.next();
      return;
    }

    if (currentPage < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: emphasized,
      );
    }
  }

  changePage(int page) {
    setState(() => currentPage = currentPage + page);
  }

  back() {
    if (currentPage == 5) {
      setState(() => currentPage--);
      academicInfoPageKey.currentState?.previous();
      return;
    }

    if (currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: emphasized,
      );
    } else {
      AuthService.signOutUser();
      ref.read(appStateProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: pages,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: 40 - MediaQuery.of(context).viewPadding.bottom,
              left: 36,
              right: 36,
              top: 36,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinkButton(
                  text: currentPage == 0 ? 'Sign Out' : 'Back',
                  onPressed: back,
                  wrap: true,
                  width: 64,
                  visualFeedback: true,
                  textStyle: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: currentPage == 0 ? ColorValues.socaleOrange : Colors.black,
                  ),
                ),
                Expanded(
                  child: PagePaginator(
                    selectedPage: currentPage,
                    totalPages: pages.length + 1,
                  ),
                ),
                LinkButton(
                  text: 'Next',
                  onPressed: next,
                  wrap: true,
                  width: 64,
                  visualFeedback: true,
                  textStyle: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
