import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:socale/utils/measure_size.dart';

import '../../../../theme/size_config.dart';
import '../../../components/gap.dart';

class AccountChillCard extends StatelessWidget {
  final String title;
  final ValueNotifier<double>? height;

  const AccountChillCard({
    Key? key,
    required this.title,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GlassmorphicContainer(
          height: sy * 30,
          width: sy * 30,
          shape: BoxShape.circle,
          borderRadius: 20,
          blur: 20,
          alignment: Alignment.bottomCenter,
          border: 0,
          linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFffffff).withOpacity(0.1),
                Color(0xFFFFFFFF).withOpacity(0.05),
              ],
              stops: [
                0.1,
                1,
              ]),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFffffff).withOpacity(0.5),
              Color((0xFFFFFFFF)).withOpacity(0.5),
            ],
          ),
          child: Center(
            child: Text('0'),
          ),
        ),
        Gap(height: 1),
        MeasureSize(
            onChange: (Size size) {
              height?.value = size.height + sy * 30 + sx * 1;
            },
            child: Text(title)),
      ],
    );
  }
}
