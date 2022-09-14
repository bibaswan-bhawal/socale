import 'package:flutter/material.dart';

class GradientBorderCard extends StatelessWidget {
  final Size size;
  final Color baseColor;
  final List<Color> gradientColor;

  const GradientBorderCard({
    Key? key,
    required this.size,
    required this.baseColor,
    required this.gradientColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 14),
            child: Container(
              height: size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColor,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(left: 12, right: 12, bottom: 16),
            child: Container(
              height: size.height - 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: baseColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
