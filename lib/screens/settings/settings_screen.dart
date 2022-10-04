import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/primary_button_wi_icon_solid.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/components/translucent_background/bottom_translucent_card.dart';
import 'package:socale/screens/settings/account_screen.dart';
import 'package:socale/screens/settings/notifications_screen.dart';
import 'package:socale/screens/settings/privacy_screen.dart';
import 'package:socale/screens/settings/security_screen.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/utils/constraints/constraints.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/values/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  void onClickEventHandler(WidgetRef ref) {
    authService.signOutCurrentUser(ref);
  }

  void onBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                              "Settings",
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
                      leading: SvgPicture.asset('assets/icons/account_icon.svg'),
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        "Your Account",
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
                            pageBuilder: (context, animation, secondaryAnimation) => AccountPage(),
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
                    ListTile(
                      leading: SvgPicture.asset('assets/icons/security_icon.svg'),
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        "Security & Password",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                          color: ColorValues.textOnDark,
                        ),
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          text: "Change your password and adjust your security settings.",
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
                            pageBuilder: (context, animation, secondaryAnimation) => SecurityPage(),
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
                    ListTile(
                      leading: SvgPicture.asset('assets/icons/privacy_icon.svg'),
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        "Your Privacy",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                          color: ColorValues.textOnDark,
                        ),
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          text: "Adjust what information others can see.",
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
                            pageBuilder: (context, animation, secondaryAnimation) => PrivacyPage(),
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
                    ListTile(
                      leading: SvgPicture.asset('assets/icons/notification_icon.svg'),
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        "Notifications",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                          color: ColorValues.textOnDark,
                        ),
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          text: "Select what notifications you receive.",
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
                            pageBuilder: (context, animation, secondaryAnimation) => NotificationsPage(),
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
                    ListTile(
                      leading: SvgPicture.asset('assets/icons/support_icon.svg'),
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        "Support",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                          color: ColorValues.textOnDark,
                        ),
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          text: "Reach out to us if you have questions or concerns.",
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
                        launchUrl(
                          Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLScUhReI0LUNVtOf0oRvuTN-wB-ZFmf7OTFpJUcrXGGa181-RA/viewform'),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: PrimarySolidIconButton(
                    width: size.width - 60,
                    height: 54,
                    text: "Sign Out",
                    color: ColorValues.white,
                    onClickEventHandler: () => onClickEventHandler(ref),
                    textColor: ColorValues.textOnLight,
                    icon: SvgPicture.asset('assets/icons/log_out_icon.svg', color: ColorValues.textOnLight),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Made with Love at UC San Diego",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          letterSpacing: -0.3,
                          color: ColorValues.textOnDark,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        width: 16,
                        height: 16,
                        child: Image.asset('assets/icons/face-blowing-a-kiss.png', fit: BoxFit.fill),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
