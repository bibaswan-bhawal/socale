import 'package:flutter/material.dart';
import 'package:socale/values/styles.dart';

class PrimaryButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final Function() onClickEventHandler;

  const PrimaryButton(
      {Key? key,
      required this.width,
      required this.height,
      required this.text,
      required this.onClickEventHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.8, 1),
            colors: [Color(0xFFFD6C00), Color(0xFFFFA133)]),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: () {
          onClickEventHandler();
        },
        style: ElevatedButton.styleFrom(
            fixedSize: Size(width, height),
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            splashFactory: InkRipple.splashFactory),
        child: Text(
          text,
          style: StyleValues.primaryButtonTextStyle,
        ),
      ),
    );
  }
}
