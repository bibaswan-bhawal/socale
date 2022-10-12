import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/components/switches/settings_switch.dart';
import 'package:socale/components/translucent_background/bottom_translucent_card.dart';
import 'package:socale/utils/constraints/constraints.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/values/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPage extends ConsumerStatefulWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends ConsumerState<PrivacyPage> {
  bool shareProfile = true;

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
                              "Your Privacy",
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
                      leading: SvgPicture.asset('assets/icons/group_icon.svg',
                          width: 18),
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.only(
                          left: 16, top: 8, bottom: 8, right: 16),
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        "Share Profile",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                          color: ColorValues.textOnDark,
                        ),
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          text: "Let others view and match with your profile.",
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.3,
                            foreground: Paint()
                              ..shader = ColorValues.socaleLightPurpleGradient,
                          ),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      trailing: SettingsSwitch(
                        thumbColor: shareProfile
                            ? Color(0xFFFFFFFF)
                            : Color(0xFF777777),
                        trackColor: shareProfile
                            ? Color(0xFFFFA133)
                            : Color(0xFF505050),
                        activeColor: Color(0xFFFFA133),
                        onChanged: (bool? value) =>
                            setState(() => shareProfile = value ?? true),
                        value: shareProfile,
                      ),
                    ),
                    ListTile(
                      leading:
                          SvgPicture.asset('assets/icons/support_icon.svg'),
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.only(
                          left: 16, top: 8, bottom: 8, right: 20),
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        "Privacy Policy",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                          color: ColorValues.textOnDark,
                        ),
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          text: "Read our privacy policy to learn more.",
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.3,
                            foreground: Paint()
                              ..shader = ColorValues.socaleLightPurpleGradient,
                          ),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      trailing:
                          SvgPicture.asset('assets/icons/external_icon.svg'),
                      onTap: () {
                        launchUrl(
                          Uri.parse('socale.co/privacypolicy'),
                          mode: LaunchMode.externalApplication,
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
