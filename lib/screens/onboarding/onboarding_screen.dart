import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socale/components/nest_will_pop_scope.dart';
import 'package:socale/components/translucent_background/translucent_background.dart';
import 'package:socale/screens/onboarding/academics_page.dart';
import 'package:socale/screens/onboarding/avatar_selection.dart';
import 'package:socale/screens/onboarding/basic_info_page.dart';
import 'package:socale/screens/onboarding/describe_friend_page.dart';
import 'package:socale/screens/onboarding/email_verification/email_verification_page.dart';
import 'package:socale/screens/onboarding/get_started_page.dart';
import 'package:socale/screens/onboarding/personality/academic_interests_page.dart';
import 'package:socale/screens/onboarding/personality/career_goals_page.dart';
import 'package:socale/screens/onboarding/personality/hobbies_page.dart';
import 'package:socale/screens/onboarding/personality/self_description_page.dart';
import 'package:socale/screens/onboarding/personality/skills_page.dart';
import 'package:socale/screens/onboarding/situational/question_five_page.dart';
import 'package:socale/screens/onboarding/situational/question_four_page.dart';
import 'package:socale/screens/onboarding/situational/question_one_page.dart';
import 'package:socale/screens/onboarding/situational/question_three_page.dart';
import 'package:socale/screens/onboarding/situational/question_two_page.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/providers/providers.dart';

final onboardingPageController = Provider((_) => PageController());
final bobPageController = Provider((_) => PageController());

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late PageController _pageController;
  bool resize = true;
  bool isSchoolEmail = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
      );
    } else if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark));
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkIfSchoolEmailProvided();
  }

  checkIfSchoolEmailProvided() {
    final prov = ref.watch(userAttributesAsyncController);
    prov.whenData((value) {
      final email = value.where((element) => element.userAttributeKey == CognitoUserAttributeKey.email).first.value;
      if (email.contains("ucsd.edu")) {
        setState(() => isSchoolEmail = true);
        setState(() => resize = false);
        onboardingService.setSchoolEmail(email);
      }
    });
  }

  onPageChange(page) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<bool> _willPopScope() async {
    if (_pageController.page != 0) {
      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _pageController = ref.watch(onboardingPageController);
    return NestedWillPopScope(
      onWillPop: _willPopScope,
      child: Stack(
        children: [
          TranslucentBackground(),
          PageView(
            controller: _pageController,
            onPageChanged: onPageChange,
            physics: NeverScrollableScrollPhysics(),
            children: [
              if (!isSchoolEmail) EmailVerificationPage(),
              GetStartPage(),
              BasicInfoPage(),
              AcademicsPage(),
              SkillsPage(),
              AcademicInterestsPage(),
              CareerGoalsPage(),
              SelfDescriptionPage(),
              HobbiesPage(),
              DescribeFriendPage(),
              QuestionOnePage(),
              QuestionTwoPage(),
              QuestionThreePage(),
              QuestionFourPage(),
              QuestionFivePage(),
              AvatarSelection(),
            ],
          ),
        ],
      ),
    );
  }
}
