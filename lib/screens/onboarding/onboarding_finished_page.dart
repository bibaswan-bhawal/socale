import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/Buttons/primary_button_single_color.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/components/nest_will_pop_scope.dart';
import 'package:socale/components/snackbar/onboarding_snackbars.dart';
import 'package:socale/screens/onboarding/onboarding_screen.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/values/colors.dart';

class OnboardingFinishedPage extends ConsumerStatefulWidget {
  const OnboardingFinishedPage({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingFinishedPage> createState() => _OnboardingFinishedPageState();
}

class _OnboardingFinishedPageState extends ConsumerState<OnboardingFinishedPage> with SingleTickerProviderStateMixin {
  Animation<double>? containerAnimation;
  AnimationController? containerAnimationController;
  late PageController _pageController;

  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    onboardingService.createOnboardedUser().then((isSuccess) {
      if (isSuccess) {
        onboardingService.generateMatches().then((isSuccess) {
          if (isSuccess) {
            onCallback();
          } else {
            onboardingSnackBar.errorCreatingUserSnack(context);
          }
        });
      } else {
        onboardingSnackBar.errorCreatingUserSnack(context);
      }
    });
  }

  void _onEventClickHandler() {
    print("Onboarding complete");
    Get.offAllNamed('/main');
  }

  Future<bool> _onBackPress() async {
    _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    return false;
  }

  void onCallback() {
    final size = MediaQuery.of(context).size;

    containerAnimationController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    containerAnimation = Tween<double>(begin: 0, end: size.height).animate(containerAnimationController!)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _isVisible = true);
        }
      })
      ..addListener(() {
        setState(() {});
      });
    containerAnimationController?.forward();
  }

  @override
  void dispose() {
    containerAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pageController = ref.watch(onboardingPageController);

    final size = MediaQuery.of(context).size;

    return NestedWillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        body: Stack(
          children: [
            KeyboardSafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 90, left: 35, right: 35),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'We are finding your ',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'Matches...',
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()..shader = ColorValues.socaleOrangeGradient,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Image.asset('assets/images/onboarding_uploading_animation.gif', width: 300),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: SizedBox(
                        height: 200,
                        width: size.width,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            viewportFraction: 1,
                            autoPlayInterval: Duration(seconds: 5),
                          ),
                          items: [
                            SizedBox(
                              width: size.width * 0.8,
                              child: Text(
                                "Did you know? UCSD is one of the most LGBTQ-friendly universities in the nation!",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: ColorValues.elementColor.withOpacity(0.7),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.8,
                              child: Text(
                                "Fun Fact! Students can grow organic vegetables and herbs at six community gardens on campus.",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: ColorValues.elementColor.withOpacity(0.7),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.8,
                              child: Text(
                                "Sustainability is huge in UCSD. From Solar hot water heating to rooftop gardens and sea breeze ventilation.",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: ColorValues.elementColor.withOpacity(0.7),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: size.width,
                height: containerAnimation != null ? containerAnimation!.value : 0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [ColorValues.socaleOrange, ColorValues.socaleDarkOrange],
                  ),
                ),
              ),
            ),
            KeyboardSafeArea(
              child: Stack(
                children: [
                  AnimatedOpacity(
                    opacity: _isVisible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 300),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: size.height * 0.1, left: size.width * 0.1, right: size.width * 0.1),
                        width: size.width,
                        child: Text(
                          "Get Ready to Match",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 48,
                            color: ColorValues.textOnDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: AnimatedOpacity(
                      opacity: _isVisible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 300),
                      child: Image.asset(
                        'assets/images/onboarding_illustration_12.png',
                        width: 300,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedOpacity(
                        opacity: _isVisible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 300),
                        child: PrimaryButtonSingleColor(
                          text: 'Start Matching',
                          onClickEventHandler: _onEventClickHandler,
                          color: ColorValues.white,
                          width: size.width * 0.9,
                          textColor: ColorValues.textOnLight,
                          height: 68,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
