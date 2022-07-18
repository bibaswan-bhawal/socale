import 'package:flutter/material.dart';

import '../social_sign_in_buttons.dart';

class SocialSignInButtonGroup extends StatelessWidget {
  const SocialSignInButtonGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        SocialSignInButton(
          width: size.width,
          height: 60,
          text: "Sign In with Google",
          onClickEventHandler: () => {},
        ),
        SocialSignInButton(
          width: size.width,
          height: 60,
          text: "Sign In with Facebook",
          onClickEventHandler: () => {},
        ),
        SocialSignInButton(
          width: size.width,
          height: 60,
          text: "Sign In with Apple",
          onClickEventHandler: () => {},
        )
      ],
    );
  }
}
