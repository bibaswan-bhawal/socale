import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/avatar_selector/avatar_selector.dart';
import 'package:socale/components/avatar_selector_item/avatar_selector_item.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/components/nest_will_pop_scope.dart';
import 'package:socale/screens/onboarding/onboarding_screen.dart';
import 'package:socale/screens/onboarding/providers/avatar_data_provider.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/enums/onboarding_fields.dart';
import 'package:socale/utils/options/avatars.dart';
import 'package:socale/values/colors.dart';

class AvatarSelectionPage extends ConsumerStatefulWidget {
  const AvatarSelectionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AvatarSelectionPage> createState() => _AvatarSelectionPageState();
}

class _AvatarSelectionPageState extends ConsumerState<AvatarSelectionPage> {
  late PageController _pageController;
  late PageController _avatarSelector;

  File? profilePic;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final dataProvider = ref.watch(avatarDataProvider);
    _avatarSelector = PageController(initialPage: dataProvider.getCurrentAvatar);
  }

  Future<bool> _onBackPress() async {
    onboardingService.setOnboardingStep(OnboardingStep.situationalDecisions);
    _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    return false;
  }

  void _onClickEventHandler() {
    final dataNotifier = ref.watch(avatarDataProvider.notifier);
    dataNotifier.uploadData();
    onboardingService.setOnboardingStep(OnboardingStep.completed);
    _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    _pageController = ref.watch(onboardingPageController);

    final dataNotifier = ref.watch(avatarDataProvider.notifier);

    final size = MediaQuery.of(context).size;

    return NestedWillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        body: KeyboardSafeArea(
          child: Stack(
            children: [
              Positioned(
                left: 10,
                top: 20,
                child: IconButton(
                  onPressed: _onBackPress,
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 90, left: 30),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Choose an ',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Avatar',
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()..shader = ColorValues.socaleOrangeGradient,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 30, right: 80, top: 5),
                      child: Text(
                        "This will be your avatar until you decide to share your profile",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Color(0xFF606060),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: PageView(
                              controller: _avatarSelector,
                              physics: BouncingScrollPhysics(),
                              children: [
                                for (String avatar in avatars)
                                  AvatarSelectorItem(image: 'assets/images/avatars/$avatar', sub: avatar.replaceAll('.png', '')),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          width: size.width,
                          child: AvatarSelector(
                            onChange: (value) {
                              dataNotifier.setCurrentAvatar(value);
                              _avatarSelector.animateToPage(value, duration: Duration(milliseconds: 300), curve: Curves.easeInOutCirc);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: PrimaryButton(
                      width: size.width,
                      height: 60,
                      colors: [Color(0xFFFD6C00), Color(0xFFFFA133)],
                      text: "Continue",
                      onClickEventHandler: _onClickEventHandler,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
