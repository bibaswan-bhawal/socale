import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/values/colors.dart';
import 'package:socale/values/styles.dart';
import 'package:intl/intl.dart';

class BasicsPage extends StatefulWidget {
  const BasicsPage({Key? key}) : super(key: key);

  @override
  State<BasicsPage> createState() => _BasicsPageState();
}

class _BasicsPageState extends State<BasicsPage> {
  DateTime _birthDate = DateTime(2000, 6, 15);
  DateTime _gradDate = DateTime(2025, 6);
  String _firstName = "";
  String _lastName = "";

  onChangeFirstName(value) {
    setState(() => _firstName = value);
    onboardingService.setBiographics(
        _firstName, _lastName, _birthDate, _gradDate);
  }

  onChangeLastName(value) {
    setState(() => _lastName = value);
    onboardingService.setBiographics(
        _firstName, _lastName, _birthDate, _gradDate);
  }

  Future<void> _showMaterialBirthDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
      confirmText: 'Select',
    );

    if (picked != null && picked != _birthDate) {
      setState(() => {_birthDate = picked});
      onboardingService.setBiographics(
          _firstName, _lastName, _birthDate, _gradDate);
    }
  }

  void _showCupertinoBirthDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height * 0.25,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (value) {
              if (value != _birthDate) {
                print(value);
                setState(() => {_birthDate = value});
                onboardingService.setBiographics(
                    _firstName, _lastName, _birthDate, _gradDate);
              }
            },
            initialDateTime: _birthDate,
          ),
        );
      },
    );
  }

  Future<void> _showMaterialGradDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _gradDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100, 1),
      confirmText: 'Select',
    );

    if (picked != null && picked != _gradDate) {
      setState(() => {_gradDate = picked});
      onboardingService.setBiographics(
          _firstName, _lastName, _birthDate, _gradDate);
    }
  }

  void _showCupertinoGradDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height * 0.25,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (value) {
              if (value != _gradDate) {
                setState(() => {_gradDate = value});
                onboardingService.setBiographics(
                    _firstName, _lastName, _birthDate, _gradDate);
              }
            },
            initialDateTime: _gradDate,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                        foreground: Paint()
                          ..shader = ColorValues.socaleOrangeGradient,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 60),
                    child: TextField(
                      onChanged: onChangeFirstName,
                      style: StyleValues.textFieldContentStyle,
                      cursorColor: ColorValues.elementColor,
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
                        enabledBorder:
                            StyleValues.formTextFieldOutlinedBorderEnabled,
                        focusedBorder:
                            StyleValues.formTextFieldOutlinedBorderFocused,
                        errorBorder:
                            StyleValues.formTextFieldOutlinedBorderError,
                        focusedErrorBorder:
                            StyleValues.formTextFieldOutlinedBorderErrorEnabled,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 30),
                    child: TextField(
                      onChanged: onChangeLastName,
                      style: StyleValues.textFieldContentStyle,
                      cursorColor: ColorValues.elementColor,
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
                        enabledBorder:
                            StyleValues.formTextFieldOutlinedBorderEnabled,
                        focusedBorder:
                            StyleValues.formTextFieldOutlinedBorderFocused,
                        errorBorder:
                            StyleValues.formTextFieldOutlinedBorderError,
                        focusedErrorBorder:
                            StyleValues.formTextFieldOutlinedBorderErrorEnabled,
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
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 36,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _birthDate.day.toString(),
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
                          DateFormat.MMMM().format(_birthDate),
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
                          _birthDate.year.toString(),
                          style: GoogleFonts.roboto(
                            color: ColorValues.elementColor,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.3,
                            fontSize: 24,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (Platform.isIOS) {
                              _showCupertinoBirthDatePicker();
                            } else if (Platform.isAndroid) {
                              _showMaterialBirthDatePicker();
                            }
                          },
                          icon: SvgPicture.asset(
                              'assets/icons/selector_icon.svg'),
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
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 36,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat.MMMM().format(_gradDate),
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
                          _gradDate.year.toString(),
                          style: GoogleFonts.roboto(
                            color: ColorValues.elementColor,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.3,
                            fontSize: 24,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (Platform.isIOS) {
                              _showCupertinoGradDatePicker();
                            } else if (Platform.isAndroid) {
                              _showMaterialGradDatePicker();
                            }
                          },
                          icon: SvgPicture.asset(
                              'assets/icons/selector_icon.svg'),
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
    );
  }
}
