import 'package:flutter/material.dart';
import 'package:socale/components/text/gradient_headline.dart';

class AcademicInfoHeader extends StatelessWidget {
  const AcademicInfoHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 36),
          child: GradientHeadline(
            headlinePlain: 'Let’s find you some',
            headlineColored: 'classmates',
            newLine: true,
          ),
        ),
        Expanded(child: Image.asset('assets/illustrations/illustration_2.png')),
      ],
    );
  }
}
