import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:animations/animations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:remove_emoji/remove_emoji.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:socale/components/Buttons/primary_button_wi_icon_solid.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/models/User.dart';
import 'package:socale/screens/main/profile/situational_questions.dart';
import 'package:socale/screens/settings/settings_screen.dart';
import 'package:socale/utils/options/academic_interests.dart';
import 'package:socale/utils/options/careers.dart';
import 'package:socale/utils/options/description_icon_options.dart';
import 'package:socale/utils/options/hobbies.dart';
import 'package:socale/utils/options/skills.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/values/colors.dart';

import '../../settings/account_screen.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late User currentUser;
  File? profilePicture;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();

    ref.read(userAsyncController).whenData((value) {
      String? newProfilePic = value.profilePicture;

      if (newProfilePic!.isNotEmpty) {
        getProfilePicture(newProfilePic);
      }
    });
  }

  Future<void> getProfilePicture(String key) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final filepath = '${documentsDir.path}/$key.jpg';
    final file = File(filepath);

    try {
      await Amplify.Storage.downloadFile(
        key: key,
        local: file,
        onProgress: (progress) {
          print('Fraction completed: ${progress.getFractionCompleted()}');
        },
      );

      print("downloaded photo");
      setState(() => profilePicture = file);
    } on StorageException catch (e) {
      print('Error downloading file: $e');
    }
  }

  void goToSettings() {
    Navigator.of(context)
        .push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                SettingsPage(
              startTime: DateTime.now(),
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                child: child,
              );
            },
          ),
        )
        .then((value) => null);
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<User>>(userAsyncController,
        (AsyncValue? previousState, AsyncValue newState) {
      String? newProfilePic = newState.value!.profilePicture;
      String? oldProfilePic = previousState?.value.profilePicture;

      if (previousState == null) {
        if (newProfilePic!.isNotEmpty) {
          getProfilePicture(newProfilePic);
        }
      } else {
        if (oldProfilePic != newProfilePic && newProfilePic!.isNotEmpty) {
          getProfilePicture(newProfilePic);
        }
      }
    });

    var userState = ref.watch(userAsyncController);

    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;

    return Scaffold(
      backgroundColor: Color(0xFF292B2F),
      body: KeyboardSafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: goToSettings,
                  behavior: HitTestBehavior.translucent,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, right: 20),
                    child:
                        SvgPicture.asset('assets/icons/settings_icon_24dp.svg'),
                  ),
                ),
              ),
              SizedBox(
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
                        onPageChanged: (index, _) =>
                            setState(() => pageIndex = index),
                      ),
                      items: [
                        Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: CircleAvatar(
                            radius: 80,
                            child: Image.asset(
                                'assets/images/avatars/${userState.value!.avatar}'),
                          ),
                        ),
                        Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          AccountPage(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return SharedAxisTransition(
                                          animation: animation,
                                          secondaryAnimation:
                                              secondaryAnimation,
                                          transitionType:
                                              SharedAxisTransitionType
                                                  .horizontal,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundColor: Color(0xFF494949),
                                  child: ClipOval(
                                    child: profilePicture != null
                                        ? Image.file(profilePicture!)
                                        : SvgPicture.asset(
                                            'assets/icons/add_picture_icon.svg'),
                                  ),
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
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
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
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, top: 20, bottom: 10),
                                  child: Text(
                                    "A little about me",
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.roboto(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: ColorValues.textOnDark
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 5,
                                children: [
                                  Chip(
                                    label: Text(
                                      userState.value!.major
                                          .toString()
                                          .replaceAll('[', '')
                                          .replaceAll(']', ''),
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w400,
                                        color: ColorValues.textOnDark
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                    backgroundColor: Color(0xFF3F3E3E),
                                    shape: StadiumBorder(
                                      side: BorderSide(
                                          color: ColorValues.socaleOrange),
                                    ),
                                  ),
                                  Chip(
                                    label: Text(
                                      calculateAge(userState.value!.dateOfBirth
                                              .getDateTime())
                                          .toString(),
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w400,
                                        color: ColorValues.textOnDark
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                    backgroundColor: Color(0xFF3F3E3E),
                                    shape: StadiumBorder(
                                      side: BorderSide(
                                          color: ColorValues.socaleOrange),
                                    ),
                                  ),
                                  Chip(
                                    label: Text(
                                      userState.value!.college,
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w400,
                                        color: ColorValues.textOnDark
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                    backgroundColor: Color(0xFF3F3E3E),
                                    shape: StadiumBorder(
                                      side: BorderSide(
                                          color: ColorValues.socaleOrange),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, top: 20, bottom: 10),
                                  child: Text(
                                    "My career goals are",
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.roboto(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: ColorValues.textOnDark
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 20,
                                runSpacing: 20,
                                children: [
                                  for (String goal
                                      in userState.value!.careerGoals)
                                    SizedBox(
                                      width: 80,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: ColorValues.socaleOrange,
                                              ),
                                            ),
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Text(
                                                careersOptionsList.keys
                                                    .firstWhere(
                                                      (element) =>
                                                          element == goal ||
                                                          careersOptionsList[
                                                                  element]!
                                                              .contains(goal),
                                                    )
                                                    .substring(0, 2),
                                                style: TextStyle(
                                                  fontSize: 54,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Text(
                                              goal.removemoji,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: ColorValues.textOnDark,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      "My academic interests are",
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: ColorValues.textOnDark
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 5,
                                  children: [
                                    for (String interests
                                        in userState.value!.academicInterests)
                                      Chip(
                                        avatar: Text(
                                          academicInterestsOptionsList.keys
                                              .firstWhere(
                                                (element) =>
                                                    element == interests ||
                                                    academicInterestsOptionsList[
                                                            element]!
                                                        .contains(interests),
                                              )
                                              .substring(0, 2),
                                        ),
                                        label: Text(
                                          interests.removemoji,
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w400,
                                            color: ColorValues.textOnDark
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                        backgroundColor: Color(0xFF3E4042),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      "My Non-Academic Interests are",
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: ColorValues.textOnDark
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 5,
                                  children: [
                                    for (String interests
                                        in userState.value!.leisureInterests)
                                      Chip(
                                        avatar: Text(
                                          hobbiesOptionsList.keys
                                              .firstWhere(
                                                (element) =>
                                                    element == interests ||
                                                    hobbiesOptionsList[element]!
                                                        .contains(interests),
                                              )
                                              .substring(0, 2),
                                        ),
                                        label: Text(
                                          interests.removemoji,
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w400,
                                            color: ColorValues.textOnDark
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                        backgroundColor: Color(0xFF3E4042),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, top: 20, bottom: 10),
                                  child: Text(
                                    "I am",
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.roboto(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: ColorValues.textOnDark
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 20,
                                runSpacing: 20,
                                children: [
                                  for (String interests
                                      in userState.value!.selfDescription)
                                    SizedBox(
                                      width: 150,
                                      height: 135,
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              width: 150,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  width: 4,
                                                  color: Colors.primaries[
                                                      Random().nextInt(Colors
                                                          .accents.length)],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  "assets/images/${descriptionIconOptions[userState.value!.selfDescription.indexOf(interests) % 3]}",
                                                  height: 110,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Text(
                                                    interests.removemoji,
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: ColorValues
                                                          .textOnDark,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      "I am also skillful at ...",
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: ColorValues.textOnDark
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 5,
                                  children: [
                                    for (String interests
                                        in userState.value!.skills)
                                      Chip(
                                        avatar: Text(
                                          skillsOptionsList.keys
                                              .firstWhere(
                                                (element) =>
                                                    element == interests ||
                                                    skillsOptionsList[element]!
                                                        .contains(interests),
                                              )
                                              .substring(0, 2),
                                        ),
                                        label: Text(
                                          interests.removemoji,
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w400,
                                            color: ColorValues.textOnDark
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                        backgroundColor: Color(0xFF3E4042),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: PrimarySolidIconButton(
                              width: size.width - 30,
                              height: 58,
                              text: "Situational Questions",
                              color: Colors.black,
                              onClickEventHandler: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        SituationalQuestionsPage(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return SharedAxisTransition(
                                        animation: animation,
                                        secondaryAnimation: secondaryAnimation,
                                        transitionType:
                                            SharedAxisTransitionType.horizontal,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              textColor: ColorValues.socaleDarkOrange,
                              icon: SvgPicture.asset(
                                "assets/icons/arrow_right.svg",
                                color: ColorValues.socaleDarkOrange,
                              ),
                            ),
                          ),
                        ],
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
