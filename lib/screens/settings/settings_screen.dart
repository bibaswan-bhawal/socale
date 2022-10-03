import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/primary_button_wi_icon_solid.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/values/colors.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  void onClickEventHandler() {}
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
          Column(
            children: [
              Container(
                height: 100,
                color: Color(0xFF363636),
                child: KeyboardSafeArea(
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15, top: 20),
                        child: IconButton(
                          onPressed: () => onBack(context),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: ColorValues.textOnDark,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Center(
                          child: Column(
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
                        ),
                      )
                    ],
                  ),
                ),
              ),
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
                    onClickEventHandler: onClickEventHandler,
                    textColor: ColorValues.textOnLight,
                    icon: SvgPicture.asset(
                      'assets/icons/log_out_icon.svg',
                      color: ColorValues.textOnLight,
                    ),
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
