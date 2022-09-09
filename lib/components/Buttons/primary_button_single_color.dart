import 'package:flutter/material.dart';
import 'package:socale/values/styles.dart';

class PrimaryButtonSingleColor extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final Color color;
  final Color textColor;
  final Function() onClickEventHandler;

  const PrimaryButtonSingleColor(
      {Key? key,
      required this.width,
      required this.height,
      required this.text,
      required this.color,
      required this.onClickEventHandler,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onClickEventHandler();
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width, height),
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        primary: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        splashFactory: InkRipple.splashFactory,
      ),
      child: Text(
        text,
        style: StyleValues.primaryButtonTextStyle.copyWith(color: textColor),
      ),
    );
  }
}
