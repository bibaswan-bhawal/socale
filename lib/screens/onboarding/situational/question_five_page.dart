import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/components/nest_will_pop_scope.dart';
import 'package:socale/screens/onboarding/onboarding_screen.dart';
import 'package:socale/screens/onboarding/providers/situational_data_provider.dart';
import 'package:socale/values/colors.dart';

class QuestionFivePage extends ConsumerStatefulWidget {
  const QuestionFivePage({Key? key}) : super(key: key);

  @override
  ConsumerState<QuestionFivePage> createState() => _QuestionFivePageState();
}

class _QuestionFivePageState extends ConsumerState<QuestionFivePage> {
  late PageController _pageController;

  void _onClickEventHandler() {
    final dataNotifier = ref.read(situationalQuestionsProvider.notifier);
    dataNotifier.uploadQuestions();
    _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Future<bool> _onBackPress() async {
    _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    return false;
  }

  onChanged(double value) {
    final dataNotifier = ref.read(situationalQuestionsProvider.notifier);
    dataNotifier.setQuestionValue(value.round(), 4);
  }

  @override
  Widget build(BuildContext context) {
    _pageController = ref.watch(onboardingPageController);

    final dataProvider = ref.watch(situationalQuestionsProvider);

    final size = MediaQuery.of(context).size;

    return NestedWillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: KeyboardSafeArea(
          child: Stack(
            children: [
              Positioned(
                left: 10,
                top: 20,
                child: IconButton(
                  onPressed: _onBackPress,
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
              ),
              Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 80, left: 30, right: 30),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Let's get to know you ",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'better!',
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()..shader = ColorValues.socaleOrangeGradient,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 30, right: 30, top: 5),
                      child: Text(
                        "How much does this following statement describe you?",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Color(0xFF606060),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Image.asset('assets/images/onboarding_illustration_11.png'),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: Text(
                        "Before starting a new project, you prefer to have your other projects finished.",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Column(
                      children: [
                        Material(
                          color: Color(0xFFFFFFFF),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Slider(
                            activeColor: ColorValues.socaleOrange,
                            inactiveColor: ColorValues.elementColor.withOpacity(0.1),
                            value: dataProvider.getQuestions[4].toDouble(),
                            max: 100,
                            onChanged: onChanged,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Disagree",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "Agree",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
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
      ),
    );
  }
}
