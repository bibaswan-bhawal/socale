import 'package:flutter/material.dart';
import 'package:socale/values/styles.dart';

class CustomOutlinedButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final Function() onClickEventHandler;

  const CustomOutlinedButton(
      {Key? key,
      required this.width,
      required this.height,
      required this.text,
      required this.onClickEventHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        onClickEventHandler();
      },
      style: OutlinedButton.styleFrom(
        fixedSize: Size(width, height),
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        side: BorderSide(width: 2, color: const Color(0xFF000000)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        primary: Colors.transparent,
        splashFactory: InkRipple.splashFactory,
      ),
      child: Text(
        "Register",
        style: StyleValues.outlinedButtonTextStyle,
      ),
    );
  }
}
