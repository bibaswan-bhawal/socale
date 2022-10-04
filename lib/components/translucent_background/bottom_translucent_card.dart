import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:socale/components/Painters/BackgroundPainter/BackgroundPainter.dart';
import 'package:socale/components/Painters/BackgroundPainter/card_background.dart';
import 'package:socale/components/Painters/CirclePainter/CirclePainter.dart';

class BottomTranslucentCard extends StatelessWidget {
  const BottomTranslucentCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF2D2D2D),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(200, 200),
            painter: CirclePainter(
              Color(0xFFEA0BFD),
              Color(0xFF6503B1),
              Offset(size.width / 2, size.height + 50),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: CustomPaint(
              painter: CardBackground(),
            ),
          ),
        ],
      ),
    );
  }
}
