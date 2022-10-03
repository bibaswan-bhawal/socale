import 'package:flutter/material.dart';
import 'package:socale/values/styles.dart';

class PrimarySolidIconButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final Color color;
  final Color textColor;
  final Widget icon;
  final Function() onClickEventHandler;

  const PrimarySolidIconButton({
    Key? key,
    required this.width,
    required this.height,
    required this.text,
    required this.color,
    required this.onClickEventHandler,
    required this.textColor,
    required this.icon,
  }) : super(key: key);

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        splashFactory: InkRipple.splashFactory,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: StyleValues.primaryButtonTextStyle.copyWith(color: textColor),
            ),
          ),
          SizedBox(
            width: 24,
            height: 24,
            child: icon,
          ),
        ],
      ),
    );
  }
}
