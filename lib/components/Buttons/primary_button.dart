import 'package:flutter/material.dart';
import 'package:socale/values/styles.dart';

class PrimaryButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final List<Color> colors;
  final Function() onClickEventHandler;
  final bool enabled;

  const PrimaryButton(
      {Key? key,
      required this.width,
      required this.height,
      required this.text,
      required this.colors,
      required this.onClickEventHandler,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.8, 1),
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: () {
          if (enabled) onClickEventHandler();
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
