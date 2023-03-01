import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/models/onboarding_user.dart';
import 'package:socale/screens/onboarding/onboarding_strings.dart';
import 'package:socale/screens/onboarding/page_view/academic_info_page.dart';
import 'package:socale/screens/onboarding/page_view/basic_info_page.dart';
import 'package:socale/screens/onboarding/page_view/intro_page.dart';
import 'package:socale/utils/system_ui.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController pageController = PageController();
  final OnboardingUser onboardingUser = OnboardingUser();

  final int totalPageCount = 6;

  OverlayEntry? overlayEntry;

  late List<Widget> pages;

  createOverlay(OverlayEntry entry) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    setState(() => overlayEntry = entry);
    overlayState.insert(overlayEntry!);
  }

  removeOverlay() {
    if (overlayEntry == null) return;
    overlayEntry!.remove();
    setState(() => overlayEntry = null);
  }

  @override
  void initState() {
    super.initState();

    pageController.addListener(() {
      Overlay.of(context).setState(() {});
    });

    pages = [
      IntroPage(
        illustration: 'assets/illustrations/onboarding_intro/cover_page_1.png',
        titleBlack: OnboardingStrings.introPage1TitleBlack,
        titleOrange: OnboardingStrings.introPage1TitleOrange,
        message: OnboardingStrings.introPage1Message,
        pageNumber: 0,
        totalPages: totalPageCount,
        pageController: pageController,
        setOverlay: createOverlay,
        removeOverlay: removeOverlay,
      ),
      IntroPage(
        illustration: 'assets/illustrations/onboarding_intro/cover_page_2.png',
        titleBlack: OnboardingStrings.introPage2TitleBlack,
        titleOrange: OnboardingStrings.introPage2TitleOrange,
        message: OnboardingStrings.introPage2Message,
        pageNumber: 1,
        totalPages: totalPageCount,
        pageController: pageController,
        setOverlay: createOverlay,
        removeOverlay: removeOverlay,
      ),
      IntroPage(
        illustration: 'assets/illustrations/onboarding_intro/cover_page_3.png',
        titleBlack: OnboardingStrings.introPage3TitleBlack,
        titleOrange: OnboardingStrings.introPage3TitleOrange,
        message: OnboardingStrings.introPage3Message,
        pageNumber: 2,
        totalPages: totalPageCount,
        pageController: pageController,
        setOverlay: createOverlay,
        removeOverlay: removeOverlay,
      ),
      BasicInfoPage(
        onboardingUser: onboardingUser,
        pageNumber: 3,
        totalPages: totalPageCount,
        pageController: pageController,
        setOverlay: createOverlay,
        removeOverlay: removeOverlay,
      ),
      AcademicInfoPage(
        onboardingUser: onboardingUser,
        pageController: pageController,
        pageNumber: 4,
        totalPages: totalPageCount,
        setOverlay: createOverlay,
        removeOverlay: removeOverlay,
        type: AcademicInfoPageType.major,
      ),
      AcademicInfoPage(
        onboardingUser: onboardingUser,
        pageController: pageController,
        pageNumber: 5,
        totalPages: totalPageCount,
        setOverlay: createOverlay,
        removeOverlay: removeOverlay,
        type: AcademicInfoPageType.minor,
      ),
    ];

    SystemUI.setSystemUIDark();
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
        ],
      ),
    );
  }
}
