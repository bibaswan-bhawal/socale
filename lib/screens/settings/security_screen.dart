import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/components/translucent_background/bottom_translucent_card.dart';
import 'package:socale/screens/settings/password_screen.dart';
import 'package:socale/utils/constraints/constraints.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/values/colors.dart';

class SecurityPage extends ConsumerStatefulWidget {
  const SecurityPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends ConsumerState<SecurityPage> {
  void onBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userAsyncController);

    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF2D2D2D),
      body: Stack(
        children: [
          BottomTranslucentCard(),
          Column(
            children: [
              Container(
                height: constraints.settingsPageAppBarHeight,
                color: Color(0xFF363636),
                child: KeyboardSafeArea(
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => onBack(context),
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: ColorValues.textOnDark,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Security & Password",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.3,
                                color: ColorValues.textOnDark,
                              ),
                            ),
                            Text(
                              "${userState.value!.firstName} ${userState.value!.lastName}",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.3,
                                color: ColorValues.textOnDark,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 8),
                  children: [
                    ListTile(
                      leading: SvgPicture.asset(
                        'assets/icons/key_icon.svg',
                        width: 24,
                      ),
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        "Change Password",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                          color: ColorValues.textOnDark,
                        ),
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          text: "View and change information about your account.",
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.3,
                            foreground: Paint()..shader = ColorValues.socaleLightPurpleGradient,
                          ),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      trailing: SvgPicture.asset('assets/icons/arrow_right.svg'),
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ChangePasswordPage(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SharedAxisTransition(
                                animation: animation,
                                secondaryAnimation: secondaryAnimation,
                                transitionType: SharedAxisTransitionType.horizontal,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
