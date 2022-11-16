import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

class GradientButton extends StatelessWidget {
  final double width;
  final double height;
  final LinearGradient linearGradient;
  final Widget buttonContent;
  final Function() onClickEvent;
  const GradientButton({
    Key? key,
    required this.width,
    required this.height,
    required this.linearGradient,
    required this.buttonContent,
    required this.onClickEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleShadow(
      opacity: 0.25,
      offset: const Offset(1, 1),
      sigma: 3,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: linearGradient,
          borderRadius: BorderRadius.circular(height * 0.3),
        ),
        child: Center(
          child: ElevatedButton(
            onPressed: onClickEvent,
            style: ElevatedButton.styleFrom(
                fixedSize: Size(width, height),
                foregroundColor: Colors.white,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(height * 0.3),
                ),
                splashFactory: InkRipple.splashFactory),
            child: buttonContent,
          ),
        ),
      ),
    );
  }
}