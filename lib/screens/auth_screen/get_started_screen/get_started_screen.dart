import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socale/components/Buttons/outlined_button.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/translucent_background/translucent_background.dart';
import 'package:socale/screens/auth_screen/auth_screen.dart';
import 'package:socale/values/strings.dart';
import 'package:socale/values/styles.dart';

class GetStartedScreen extends StatelessWidget {
  final Function() goToLogin;
  final Function() goToRegister;

  const GetStartedScreen(
      {Key? key, required this.goToLogin, required this.goToRegister})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 54,
                  child: Hero(
                    tag: "logo",
                    child: SvgPicture.asset(
                      'assets/icons/socale_logo_color.svg',
                      height: 54,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Image.asset(
                    'assets/images/onboarding_illustration_1.png',
                    height: size.height / 2.2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: Text(
                    StringValues.getStartedHeading,
                    style: StyleValues.heading2Style,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: SizedBox(
                    width: 303,
                    child: Text(
                      StringValues.getStartedDescription,
                      style: StyleValues.description2Style,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: PrimaryButton(
                    width: size.width - 60,
                    height: 60,
                    colors: [Color(0xFFFD6C00), Color(0xFFFFA133)],
                    text: "Login",
                    onClickEventHandler: goToLogin,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: CustomOutlinedButton(
                    width: size.width - 60,
                    height: 60,
                    text: "Register",
                    onClickEventHandler: goToRegister,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
