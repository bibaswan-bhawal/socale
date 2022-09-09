import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/chips/category_chip_select/category_chip_select_input_list.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/components/nest_will_pop_scope.dart';
import 'package:socale/components/snackbar/onboarding_snackbars.dart';
import 'package:socale/screens/onboarding/onboarding_screen.dart';
import 'package:socale/screens/onboarding/providers/personality_data_provider.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/enums/onboarding_fields.dart';
import 'package:socale/utils/options/describe.dart';
import 'package:socale/values/colors.dart';

class SelfDescriptionPage extends ConsumerStatefulWidget {
  const SelfDescriptionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SelfDescriptionPage> createState() => _SelfDescriptionPageState();
}

class _SelfDescriptionPageState extends ConsumerState<SelfDescriptionPage> {
  late PageController _pageController;

  void _onClickEventHandler() {
    final dataProvider = ref.watch(personalityDataProvider);
    final dataNotifier = ref.watch(personalityDataProvider.notifier);

    if (dataProvider.getSelfDescription.length < 3) {
      onboardingSnackBar.addMoreCareerGoalsSnack(context);
      return;
    }

    dataNotifier.uploadSelfDescription();
    onboardingService.setOnboardingStep(OnboardingStep.leisureInterests);
    _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Future<bool> _onBackPress() async {
    FocusManager.instance.primaryFocus?.unfocus();
    onboardingService.setOnboardingStep(OnboardingStep.careerGoals);
    _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    _pageController = ref.watch(onboardingPageController);

    final dataProvider = ref.watch(personalityDataProvider);
    final dataNotifier = ref.watch(personalityDataProvider.notifier);

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
              Padding(
                padding: EdgeInsets.only(bottom: 80),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 90, left: 30),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'You are ',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: 'Unique!',
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
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          "I would describe myself as...",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Color(0xFF606060),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 40.0,
                        ),
                        child: CategoryChipSelectInputList(
                          searchText: "Search",
                          onChange: dataNotifier.setSelfDescription,
                          initValue: dataProvider.getSelfDescription,
                          gotData: dataProvider.getGotSelfDescriptionData,
                          list: descriptionOptionList,
                        ),
                      ),
                    ),
                  ],
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
      ),
    );
  }
}
