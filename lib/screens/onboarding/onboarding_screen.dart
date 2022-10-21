import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/translucent_background/translucent_background.dart';
import 'package:socale/screens/onboarding/academics_page.dart';
import 'package:socale/screens/onboarding/avatar_selection_page.dart';
import 'package:socale/screens/onboarding/basic_info_page.dart';
import 'package:socale/screens/onboarding/describe_friend_page.dart';
import 'package:socale/screens/onboarding/email_verification/email_verification_page.dart';
import 'package:socale/screens/onboarding/get_started_page.dart';
import 'package:socale/screens/onboarding/onboarding_finished_page.dart';
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
import 'package:socale/services/analytics_service.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/utils/system_ui_setter.dart';
import 'package:socale/values/colors.dart';

final onboardingPageController = Provider((_) => PageController());

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late PageController _pageController;
  bool isSchoolEmail = false;
  late DateTime startTime;

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
    setSystemUIDark();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkIfSchoolEmailProvided();
  }

  checkIfSchoolEmailProvided() {
    final userAttributesProvider = ref.watch(userAttributesAsyncController);

    userAttributesProvider.whenData((value) async {
      String? email = value
          .where((element) =>
              element.userAttributeKey == CognitoUserAttributeKey.email)
          .first
          .value;
      if (email.contains("ucsd.edu")) {
        setState(() => isSchoolEmail = true);
        await onboardingService.setSchoolEmail(email);
        return;
      }
    });

    var email = onboardingService.getSchoolEmail();
    if (email != null) setState(() => isSchoolEmail = true);
  }

  onPageChange(page) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (page == 15 && isSchoolEmail) {
      Duration timeDifference = DateTime.now().difference(startTime);
      analyticsService.recordOnboardingTime(timeDifference.inMinutes);
      timeDifference.inMinutes;
    } else if (page == 16 && !isSchoolEmail) {
      Duration timeDifference = DateTime.now().difference(startTime);
      analyticsService.recordOnboardingTime(timeDifference.inMinutes);
    }
  }

  @override
  Widget build(BuildContext context) {
    _pageController = ref.watch(onboardingPageController);

    return Stack(
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
            AvatarSelectionPage(),
            OnboardingFinishedPage(),
          ],
        ),
        Positioned(
          right: 30,
          top: 60,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              authService.signOutCurrentUser(ref);
            },
            child: Material(
              child: Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  "Log Out",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorValues.socaleOrange,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
