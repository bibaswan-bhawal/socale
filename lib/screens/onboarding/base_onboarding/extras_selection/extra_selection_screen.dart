import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/pickers/grid_item_picker/grid_item_picker.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/onboarding/base_onboarding/base_onboarding_screen_interface.dart';

class ExtraSelectionScreen extends BaseOnboardingScreen {
  const ExtraSelectionScreen({super.key});

  @override
  BaseOnboardingScreenState createState() => _ExtraSelectionScreenState();
}

class _ExtraSelectionScreenState extends BaseOnboardingScreenState {
  @override
  Future<bool> onBack() async {
    return true;
  }

  @override
  Future<bool> onNext() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: size.height * 0.05),
          child: SimpleShadow(
            opacity: 0.1,
            offset: const Offset(1, 1),
            sigma: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add more stuff',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: size.width * (24 / 414),
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'to your ',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: size.width * (24 / 414),
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => ColorValues.orangeTextGradient.createShader(bounds),
                      child: Text(
                        'profile',
                        style: GoogleFonts.poppins(
                          fontSize: size.width * (24 / 414),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 48, right: 48, top: 48),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 32,
              crossAxisSpacing: 32,
              childAspectRatio: 124 / 165,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                GridItemPicker(
                  title: 'Languages',
                  borderGradient: ColorValues.purpleGradient,
                  selectedData: const ['English', 'Spanish', 'French'],
                  icon: Image.asset('assets/illustrations/illustration_10.png'),
                  onTap: () {},
                ),
                GridItemPicker(
                  title: 'Interests',
                  borderGradient: ColorValues.lightBlueGradient,
                  selectedData: const [],
                  icon: Image.asset('assets/illustrations/illustration_9.png'),
                  onTap: () {},
                ),
                GridItemPicker(
                  title: 'clubs',
                  borderGradient: ColorValues.orangeGradient,
                  selectedData: const ['English', 'Spanish', 'French'],
                  icon: Image.asset('assets/illustrations/illustration_11.png'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        Text(
          'You can add or change anything about your\n'
          'profile from the account tab at any time.',
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: size.width * (12 / 414),
            letterSpacing: -0.3,
            color: ColorValues.textSubtitle,
          ),
        ),
      ],
    );
  }
}
