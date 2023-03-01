import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/paginators/page_view_controller.dart';
import 'package:socale/navigation/transitions/curves.dart';
import 'package:socale/providers/state_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/services/auth_service.dart';

class IntroPage extends ConsumerStatefulWidget {
  final String illustration;
  final String titleBlack;
  final String titleOrange;
  final String message;

  final int pageNumber;
  final int totalPages;

  final PageController pageController;

  final Function setOverlay;
  final Function removeOverlay;

  const IntroPage({
    super.key,
    required this.illustration,
    required this.titleBlack,
    required this.titleOrange,
    required this.message,
    required this.pageController,
    required this.totalPages,
    required this.pageNumber,
    required this.setOverlay,
    required this.removeOverlay,
  });

  @override
  ConsumerState<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends ConsumerState<IntroPage> {
  bool showNav = false;

  bool overlayCreated = false;

  @override
  void initState() {
    super.initState();

    if (widget.pageNumber == 0) showNav = true;

    widget.pageController.addListener(() {
      if (widget.pageController.page! == widget.pageNumber) {
        widget.removeOverlay();
        overlayCreated = false;
        if (mounted) setState(() => showNav = true);
      } else {
        if (overlayCreated) return;
        overlayCreated = true;
        createOverlay();
        setState(() => showNav = false);
      }
    });
  }

  @override
  void dispose() {
    widget.removeOverlay();
    super.dispose();
  }

  next() {
    widget.pageController.nextPage(duration: const Duration(milliseconds: 300), curve: emphasized);
  }

  back(WidgetRef ref) {
    if (widget.pageNumber != 0) {
      widget.pageController
          .previousPage(duration: const Duration(milliseconds: 300), curve: emphasized);
    } else {
      AuthService.signOutUser();
      ref.read(appStateProvider.notifier).signOut();
    }
  }

  createOverlay() {
    final size = MediaQuery.of(context).size;
    final mediaQuery = MediaQuery.of(context);

    final overlay = OverlayEntry(
      builder: (context) => Positioned(
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
                    child: Container(),
                  ),
                  Visibility(
                    visible: !showNav,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: PageViewController(
                      currentPage: widget.pageController.page!.round(),
                      pageCount: widget.totalPages,
                      back: () {},
                      next: () {},
                      nextText: 'Next',
                      backText: widget.pageController.page!.round() == 0 ? 'Sign Out' : 'Back',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    widget.setOverlay(overlay);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Center(
            child: Image.asset(widget.illustration),
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SimpleShadow(
                opacity: 0.1,
                offset: const Offset(1, 1),
                sigma: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.titleBlack,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: size.width * 0.058,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [ColorValues.socaleDarkOrange, ColorValues.socaleOrange],
                      ).createShader(bounds),
                      child: Text(
                        widget.titleOrange,
                        style: GoogleFonts.poppins(
                            fontSize: size.width * 0.058,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 34),
                child: Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: (size.width * 0.036),
                    color: ColorValues.textSubtitle,
                  ),
                ),
              ),
            ],
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
            back: () => back(ref),
            next: next,
            nextText: 'Next',
            backText: widget.pageNumber == 0 ? 'Sign Out' : 'Back',
          ),
        )
      ],
    );
  }
}
