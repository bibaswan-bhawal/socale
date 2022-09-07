import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/screens/onboarding/onboarding_screen.dart';
import 'package:socale/values/colors.dart';

class GetStartPage extends ConsumerStatefulWidget {
  const GetStartPage({Key? key}) : super(key: key);

  @override
  ConsumerState<GetStartPage> createState() => _GetStartPageState();
}

class _GetStartPageState extends ConsumerState<GetStartPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
  }

  void _onClickEventHandler() {
    _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    _pageController = ref.watch(onboardingPageController);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: Image.asset(
                        'assets/images/onboarding_illustration_3.png',
                        height: size.height / 2.2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Welcome to ',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Socale',
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
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: SizedBox(
                        width: 300,
                        child: Text(
                          'The first social network to use the power of Machine Learning to find people you will vibe with on campus.',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            textStyle: TextStyle(
                              color: const Color(0xFF7A7A7A),
                              height: 1.4,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              left: 20,
              child: PrimaryButton(
                width: size.width,
                height: 60,
                colors: [Color(0xFFFD6C00), Color(0xFFFFA133)],
                text: "Continue",
                onClickEventHandler: _onClickEventHandler,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
