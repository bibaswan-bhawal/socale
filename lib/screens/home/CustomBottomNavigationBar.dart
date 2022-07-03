import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final Function(int) onNavBarClicked;

  const CustomBottomNavigationBar(
      {Key? key, required this.size, required this.onNavBarClicked})
      : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: 66,
      child: Stack(
        children: <Widget>[
          CustomPaint(
            size: Size(size.width, 66),
            painter: BNBCustomPainter(),
          ),
          Center(
            heightFactor: 0.8,
            child: OverflowBox(
              maxHeight: 74,
              child: SvgPicture.asset("assets/icons/center_logo.svg",
                  height: 70, fit: BoxFit.fitHeight),
            ),
          ),
          SizedBox(
            width: size.width,
            height: 66,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      onNavBarClicked(0);
                    },
                    icon: SvgPicture.asset("assets/icons/home_icon.svg")),
                IconButton(
                    onPressed: () {
                      onNavBarClicked(1);
                    },
                    icon: SvgPicture.asset("assets/icons/chat_icon.svg")),
                Container(width: size.width * 0.20),
                IconButton(
                    onPressed: () {
                      // TODO IMPLEMENT INSIGHTS NAVIGATE
                    },
                    icon: SvgPicture.asset("assets/icons/insights_icon.svg")),
                IconButton(
                    onPressed: () {
                      onNavBarClicked(2);
                    },
                    icon: SvgPicture.asset("assets/icons/user_icon.svg"))
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

    canvas.drawShadow(path.shift(const Offset(0, -5)), Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
