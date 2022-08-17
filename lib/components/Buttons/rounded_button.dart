import 'package:flutter/material.dart';
import 'package:socale/values/styles.dart';

class RoundedButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final List<Color> colors;
  final Function() onClickEventHandler;

  const RoundedButton({
    Key? key,
    required this.width,
    required this.height,
    required this.text,
    required this.colors,
    required this.onClickEventHandler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.8, 1),
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(50),
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
              borderRadius: BorderRadius.circular(50),
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
