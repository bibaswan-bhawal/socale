// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

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
    return true;
  }
}
