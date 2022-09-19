import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/TextFields/chip_input/chip_input_text_field.dart';
import 'package:socale/components/TextFields/dropdown_input_field/dropdown_input_field.dart';
import 'package:socale/components/nest_will_pop_scope.dart';
import 'package:socale/screens/onboarding/onboarding_screen.dart';
import 'package:socale/screens/onboarding/providers/academic_data_provider.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/enums/onboarding_fields.dart';
import 'package:socale/utils/options/colleges.dart';
import 'package:socale/utils/options/major_minor.dart';
import 'package:socale/values/colors.dart';
import 'package:socale/values/styles.dart';

class AcademicsPage extends ConsumerStatefulWidget {
  const AcademicsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AcademicsPage> createState() => _AcademicsPageState();
}

class _AcademicsPageState extends ConsumerState<AcademicsPage> {
  late PageController _pageController;
  late PageController _secondPageController;

  final majorFormKey = GlobalKey<FormState>();
  final minorFormKey = GlobalKey<FormState>();
  final collegeFormKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dataProvider = ref.watch(academicDataProvider);
    _secondPageController = PageController(initialPage: dataProvider.getPage);
  }

  void _onClickEventHandler() {
    final dataNotifier = ref.watch(academicDataProvider.notifier);

    if (_secondPageController.page == 0) {
      final form = majorFormKey.currentState;
      final isValid = form != null ? form.validate() : false;

      if (isValid) {
        _secondPageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    } else if (_secondPageController.page == 1) {
      final form = minorFormKey.currentState;
      final isValid = form != null ? form.validate() : false;

      if (isValid) {
        _secondPageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    } else if (_secondPageController.page == 2) {
      final form = collegeFormKey.currentState;
      final isValid = form != null ? form.validate() : false;

      if (isValid) {
        dataNotifier.uploadData();
        onboardingService.setOnboardingStep(OnboardingStep.skills);
        _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    }
  }

  Future<bool> _onBackPress() async {
    if (_secondPageController.page! > 0) {
      onboardingService.setOnboardingStep(OnboardingStep.bio);
      _secondPageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      return false;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    return false;
  }

  void _onPageChanged(int page) {
    final dataNotifier = ref.watch(academicDataProvider.notifier);
    dataNotifier.setCurrentPage(page);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _pageController = ref.watch(onboardingPageController);

    AcademicDataNotifier dataProvider = ref.watch(academicDataProvider);
    final dataNotifier = ref.watch(academicDataProvider.notifier);

    final availableHeight = size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom;

    return NestedWillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Stack(
            children: [
              SingleChildScrollView(
                reverse: true,
                child: SizedBox(
                  height: availableHeight,
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(40, 70, 40, 0),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Let's find you some ",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'classmates!',
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
                              padding: EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 32),
                              child: Image.asset("assets/images/onboarding_illustration_4.png"),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: PageView(
                          controller: _secondPageController,
                          onPageChanged: _onPageChanged,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Form(
                              key: majorFormKey,
                              child: ChipInputTextField(
                                values: dataProvider.getMajors,
                                list: majorsMinorOptionsList,
                                width: size.width - 48,
                                textInputLabel: "Majors",
                                decoration: InputDecoration(border: StyleValues.chipFieldBorder),
                                validator: (values) {
                                  if (values == null || values.isEmpty) {
                                    return "Please add at least one major";
                                  }

                                  if (values.length > 2) {
                                    return "Please only add two majors";
                                  }

                                  return null;
                                },
                                onSaved: (value) {},
                                onChangeCallback: dataNotifier.setMajors,
                              ),
                            ),
                            Form(
                              key: minorFormKey,
                              child: ChipInputTextField(
                                values: dataProvider.getMinors,
                                list: majorsMinorOptionsList,
                                width: size.width - 48,
                                textInputLabel: "Minor",
                                decoration: InputDecoration(border: StyleValues.chipFieldBorder),
                                validator: (values) {
                                  if (values != null && values.length > 2) {
                                    return "Please add only two minors";
                                  }

                                  return null;
                                },
                                onSaved: (value) {},
                                onChangeCallback: dataNotifier.setMinors,
                              ),
                            ),
                            Form(
                              key: collegeFormKey,
                              child: DropDownInputField(
                                label: "College",
                                initValue: dataProvider.getCollege,
                                onChange: dataNotifier.setCollege,
                                list: collegesOptionsList,
                                decoration: InputDecoration(border: StyleValues.chipFieldBorder),
                                validator: (String? value) {
                                  if (value == null) {
                                    return "Please select a college";
                                  }

                                  if (value.isEmpty) {
                                    return "Please select a college";
                                  }

                                  return null;
                                },
                                onSaved: (String? newValue) {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: 20,
                child: IconButton(
                  onPressed: _onBackPress,
                  icon: const Icon(Icons.arrow_back_ios_new),
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
