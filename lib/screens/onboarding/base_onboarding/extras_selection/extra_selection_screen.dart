import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/components/pickers/list_input_picker/list_input_picker.dart';
import 'package:socale/components/input_fields/grid_item_input_field/grid_item_form_field.dart';
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
                      shaderCallback: (bounds) => AppColors.orangeTextGradient.createShader(bounds),
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
            padding: const EdgeInsets.only(left: 48, right: 48, top: 36),
            child: Form(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 32,
                crossAxisSpacing: 32,
                childAspectRatio: 124 / 165,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  GridItemFormField(
                    title: 'Languages',
                    icon: Image.asset('assets/illustrations/illustration_10.png'),
                    borderGradient: AppColors.purpleGradient,
                    inputPicker: ListInputPickerBuilder<String>(
                      selectedData: const ['English'],
                      data: const ['English', 'Spanish', 'French'],
                      searchHintText: 'Search languages',
                    ),
                    initialData: const ['English'],
                    data: const ['English', 'Spanish', 'French'],
                  ),
                  GridItemFormField(
                    title: 'Interests',
                    icon: Image.asset('assets/illustrations/illustration_9.png'),
                    borderGradient: AppColors.lightBlueGradient,
                    inputPicker: ListInputPickerBuilder<String>(
                      selectedData: const [],
                      data: const ['English', 'Spanish', 'French'],
                      searchHintText: 'Search languages',
                    ),
                    initialData: const [],
                    data: const ['English', 'Spanish', 'French'],
                  ),
                  GridItemFormField(
                    title: 'clubs',
                    icon: Image.asset('assets/illustrations/illustration_11.png'),
                    borderGradient: AppColors.orangeGradient,
                    inputPicker: ListInputPickerBuilder<String>(
                      selectedData: const [],
                      data: const ['English', 'Spanish', 'French'],
                      searchHintText: 'Search languages',
                    ),
                    initialData: const [],
                    data: const ['English', 'Spanish', 'French'],
                  ),
                ],
              ),
            ),
          ),
        ),
        Text(
          'You can add or change anything about your\n'
          'profile from the account tab at any time.',
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            letterSpacing: -0.3,
            fontSize: size.width * (12 / 414),
            color: AppColors.subtitle,
          ),
        ),
      ],
    );
  }
}
