import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:socale/theme/size_config.dart';
import 'package:socale/theme/text_styles.dart';

class AccountCareAboutCard extends StatelessWidget {
  const AccountCareAboutCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      height: sx * 8,
      width: sy * 70,
      shape: BoxShape.circle,
      borderRadius: 16,
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
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: sy * 5,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quiet Space',
                style: SocaleTextStyles.personalityHeading,
              ),
              Chip(
                label: Text('Lv 5'),
                backgroundColor: Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
