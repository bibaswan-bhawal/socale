import 'package:flutter/material.dart';
import 'package:socale/values/styles.dart';

class PrimaryLoadingButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final List<Color> colors;
  final Function() onClickEventHandler;
  final bool isLoading;

  const PrimaryLoadingButton({
    Key? key,
    required this.width,
    required this.height,
    required this.text,
    required this.colors,
    required this.onClickEventHandler,
    required this.isLoading,
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
        child: Stack(
          children: [
            if (!isLoading)
              Text(
                text,
                style: StyleValues.primaryButtonTextStyle,
              )
            else
              SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
