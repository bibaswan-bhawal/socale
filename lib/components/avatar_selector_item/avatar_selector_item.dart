import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/values/colors.dart';

class AvatarSelectorItem extends StatelessWidget {
  final String image;
  final String sub;
  final bool? isDark;

  const AvatarSelectorItem(
      {Key? key, required this.image, required this.sub, this.isDark})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: 25),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(image),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              sub,
              style: GoogleFonts.poppins(
                color: isDark != null
                    ? Colors.white.withOpacity(0.5)
                    : ColorValues.elementColor.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
