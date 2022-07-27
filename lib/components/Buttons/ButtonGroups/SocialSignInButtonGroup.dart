import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/enums/social_item.dart';
import '../social_sign_in_button.dart';

class SocialSignInButtonGroup extends StatelessWidget {
  final String text;
  final Function(AuthProvider) handler;

  const SocialSignInButtonGroup(
      {Key? key, required this.text, required this.handler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        SocialSignInButton(
          width: size.width,
          icon: SvgPicture.asset(
            "assets/icons/google_logo.svg",
            width: 24,
          ),
          item: SocialItem.google,
          height: 60,
          text: '$text with Google',
          onClickEventHandler: () => {
            handler(AuthProvider.google),
          },
        ),
        SocialSignInButton(
          width: size.width,
          icon: SvgPicture.asset(
            "assets/icons/facebook_logo.svg",
            width: 24,
            color: Colors.white,
          ),
          item: SocialItem.facebook,
          height: 60,
          text: "$text with Facebook",
          onClickEventHandler: () => {
            handler(AuthProvider.facebook),
          },
        ),
        SocialSignInButton(
          width: size.width,
          icon: SvgPicture.asset(
            "assets/icons/apple_logo.svg",
            width: 24,
            color: Colors.white,
          ),
          item: SocialItem.apple,
          height: 60,
          text: "$text with Apple",
          onClickEventHandler: () => {
            handler(AuthProvider.apple),
          },
        )
      ],
    );
  }
}
