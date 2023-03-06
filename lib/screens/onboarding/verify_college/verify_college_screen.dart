import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/navigation/transitions/curves.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/onboarding/verify_college/verify_college_code_page.dart';
import 'package:socale/screens/onboarding/verify_college/verify_college_email_page.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/services/email_verification_service.dart';

class VerifyCollegeScreen extends ConsumerStatefulWidget {
  final Function() onComplete;

  const VerifyCollegeScreen({super.key, required this.onComplete});

  @override
  ConsumerState<VerifyCollegeScreen> createState() => _VerifyCollegeScreenState();
}

class _VerifyCollegeScreenState extends ConsumerState<VerifyCollegeScreen> {
  final PageController pageController = PageController();

  String? email;

  int currentPage = 0;

  next() {
    if (pageController.page == 1) {
      widget.onComplete();
    }

    pageController.nextPage(duration: const Duration(milliseconds: 500), curve: emphasized);
    setState(() {
      currentPage = (currentPage + 1).clamp(0, 1);
    });
  }

  back() {
    if (currentPage == 0) {
      AuthService.signOutUser();
      ref.read(appStateProvider.notifier).signOut();
      return;
    }

    pageController.previousPage(duration: const Duration(milliseconds: 500), curve: emphasized);

    setState(() {
      currentPage = (currentPage - 1).clamp(0, 1);
    });
  }

  saveEmail(String? email) {
    setState(() => this.email = email);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        physics: MediaQuery.of(context).padding.bottom == 0 ? null : const NeverScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 30, top: 24 + MediaQuery.of(context).viewPadding.top),
                  child: SizedBox(
                    height: 24,
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
                            : SvgPicture.asset('assets/icons/back.svg', fit: BoxFit.fill),
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
                      saveEmail: saveEmail,
                    ),
                    VerifyCollegeCodePage(
                      next: next,
                      email: email,
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
