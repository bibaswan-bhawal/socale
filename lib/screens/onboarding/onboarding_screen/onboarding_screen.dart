import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/translucent_background/translucent_background.dart';
import 'package:socale/screens/onboarding/onboarding_screen/academics_page.dart';
import 'package:socale/screens/onboarding/onboarding_screen/basics_page.dart';
import 'package:socale/screens/onboarding/onboarding_screen/intro_page.dart';
import 'package:socale/screens/onboarding/onboarding_screen/skills_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final GlobalObjectKey<AcademicsPageState> _detailsKey =
      GlobalObjectKey<AcademicsPageState>("f");
  final _controller = PageController(initialPage: 0);
  int index = 0;
  int detailsIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          TranslucentBackground(),
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            reverse: true,
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: size.height - 100,
                      child: PageView(
                        controller: _controller,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          IntroPage(),
                          BasicsPage(),
                          AcademicsPage(
                            key: _detailsKey,
                          ),
                          SkillsPage(),
                        ],
                        onPageChanged: (value) => setState(() => index = value),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: PrimaryButton(
                        width: size.width,
                        height: 60,
                        colors: [Color(0xFFFD6C00), Color(0xFFFFA133)],
                        text: "Continue",
                        onClickEventHandler: () {
                          if (_controller.page == 2 && detailsIndex != 1) {
                            _detailsKey.currentState?.nextPage();
                            detailsIndex++;
                            return;
                          }
                          detailsIndex = 0;
                          _controller.nextPage(
                              curve: Curves.easeInOut,
                              duration: Duration(milliseconds: 300));
                        },
                      ),
                    ),
                  ],
                ),
                if (index > 0)
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 50, 0, 0),
                    child: IconButton(
                      onPressed: () {
                        if (_controller.page == 2 && detailsIndex == 1) {
                          _detailsKey.currentState?.previousPage();
                          detailsIndex--;
                          return;
                        }
                        detailsIndex = 0;
                        _controller.previousPage(
                            curve: Curves.easeInOut,
                            duration: Duration(milliseconds: 300));
                      },
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
