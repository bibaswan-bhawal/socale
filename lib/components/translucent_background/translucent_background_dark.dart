import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:socale/components/Painters/BackgroundPainter/BackgroundPainter.dart';
import 'package:socale/components/Painters/BackgroundPainter/BackgroundPainterDark.dart';
import 'package:socale/components/Painters/CirclePainter/CirclePainter.dart';

class TranslucentBackgroundDark extends StatelessWidget {
  final int state;

  const TranslucentBackgroundDark({Key? key, this.state = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomPaint(
            size: Size(200, 200),
            painter: CirclePainter(
              Color(0xFF39EDFF),
              Color(0xFF0051E1),
              Offset(0, 100),
            ),
          ),
          CustomPaint(
            size: Size(200, 200),
            painter: CirclePainter(
              Color(0xFFF151DD),
              Color(0xFF7E3ECF),
              Offset(size.width, size.height - 100),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
            child: CustomPaint(
              painter: BackgroundPainterDark(),
            ),
          ),
        ],
      ),
    );
  }
}
