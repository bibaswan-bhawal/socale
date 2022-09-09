import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/components/nest_will_pop_scope.dart';
import 'package:socale/components/snackbar/onboarding_snackbars.dart';
import 'package:socale/screens/onboarding/onboarding_screen.dart';
import 'package:socale/screens/onboarding/providers/describe_friend_data_provider.dart';
import 'package:socale/services/onboarding_service.dart';
import 'package:socale/utils/enums/onboarding_fields.dart';
import 'package:socale/values/colors.dart';

class DescribeFriendPage extends ConsumerStatefulWidget {
  const DescribeFriendPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DescribeFriendPage> createState() => _DescribeFriendPageState();
}

class _DescribeFriendPageState extends ConsumerState<DescribeFriendPage> {
  late PageController _pageController;
  late StreamSubscription<bool> keyboardSubscription;

  bool isShowing = false;
  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible && isShowing) {
        Navigator.pop(context, true);
      }
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  void _onClickEventHandler() {
    final dataProvider = ref.watch(describeFriendDataProvider);
    final dataNotifier = ref.watch(describeFriendDataProvider.notifier);

    if (dataProvider.getDescription.isEmpty) {
      onboardingSnackBar.addFriendSnack(context);
      return;
    }

    dataNotifier.uploadFriendDescription();
    onboardingService.setOnboardingStep(OnboardingStep.situationalDecisions);
    _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Future<bool> _onBackPress() async {
    FocusManager.instance.primaryFocus?.unfocus();
    onboardingService.setOnboardingStep(OnboardingStep.leisureInterests);
    _pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    _pageController = ref.watch(onboardingPageController);

    final dataProvider = ref.watch(describeFriendDataProvider);

    final size = MediaQuery.of(context).size;

    return NestedWillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 100, left: 30),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'What is your ideal ',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'friend?',
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
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        "In my free time I like to...",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Color(0xFF606060),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40, right: 40, top: 40),
                    child: Image.asset('assets/images/onboarding_illustration_6.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: OpenContainer(
                      closedColor: Color(0xFFF8F8F8),
                      openColor: Color(0xFFEBEAEB),
                      closedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      closedBuilder: (BuildContext context, VoidCallback closeContainer) {
                        return SizedBox(
                          height: 200,
                          width: size.width,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                              child: Text(
                                dataProvider.getDescription.isNotEmpty ? dataProvider.getDescription : "Type Here...",
                                style: GoogleFonts.poppins(
                                  color: Color(0x7F000000),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      openBuilder: (BuildContext context, VoidCallback openContainer) {
                        isShowing = true;
                        return EditTextArea();
                      },
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
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
        ),
      ),
    );
  }
}

class EditTextArea extends ConsumerStatefulWidget {
  const EditTextArea({Key? key}) : super(key: key);

  @override
  ConsumerState<EditTextArea> createState() => _EditTextAreaState();
}

class _EditTextAreaState extends ConsumerState<EditTextArea> {
  final TextEditingController _controller = TextEditingController();

  bool gotData = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final dataProvider = ref.watch(describeFriendDataProvider);
    final dataNotifier = ref.watch(describeFriendDataProvider.notifier);

    if (!gotData) {
      _controller.text = dataProvider.getDescription;
      setState(() => gotData = dataProvider.getGotData);
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SizedBox(
            height: size.height,
            child: Stack(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Type Here...",
                    border: InputBorder.none,
                    counterText: "",
                  ),
                  onChanged: dataNotifier.setDescription,
                  autofocus: true,
                  maxLength: 1000,
                  maxLines: null,
                  textInputAction: TextInputAction.done,
                ),
                Positioned(
                  bottom: 20,
                  right: 0,
                  child: Text("${dataProvider.getDescription.length} / 1000"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
