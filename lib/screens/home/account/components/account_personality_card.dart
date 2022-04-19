import 'package:flutter/material.dart';
import 'package:socale/screens/components/gap.dart';
import 'package:socale/theme/colors.dart';
import 'package:socale/theme/size_config.dart';
import 'package:socale/theme/text_styles.dart';

class AccountPersonalityCard extends StatelessWidget {
  final bool selected;
  final String title;
  final String emoji;
  const AccountPersonalityCard({
    Key? key,
    this.selected = false,
    required this.title,
    required this.emoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sx * 10,
      width: sy * 70,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(25),
        border: selected
            ? Border.all(
                width: sy,
                color: SocaleColors.selectionColor,
              )
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: sy * 3,
          vertical: sx * 2,
        ),
        child: Center(
          child: Row(
            children: [
              Text(
                emoji,
                style: TextStyle(fontSize: sText * 7),
              ),
              Gap(width: 4),
              Text(
                title,
                style: SocaleTextStyles.personalityHeading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
