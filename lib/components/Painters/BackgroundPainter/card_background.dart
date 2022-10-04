// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

class CardBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFF2D2D2D).withOpacity(0.85)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.largest, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
