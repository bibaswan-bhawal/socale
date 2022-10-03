// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

class BackgroundPainterDark extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFF292B2F).withOpacity(0.95)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.largest, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
