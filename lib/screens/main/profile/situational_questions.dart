import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/values/colors.dart';

class SituationalQuestionsPage extends ConsumerStatefulWidget {
  const SituationalQuestionsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SituationalQuestionsPage> createState() => _SituationalQuestionsPageState();
}

class _SituationalQuestionsPageState extends ConsumerState<SituationalQuestionsPage> {
  List<int> answer = [0, 0, 0, 0, 0];
  File? profilePicture;
  int pageIndex = 0;
  bool _saveButtonEnabled = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userState = ref.watch(userAsyncController);
    answer = userState.value!.situationalDecisions;
  }

  void onSaveData(BuildContext context) {
    final userState = ref.watch(userAsyncController);
    final userStateNotifier = ref.watch(userAsyncController.notifier);
    userStateNotifier.changeUserValue(userState.value!.copyWith(situationalDecisions: answer));
    Navigator.pop(context);
  }

  void onBack() async {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userAsyncController);
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;

    return Scaffold(
      backgroundColor: Color(0xFF292B2F),
      body: KeyboardSafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => onBack(),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: ColorValues.textOnDark,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Image.asset(
                        'assets/images/socale_logo_bw.png',
                        height: 50,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 220.0,
                        enlargeStrategy: CenterPageEnlargeStrategy.scale,
                        viewportFraction: 0.4,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        autoPlay: false,
                        onPageChanged: (index, _) => setState(() => pageIndex = index),
                      ),
                      items: [
                        Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: CircleAvatar(
                            radius: 80,
                            child: Image.asset('assets/images/avatars/${userState.value!.avatar}'),
                          ),
                        ),
                        Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: CircleAvatar(
                                radius: 80,
                                backgroundColor: Color(0xFF494949),
                                child: ClipOval(
                                  child: profilePicture != null
                                      ? Image.file(profilePicture!)
                                      : SvgPicture.asset('assets/icons/add_picture_icon.svg'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    AnimatedSmoothIndicator(
                      activeIndex: pageIndex,
                      count: 2,
                      effect: ExpandingDotsEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        activeDotColor: ColorValues.socaleDarkOrange,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "${userState.value!.firstName} ${userState.value!.lastName}",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: ColorValues.textOnDark,
                        ),
                      ),
                    ),
                    Text(
                      "${userState.value!.major.toString().replaceAll('[', '').replaceAll(']', '')} | ${userState.value!.college}",
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorValues.textOnDark,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30, bottom: 15),
                      child: Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                "You like to devote time to explore topics that pique your interest.",
                                style: GoogleFonts.roboto(
                                  color: Colors.white.withOpacity(0.69),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  letterSpacing: -0.3,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: Column(
                              children: [
                                Material(
                                  color: Color(0xFF8D8D8D).withOpacity(0.01),
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Slider(
                                    activeColor: ColorValues.socaleOrange,
                                    inactiveColor: Colors.white.withOpacity(0.1),
                                    value: answer[0].toDouble(),
                                    max: 100,
                                    onChanged: (value) {
                                      setState(() => answer[0] = value.toInt());
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Disagree",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white.withOpacity(0.69),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "Agree",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white.withOpacity(0.69),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                "You have multiple backups in case some don’t plan out.",
                                style: GoogleFonts.roboto(
                                  color: Colors.white.withOpacity(0.69),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  letterSpacing: -0.3,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: Column(
                              children: [
                                Material(
                                  color: Color(0xFF8D8D8D).withOpacity(0.01),
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Slider(
                                    activeColor: ColorValues.socaleOrange,
                                    inactiveColor: Colors.white.withOpacity(0.1),
                                    value: answer[1].toDouble(),
                                    max: 100,
                                    onChanged: (value) {
                                      setState(() => answer[1] = value.toInt());
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Disagree",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white.withOpacity(0.69),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "Agree",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white.withOpacity(0.69),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                "When under a lot of pressure, you find yourself able to remain calm and collected.",
                                style: GoogleFonts.roboto(
                                  color: Colors.white.withOpacity(0.69),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  letterSpacing: -0.3,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: Column(
                              children: [
                                Material(
                                  color: Color(0xFF8D8D8D).withOpacity(0.01),
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Slider(
                                    activeColor: ColorValues.socaleOrange,
                                    inactiveColor: Colors.white.withOpacity(0.1),
                                    value: answer[2].toDouble(),
                                    max: 100,
                                    onChanged: (value) {
                                      setState(() => answer[2] = value.toInt());
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Disagree",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white.withOpacity(0.69),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "Agree",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white.withOpacity(0.69),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                "You usually follow your head more than your heart when making decisions.",
                                style: GoogleFonts.roboto(
                                  color: Colors.white.withOpacity(0.69),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  letterSpacing: -0.3,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: Column(
                              children: [
                                Material(
                                  color: Color(0xFF8D8D8D).withOpacity(0.01),
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Slider(
                                    activeColor: ColorValues.socaleOrange,
                                    inactiveColor: Colors.white.withOpacity(0.1),
                                    value: answer[3].toDouble(),
                                    max: 100,
                                    onChanged: (value) {
                                      setState(() => answer[3] = value.toInt());
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Disagree",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white.withOpacity(0.69),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "Agree",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white.withOpacity(0.69),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                "Before starting a new project, you prefer to have your other projects finished.",
                                style: GoogleFonts.roboto(
                                  color: Colors.white.withOpacity(0.69),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  letterSpacing: -0.3,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: Column(
                              children: [
                                Material(
                                  color: Color(0xFF8D8D8D).withOpacity(0.01),
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Slider(
                                    activeColor: ColorValues.socaleOrange,
                                    inactiveColor: Colors.white.withOpacity(0.1),
                                    value: answer[4].toDouble(),
                                    max: 100,
                                    onChanged: (value) {
                                      setState(() => answer[4] = value.toInt());
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Disagree",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white.withOpacity(0.69),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "Agree",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white.withOpacity(0.69),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: PrimaryButton(
                        enabled: _saveButtonEnabled,
                        width: size.width - 30,
                        height: 58,
                        text: "Save your answers",
                        colors: [
                          ColorValues.socaleOrange,
                          ColorValues.socaleDarkOrange,
                        ],
                        onClickEventHandler: () {
                          setState(() {
                            _saveButtonEnabled = false;
                          });
                          onSaveData(context);
                          setState(() {
                            _saveButtonEnabled = true;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
