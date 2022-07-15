import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/translucent_background/translucent_background.dart';
import 'package:get/get.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark));

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          TranslucentBackground(),
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
                        "Making Networking Easier",
                        style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            textStyle: TextStyle(
                              color: const Color(0xFF252525),
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(1, 2),
                                  blurRadius: 3,
                                  color: const Color(0x19252525),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: SizedBox(
                        width: 303,
                        child: Text(
                          "Boost your social and professional connections with the power of Socale.",
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            textStyle: TextStyle(
                              color: const Color(0xE1383838),
                              letterSpacing: -1,
                              height: 1.2,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment(0.8, 1),
                              colors: [Color(0xFFFD6C00), Color(0xFFFFA133)]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.offAllNamed('/login');
                          },
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(size.width - 60, 60),
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              primary: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              splashFactory: InkRipple.splashFactory),
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                      child: OutlinedButton(
                        onPressed: () {
                          //Get.offAllNamed('/register');
                        },
                        style: OutlinedButton.styleFrom(
                          fixedSize: Size(size.width - 60, 60),
                          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          side: BorderSide(
                              width: 2, color: const Color(0xFF000000)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          primary: Colors.transparent,
                          splashFactory: InkRipple.splashFactory,
                        ),
                        child: Text(
                          "Register",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
