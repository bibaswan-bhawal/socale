import 'package:flutter/material.dart';

class OutlineButton extends StatelessWidget {
  final double width;
  final double height;
  final Widget buttonContent;
  final Function() onClickEvent;

  const OutlineButton({
    Key? key,
    required this.width,
    required this.height,
    required this.buttonContent,
    required this.onClickEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onClickEvent,
      style: OutlinedButton.styleFrom(
        fixedSize: Size(width, height),
        foregroundColor: Colors.black,
        splashFactory: InkRipple.splashFactory,
        side: const BorderSide(width: 2, color: Color(0xFF000000)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(height * 0.3),
        ),
      ),
      child: buttonContent,
    );
  }
}
