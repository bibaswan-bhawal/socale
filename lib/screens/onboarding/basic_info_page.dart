import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/components/nest_will_pop_scope.dart';
import 'package:socale/screens/onboarding/providers/basic_data_provider.dart';
import 'package:socale/screens/onboarding/onboarding_screen.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/enums/onboarding_fields.dart';
import 'package:socale/values/colors.dart';
import 'package:socale/values/styles.dart';
import 'package:intl/intl.dart';

class BasicInfoPage extends ConsumerStatefulWidget {
  const BasicInfoPage({Key? key}) : super(key: key);

  @override
  ConsumerState<BasicInfoPage> createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends ConsumerState<BasicInfoPage> {
  late PageController _pageController;
  final _formKey = GlobalKey<FormState>();
  final firstNameController = InputTextFieldController();
  final lastNameController = InputTextFieldController();

  bool gotData = false;

  void _onBirthDateClickEventHandler() async {
    final dataProvider = ref.watch(basicDataProvider);
    final dataNotifier = ref.read(basicDataProvider.notifier);

    if (Platform.isAndroid) {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dataProvider.getBirthDate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime.now(),
        confirmText: 'Select',
      );

      if (picked != null && picked != dataProvider.getBirthDate) {
        dataNotifier.setBirthDate(picked);
      }
    } else {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (value) {
                if (value != dataProvider.getBirthDate) {
                  dataNotifier.setBirthDate(value);
                }
              },
              initialDateTime: dataProvider.getBirthDate,
            ),
          );
        },
      );
    }
  }

  void _onGradDateClickEventHandler() async {
    final dataProvider = ref.watch(basicDataProvider);
    final dataNotifier = ref.read(basicDataProvider.notifier);

    if (Platform.isAndroid) {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dataProvider.getGradDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100, 1),
        confirmText: 'Select',
      );

      if (picked != null && picked != dataProvider.getGradDate) {
        dataNotifier.setGradDate(picked);
      }
    } else {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (value) {
                if (value != dataProvider.getGradDate) {
                  dataNotifier.setGradDate(value);
                }
              },
              initialDateTime: dataProvider.getGradDate,
            ),
          );
        },
      );
    }
  }

  void _onClickEventHandler() {
    FocusManager.instance.primaryFocus?.unfocus();
    final form = _formKey.currentState;
    final isValid = form != null ? form.validate() : false;

    if (isValid) {
      final dataNotifier = ref.read(basicDataProvider.notifier);
      dataNotifier.saveData();
      onboardingService.setOnboardingStep(OnboardingStep.collegeInfo);
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  Future<bool> _onBackPress() async {
    onboardingService.setOnboardingStep(OnboardingStep.started);
    _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    _pageController = ref.watch(onboardingPageController);
    final dataProvider = ref.watch(basicDataProvider);
    final dataNotifier = ref.read(basicDataProvider.notifier);

    if (!gotData) {
      firstNameController.text = dataProvider.getFirstName;
      lastNameController.text = dataProvider.getLastName;
      setState(() => gotData = dataProvider.getGotData);
    }

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
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(40, 70, 40, 0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Let's get to ",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: 'know ',
                                style: GoogleFonts.poppins(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()..shader = ColorValues.socaleOrangeGradient,
                                ),
                              ),
                              TextSpan(
                                text: "each other",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 15, right: 15, top: 60),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                controller: firstNameController,
                                onChanged: dataNotifier.setFirstName,
                                style: StyleValues.textFieldContentStyle,
                                cursorColor: ColorValues.elementColor,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return "Please enter your name";
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 16),
                                  label: Text(
                                    'First Name',
                                    style: TextStyle(
                                      color: ColorValues.elementColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                  enabledBorder: StyleValues.formTextFieldOutlinedBorderEnabled,
                                  focusedBorder: StyleValues.formTextFieldOutlinedBorderFocused,
                                  errorBorder: StyleValues.formTextFieldOutlinedBorderError,
                                  focusedErrorBorder: StyleValues.formTextFieldOutlinedBorderErrorEnabled,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 15, right: 15, top: 30),
                              child: TextFormField(
                                textCapitalization: TextCapitalization.words,
                                controller: lastNameController,
                                onChanged: dataNotifier.setLastName,
                                style: StyleValues.textFieldContentStyle,
                                cursorColor: ColorValues.elementColor,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return "Please enter your name";
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 16),
                                  label: Text(
                                    'Last Name',
                                    style: TextStyle(
                                      color: ColorValues.elementColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                  enabledBorder: StyleValues.formTextFieldOutlinedBorderEnabled,
                                  focusedBorder: StyleValues.formTextFieldOutlinedBorderFocused,
                                  errorBorder: StyleValues.formTextFieldOutlinedBorderError,
                                  focusedErrorBorder: StyleValues.formTextFieldOutlinedBorderErrorEnabled,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                'Your name will stay anonymous until you share it',
                                style: GoogleFonts.roboto(
                                  color: ColorValues.elementColor,
                                  letterSpacing: -0.3,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0, top: 40),
                              child: Text(
                                'Date of Birth',
                                style: GoogleFonts.roboto(
                                  color: ColorValues.elementColor.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.3,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _onBirthDateClickEventHandler,
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              height: 36,
                              width: size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dataProvider.getBirthDate.day.toString(),
                                    style: GoogleFonts.roboto(
                                      color: ColorValues.elementColor,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.3,
                                      fontSize: 24,
                                    ),
                                  ),
                                  const VerticalDivider(
                                    width: 31,
                                    thickness: 1,
                                    indent: 7,
                                    endIndent: 7,
                                    color: ColorValues.elementColor,
                                  ),
                                  Text(
                                    DateFormat.MMMM().format(dataProvider.getBirthDate),
                                    style: GoogleFonts.roboto(
                                      color: ColorValues.elementColor,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.3,
                                      fontSize: 24,
                                    ),
                                  ),
                                  const VerticalDivider(
                                    width: 31,
                                    thickness: 1,
                                    indent: 7,
                                    endIndent: 7,
                                    color: ColorValues.elementColor,
                                  ),
                                  Text(
                                    dataProvider.getBirthDate.year.toString(),
                                    style: GoogleFonts.roboto(
                                      color: ColorValues.elementColor,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.3,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: SvgPicture.asset('assets/icons/selector_icon.svg'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0, top: 40),
                              child: Text(
                                'Graduation Year',
                                style: GoogleFonts.roboto(
                                  color: ColorValues.elementColor.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.3,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _onGradDateClickEventHandler,
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              height: 36,
                              width: size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat.MMMM().format(dataProvider.getGradDate),
                                    style: GoogleFonts.roboto(
                                      color: ColorValues.elementColor,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.3,
                                      fontSize: 24,
                                    ),
                                  ),
                                  const VerticalDivider(
                                    width: 31,
                                    thickness: 1,
                                    indent: 7,
                                    endIndent: 7,
                                    color: ColorValues.elementColor,
                                  ),
                                  Text(
                                    dataProvider.getGradDate.year.toString(),
                                    style: GoogleFonts.roboto(
                                      color: ColorValues.elementColor,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.3,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: SvgPicture.asset('assets/icons/selector_icon.svg'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
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
