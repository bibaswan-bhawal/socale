import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/translucent_background/translucent_background.dart';
import 'package:socale/screens/onboarding/onboarding_screen/academic_interests_page.dart';
import 'package:socale/screens/onboarding/onboarding_screen/academics_page.dart';
import 'package:socale/screens/onboarding/onboarding_screen/basics_page.dart';
import 'package:socale/screens/onboarding/onboarding_screen/career_page.dart';
import 'package:socale/screens/onboarding/onboarding_screen/describe_page.dart';
import 'package:socale/screens/onboarding/onboarding_screen/friendPage.dart';
import 'package:socale/screens/onboarding/onboarding_screen/hobbies_page.dart';
import 'package:socale/screens/onboarding/onboarding_screen/intro_page.dart';
import 'package:socale/screens/onboarding/onboarding_screen/question_five_page.dart';
import 'package:socale/screens/onboarding/onboarding_screen/question_four_page.dart';
import 'package:socale/screens/onboarding/onboarding_screen/question_one_page.dart';
import 'package:socale/screens/onboarding/onboarding_screen/question_three_page.dart';
import 'package:socale/screens/onboarding/onboarding_screen/question_two_page.dart';
import 'package:socale/screens/onboarding/onboarding_screen/skills_page.dart';
import 'package:socale/services/onboarding_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  final _academicsDetailsPageController = PageController(keepPage: true);
  final _bucket = PageStorageBucket();

  final _majorKey = GlobalKey<FormState>();
  final _minorKey = GlobalKey<FormState>();
  final _collegeKey = GlobalKey<FormState>();

  int index = 0;
  int detailsIndex = 0;
  bool isLoading = false;

  List<String> _major = [];
  List<String> _minor = [];
  List<String> _college = [];
  List<int> situationalQuestions = [20, 20, 20, 20, 20];

  void majorOnSave(value) {
    _major = value;
  }

  void minorOnSave(value) {
    if (value == null) {
      _minor = [];
      return;
    }

    _minor = value;
  }

  void collegeOnSave(value) {
    print(value);
    _college = value;
    onboardingService.setCollegeInfo(_major, _minor, _college);
  }

  void situationalQuestionsCallback(double value, int pos) {
    if (value == 0) {
      situationalQuestions[pos] = 1;
      return;
    }

    situationalQuestions[pos] = value.toInt();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: index == 2,
      body: Stack(
        children: [
          TranslucentBackground(),
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            reverse: true,
            child: SizedBox(
              height: size.height,
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: size.height - 100,
                        child: PageView(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            IntroPage(),
                            BasicsPage(),
                            PageStorage(
                              bucket: _bucket,
                              child: AcademicsPage(
                                key: PageStorageKey<String>('pageOne'),
                                pageController: _academicsDetailsPageController,
                                majorKey: _majorKey,
                                minorKey: _minorKey,
                                collegeKey: _collegeKey,
                                collegeOnSave: collegeOnSave,
                                majorOnSave: majorOnSave,
                                minorOnSave: minorOnSave,
                              ),
                            ),
                            SkillsPage(),
                            CareersPage(),
                            DescribePage(),
                            AcademicInterestsPage(),
                            HobbiesPage(),
                            FriendPage(),
                            QuestionOnePage(
                              onChange: situationalQuestionsCallback,
                            ),
                            QuestionTwoPage(
                              onChange: situationalQuestionsCallback,
                            ),
                            QuestionThreePage(
                              onChange: situationalQuestionsCallback,
                            ),
                            QuestionFourPage(
                              onChange: situationalQuestionsCallback,
                            ),
                            QuestionFivePage(
                              onChange: situationalQuestionsCallback,
                            )
                          ],
                          onPageChanged: (value) =>
                              setState(() => index = value),
                        ),
                      ),
                    ],
                  ),
                  if (index > 0)
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 50, 0, 0),
                      child: IconButton(
                        onPressed: onPreviousClickHandler,
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 40),
                      child: PrimaryButton(
                        width: size.width,
                        height: 60,
                        colors: [Color(0xFFFD6C00), Color(0xFFFFA133)],
                        text: "Continue",
                        onClickEventHandler: onNextClickHandler,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  onNextClickHandler() {
    if (_pageController.page == 2 &&
        _academicsDetailsPageController.page != 2) {
      if (_academicsDetailsPageController.page == 0) {
        final form = _majorKey.currentState;
        final isValid = form != null ? form.validate() : false;
        if (isValid) {
          form.save();
          _academicsDetailsPageController.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      }

      if (_academicsDetailsPageController.page == 1) {
        final form = _minorKey.currentState;
        final isValid = form != null ? form.validate() : false;
        if (isValid) {
          form.save();
          _academicsDetailsPageController.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      }
      return;
    }

    if (_pageController.page == 2) {
      if (_academicsDetailsPageController.page == 2) {
        final form = _collegeKey.currentState;
        final isValid = form != null ? form.validate() : false;
        if (isValid) {
          form.save();

          _pageController.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
        return;
      }
    }

    if (_pageController.page == 13) {
      if (!isLoading) {
        setState(() => isLoading = true);

        FocusManager.instance.primaryFocus?.unfocus();
        final loadingSnackBar = SnackBar(
          duration: Duration(days: 365),
          content: Row(
            children: [
              Expanded(
                child: Text(
                  "Saving profile data",
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ],
          ),
        );

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(loadingSnackBar);

        onboardingService.setSituationalDecisions(situationalQuestions);
        onboardingService.setAcademicInclination(100);
        uploadUser();
        return;
      }
    }

    _pageController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  uploadUser() async {
    if (await onboardingService.createOnboardedUser()) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Get.offAllNamed('/main');
    } else {
      setState(() => isLoading = false);
      FocusManager.instance.primaryFocus?.unfocus();
      final loadingSnackBar = SnackBar(
        duration: Duration(days: 365),
        content: Text(
          "Something went wrong when saving your profile data",
          textAlign: TextAlign.center,
        ),
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(loadingSnackBar);
    }
  }

  onPreviousClickHandler() {
    if (!isLoading) {
      if (_pageController.page == 2 &&
          _academicsDetailsPageController.page != 0) {
        _academicsDetailsPageController.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        return;
      }

      _pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }
}
