import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io' show Platform;

import 'package:socale/values/colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final Function(int) onNavBarClicked;
  final Size size;

  const CustomBottomNavigationBar({Key? key, required this.size, required this.onNavBarClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double barHeight = 74;
    double heightShift = 0.7;

    if (Platform.isIOS) {
      barHeight = 84;
      heightShift = 0.6;
    }

    return SizedBox(
      width: size.width,
      height: barHeight,
      child: Stack(
        children: <Widget>[
          CustomPaint(
            size: Size(size.width, barHeight),
            painter: BNBCustomPainter(),
          ),
          Center(
            heightFactor: heightShift,
            child: OverflowBox(
              maxHeight: 400,
              child: IconButton(
                iconSize: 64,
                splashRadius: 1,
                onPressed: () {
                  onNavBarClicked(1);
                },
                icon: SvgPicture.asset(
                  "assets/icons/center_logo.svg",
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width,
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  splashRadius: 1,
                  onPressed: () {
                    onNavBarClicked(0);
                  },
                  icon: SvgPicture.asset("assets/icons/chat_icon.svg", color: ColorValues.white.withOpacity(0.69)),
                ),
                Container(width: size.width * 0.20),
                IconButton(
                  splashRadius: 1,
                  onPressed: () {
                    onNavBarClicked(2);
                  },
                  icon: SvgPicture.asset("assets/icons/user_icon.svg", color: ColorValues.white.withOpacity(0.69)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xff1F2124)
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, size.height / 2);

    path.quadraticBezierTo(0, 0, size.height / 2, 0);
    path.lineTo(size.width - size.height / 2, 0);
    path.quadraticBezierTo(size.width, 0, size.width, size.height / 2);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path.shift(const Offset(0, -4)), Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
