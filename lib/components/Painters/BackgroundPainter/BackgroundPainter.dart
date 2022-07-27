import 'package:flutter/cupertino.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFFFFFFFF).withOpacity(0.90)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTRB(-10, -10, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
