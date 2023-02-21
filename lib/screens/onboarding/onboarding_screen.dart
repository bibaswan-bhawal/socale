import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/buttons/link_button.dart';
import 'package:socale/components/paginators/page_paginator.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/navigation/transitions/curves.dart';
import 'package:socale/screens/onboarding/intro_pages/intro_one_page.dart';
import 'package:socale/screens/onboarding/intro_pages/intro_three_page.dart';
import 'package:socale/screens/onboarding/intro_pages/intro_two_page.dart';
import 'package:socale/utils/system_ui.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController pageController = PageController();

  late int currentPage;

  final List<Widget> pages = const [
    IntroOnePage(),
    IntroTwoPage(),
    IntroThreePage(),
  ];

  @override
  void initState() {
    super.initState();

    currentPage = pageController.initialPage;

    SystemUI.setSystemUIDark();

    pageController.addListener(() {
      if (currentPage != pageController.page!.round()) {
        setState(() {
          currentPage = pageController.page!.round();
        });
      }
    });
  }

  next() {
    if (currentPage < pages.length - 1) {
      pageController.nextPage(duration: const Duration(milliseconds: 500), curve: emphasized);
    }
  }

  back() {
    if (currentPage > 0) {
      pageController.previousPage(duration: const Duration(milliseconds: 300), curve: emphasized);
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
            padding: EdgeInsets.only(bottom: 40 - MediaQuery.of(context).viewPadding.bottom, left: 24, right: 24),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinkButton(
                  text: 'Back',
                  onPressed: back,
                  wrap: true,
                  visualFeedback: true,
                  textStyle: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: PagePaginator(
                    selectedPage: currentPage,
                    totalPages: pages.length,
                  ),
                ),
                LinkButton(
                  text: 'Next',
                  onPressed: next,
                  wrap: true,
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
