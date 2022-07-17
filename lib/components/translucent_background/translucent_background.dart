import 'package:flutter/cupertino.dart';

import 'package:socale/components/Painters/BackgroundPainter/BackgroundPainter.dart';
import 'package:socale/components/Painters/CirclePainter/CirclePainter.dart';

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
            Color(0xFF39EDFF),
            Color(0xFF0051E1),
            Offset(0, 100),
          ),
        ),
        CustomPaint(
          size: Size(200, 200),
          painter: CirclePainter(
            Color(0xFFEA0BFD),
            Color(0xFF6503B1),
            Offset(size.width, size.height - 100),
          ),
        ),
        CupertinoPopupSurface(
          isSurfacePainted: false,
          child: CustomPaint(
            size: size,
            painter: BackgroundPainter(),
          ),
        ),
      ],
    );
  }
}
