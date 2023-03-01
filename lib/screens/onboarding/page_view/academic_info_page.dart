import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/cards/chip_card_form_field.dart';
import 'package:socale/components/paginators/page_view_controller.dart';
import 'package:socale/models/onboarding_user.dart';
import 'package:socale/navigation/transitions/curves.dart';
import 'package:socale/options/majors/ucsd_majors.dart';
import 'package:socale/resources/colors.dart';

enum AcademicInfoPageType { major, minor }

class AcademicInfoPage extends ConsumerStatefulWidget {
  final OnboardingUser onboardingUser;
  final PageController pageController;
  final int pageNumber;
  final int totalPages;
  final Function setOverlay;
  final Function removeOverlay;
  final AcademicInfoPageType type;

  const AcademicInfoPage({
    super.key,
    required this.onboardingUser,
    required this.pageController,
    required this.pageNumber,
    required this.setOverlay,
    required this.removeOverlay,
    required this.totalPages,
    required this.type,
  });

  @override
  ConsumerState<AcademicInfoPage> createState() => AcademicInfoPageState();
}

class AcademicInfoPageState extends ConsumerState<AcademicInfoPage> {
  GlobalKey<FormState> majorFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> minorFormKey = GlobalKey<FormState>();

  List<String>? majors = [];
  List<String>? minors = [];

  bool showNav = true;
  bool showHeader = false;

  saveMajors(List<String>? value) => majors = value;

  saveMinors(List<String>? value) => minors = value;

  bool overlayCreated = false;

  @override
  void initState() {
    super.initState();

    majors = widget.onboardingUser.majors ?? [];
    minors = widget.onboardingUser.minors ?? [];

    widget.pageController.addListener(() {
      if (widget.pageController.page! > 4 && widget.pageController.page! < 5) {
        showHeader = false;
      } else {
        showHeader = true;
      }

      if (widget.pageController.page == widget.pageNumber) {
        widget.removeOverlay();
        overlayCreated = false;
        if (mounted) setState(() => showNav = true);
      } else {
        if (overlayCreated) return;
        overlayCreated = true;
        createOverlay();
        if (mounted) setState(() => showNav = false);
      }
    });
  }

  next() {
    widget.pageController.nextPage(duration: const Duration(milliseconds: 300), curve: emphasized);
  }

  back() {
    widget.pageController
        .previousPage(duration: const Duration(milliseconds: 300), curve: emphasized);
  }

  createOverlay() {
    final size = MediaQuery.of(context).size;
    final mediaQuery = MediaQuery.of(context);

    final overlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 0,
          left: 0,
          child: Material(
            type: MaterialType.transparency,
            child: SizedBox(
              height: size.height,
              width: size.width,
              child: Padding(
                padding: EdgeInsets.only(
                  top: mediaQuery.viewPadding.top,
                  bottom: mediaQuery.viewPadding.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Visibility(
                        visible: !showHeader,
                        child: const _Header(),
                      ),
                    ),
                    const SizedBox(height: 160),
                    PageViewController(
                      currentPage: widget.pageController.page!.round(),
                      pageCount: widget.totalPages,
                      back: () {},
                      next: () {},
                      nextText: 'Next',
                      backText: 'Back',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    widget.setOverlay(overlay);
  }

  bool validateMajor() {
    final form = majorFormKey.currentState!;

    if (form.validate()) {
      form.save();

      widget.onboardingUser.majors;
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Visibility(
            visible: showHeader,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: const _Header(),
          ),
        ),
        widget.type == AcademicInfoPageType.major
            ? Form(
                key: majorFormKey,
                child: ChipCardFormField(
                  emptyMessage: 'Add your major',
                  searchHint: 'Search for your major',
                  height: 160,
                  horizontalPadding: 30,
                  options: ucsdMajors,
                  initialValue: majors,
                  onSaved: saveMajors,
                ),
              )
            : Form(
                key: minorFormKey,
                child: ChipCardFormField(
                  emptyMessage: 'Add your minor',
                  searchHint: 'Search for your minor',
                  height: 160,
                  horizontalPadding: 30,
                  options: ucsdMajors,
                  initialValue: minors,
                  onSaved: saveMinors,
                ),
              ),
        Visibility(
          visible: showNav,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: PageViewController(
            currentPage: widget.pageNumber,
            pageCount: widget.totalPages,
            back: back,
            next: next,
            nextText: 'Next',
            backText: 'Back',
          ),
        )
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: size.height * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SimpleShadow(
                opacity: 0.1,
                offset: const Offset(1, 1),
                sigma: 1,
                child: Text(
                  'let\'s find you some ',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: size.width * 0.058,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SimpleShadow(
                opacity: 0.1,
                offset: const Offset(1, 1),
                sigma: 1,
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [ColorValues.socaleDarkOrange, ColorValues.socaleOrange],
                  ).createShader(bounds),
                  child: Text(
                    'classmates',
                    style: GoogleFonts.poppins(
                        fontSize: size.width * 0.058,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Image.asset('assets/illustrations/onboarding_intro/cover_page_4.png'),
          ),
        ),
      ],
    );
  }
}
