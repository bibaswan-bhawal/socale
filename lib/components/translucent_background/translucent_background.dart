import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class TranslucentBackground extends StatelessWidget {
  const TranslucentBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        CustomPaint(
          size: Size(200, 200),
          painter: CirclePainter(
              Color(0xFF39EDFF), Color(0xFF0051E1), Offset(0, 100)),
        ),
        CustomPaint(
          size: Size(200, 200),
          painter: CirclePainter(Color(0xFFEA0BFD), Color(0xFF6503B1),
              Offset(size.width, size.height - 100)),
        ),
        ClipRRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 250.0, sigmaY: 250.0),
            child: Container(
              width: size.width,
              height: size.height,
              color: Color(0xC1FFFFFF),
            ),
          ),
        )
      ],
    );
  }
}

class CirclePainter extends CustomPainter {
  Color? color1;
  Color? color2;

  Offset? offset;

  CirclePainter(this.color1, this.color2, this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader = ui.Gradient.linear(
          Offset(0, 0), Offset(size.width * 2.5, size.height * 2.5), [
        color1!,
        color2!,
      ])
      ..style = PaintingStyle.fill;

    canvas.drawCircle(offset!, size.width, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
