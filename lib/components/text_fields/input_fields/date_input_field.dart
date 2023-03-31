import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:socale/components/pickers/date_picker/android_date_picker.dart';
import 'package:socale/components/pickers/date_picker/ios_date_picker.dart';
import 'package:socale/resources/colors.dart';

enum DatePickerDateMode { dayMonthYear, monthYear }

class DateInputField extends StatefulWidget {
  final DateTime initialDate;
  final DateTime? maximumDate;
  final DateTime? minimumDate;

  final DatePickerDateMode dateMode;

  final Function(DateTime) onChanged;

  const DateInputField({
    super.key,
    required this.initialDate,
    required this.onChanged,
    this.maximumDate,
    this.minimumDate,
    this.dateMode = DatePickerDateMode.dayMonthYear,
  });

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  late DateTime currentDate;

  @override
  initState() {
    super.initState();
    currentDate = widget.initialDate;
  }

  _showDatePicker() {
    if (Platform.isIOS) {
      _showIosDatePicker();
    } else {
      _showAndroidDatePicker();
    }
  }

  _showAndroidDatePicker() {
    showAndroidDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: widget.minimumDate ?? DateTime(1900),
      lastDate: widget.maximumDate ?? DateTime(2100),
      dateMode: widget.dateMode == DatePickerDateMode.dayMonthYear
          ? AndroidDatePickerMode.dayMonthYear
          : AndroidDatePickerMode.monthYear,
    ).then((date) {
      if (date != null) {
        setState(() => currentDate = date);
        widget.onChanged(date);
      }
    });
  }

  _showIosDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 230,
        padding: const EdgeInsets.only(bottom: 16.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: IosDatePicker(
          mode: widget.dateMode == DatePickerDateMode.dayMonthYear
              ? IosDatePickerMode.dayMonthYear
              : IosDatePickerMode.monthYear,
          initialDate: currentDate,
          minimumDate: widget.minimumDate,
          maximumDate: widget.maximumDate,
          onDateChanged: (date) {
            setState(() => currentDate = date);
            widget.onChanged(date);
          },
        ),
      ),
    );
  }

  get _textStyle => GoogleFonts.roboto(
        fontSize: 13,
        letterSpacing: -0.3,
        color: ColorValues.textHint,
      );

  _dayBuilder() {
    return Expanded(
      child: Center(
        child: Text(
          currentDate.day.toString(),
          style: _textStyle,
        ),
      ),
    );
  }

  _monthBuilder() {
    return Expanded(
      child: Center(
        child: Text(
          DateFormat(DateFormat.MONTH).format(currentDate),
          style: _textStyle,
        ),
      ),
    );
  }

  _yearBuilder() {
    return Expanded(
      child: Center(
        child: Text(
          currentDate.year.toString(),
          style: _textStyle,
        ),
      ),
    );
  }

  _dividerBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        '/',
        style: _textStyle,
      ),
    );
  }

  dateBuilder() {
    List<Widget> date = [];

    switch (widget.dateMode) {
      case DatePickerDateMode.dayMonthYear:
        date = [
          _dayBuilder(),
          _dividerBuilder(),
          _monthBuilder(),
          _dividerBuilder(),
          _yearBuilder(),
        ];
        break;
      case DatePickerDateMode.monthYear:
        date = [
          _monthBuilder(),
          _dividerBuilder(),
          _yearBuilder(),
        ];
        break;
    }

    return date;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showDatePicker,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 36,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: dateBuilder(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SvgPicture.asset(
                    'assets/icons/picker.svg',
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF808080),
                      BlendMode.srcIn,
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
