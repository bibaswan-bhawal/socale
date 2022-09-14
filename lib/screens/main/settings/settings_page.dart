import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/models/User.dart';
import 'package:socale/utils/options/academic_interests.dart';
import 'package:socale/utils/options/hobbies.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/values/colors.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late User currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final userState = ref.watch(userAsyncController);
    userState.whenData((value) => setState(() => currentUser = value));
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userAsyncController);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Color(0xFF292B2F),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [ColorValues.socaleOrange, ColorValues.socaleDarkOrange],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: mediaQuery.padding.top),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/images/socale_logo_bw.png',
                        width: 100,
                      ),
                      CircleAvatar(
                        radius: 75,
                        child: Image.asset(
                          'assets/images/avatars/${userState.value?.avatar}',
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "${userState.value?.firstName} ${userState.value?.lastName}",
                            style: GoogleFonts.poppins(
                              color: ColorValues.textOnDark,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "${userState.value?.major.first} @ ${userState.value?.college}",
                            style: GoogleFonts.poppins(
                              color: ColorValues.textOnDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                child: Text(
                  "Academic Interests",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Center(
                child: Wrap(
                  spacing: 5,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [
                    for (String interest in currentUser.academicInterests)
                      Chip(
                        label: Text(
                          interest,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        backgroundColor: Color(0x8A3E4042),
                      ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                child: Text(
                  "Hobbies",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Center(
                child: Wrap(
                  spacing: 5,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [
                    for (String interest in currentUser.leisureInterests)
                      Chip(
                        label: Text(
                          interest,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        backgroundColor: Color(0x8A3E4042),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  child: Text(
                    "My ideal friend",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color(0xFF232323),
              ),
              width: mediaQuery.size.width * 0.9,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: Text(
                  currentUser.idealFriendDescription,
                  style: GoogleFonts.poppins(
                    color: ColorValues.textOnDark,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                child: Text(
                  "My skills",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Center(
                child: Wrap(
                  spacing: 5,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [
                    for (String interest in currentUser.skills)
                      Chip(
                        label: Text(
                          interest,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        backgroundColor: Color(0x8A3E4042),
                      ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                child: Text(
                  "Career Goals",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Center(
                child: Wrap(
                  spacing: 5,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [
                    for (String interest in currentUser.careerGoals)
                      Chip(
                        label: Text(
                          interest,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        backgroundColor: Color(0x8A3E4042),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
