import 'package:flutter/material.dart';
import 'package:socale/values/strings.dart';
import 'package:socale/values/styles.dart';

class EmailVerificationHeader extends StatelessWidget {
  final Size size;
  const EmailVerificationHeader({Key? key, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/onboarding_illustration_2.png',
          height: size.height / 2.2,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
          child: Text(
            StringValues.emailVerificationHeading,
            style: StyleValues.heading1Style,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: SizedBox(
            width: 280,
            child: Text(
              StringValues.emailVerificationDescription,
              style: StyleValues.description1Style,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
