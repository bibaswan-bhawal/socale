import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/utils/enums/social_item.dart';
import 'package:socale/values/colors.dart';
import '../../../utils/enums/social_item.dart';

class SocialSignInButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final SvgPicture icon;
  final SocialItem item;

  final Function() onClickEventHandler;

  const SocialSignInButton(
      {Key? key,
      required this.width,
      required this.height,
      required this.text,
      required this.item,
      required this.icon,
      required this.onClickEventHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle;
    TextStyle textStyle;

    switch (item) {
      case SocialItem.google:
        buttonStyle = ElevatedButton.styleFrom(
          fixedSize: Size(width, height),
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          primary: ColorValues.googleColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );

        textStyle = GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black.withOpacity(0.54),
        );
        break;
      case SocialItem.facebook:
        buttonStyle = ElevatedButton.styleFrom(
          fixedSize: Size(width, height),
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          primary: ColorValues.facebookColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );

        textStyle = GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        );
        break;
      case SocialItem.apple:
        buttonStyle = ElevatedButton.styleFrom(
          fixedSize: Size(width, height),
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          primary: ColorValues.appleColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );

        textStyle = GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        );
        break;
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: ElevatedButton.icon(
        onPressed: () {
          onClickEventHandler();
        },
        style: buttonStyle,
        icon: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: icon,
        ),
        label: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
