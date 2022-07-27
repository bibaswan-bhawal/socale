import 'package:flutter/cupertino.dart';

import 'package:socale/components/Painters/BackgroundPainter/BackgroundPainter.dart';
import 'package:socale/components/Painters/CirclePainter/CirclePainter.dart';

class TranslucentBackground extends StatelessWidget {
  final bool change;

  const TranslucentBackground({Key? key, this.change = false})
      : super(key: key);

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
            Offset(change ? size.width : 0, 100),
          ),
        ),
        CustomPaint(
          size: Size(200, 200),
          painter: CirclePainter(
            Color(0xFFEA0BFD),
            Color(0xFF6503B1),
            Offset(change ? 0 : size.width, size.height - 100),
          ),
        ),
        Transform.translate(
          offset: Offset(0, 0),
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: CupertinoPopupSurface(
              isSurfacePainted: false,
            ),
          ),
        ),
        CustomPaint(
          size: Size(size.width, size.height),
          painter: BackgroundPainter(),
        ),
      ],
    );
  }
}
