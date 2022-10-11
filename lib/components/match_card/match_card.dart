import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/rounded_button.dart';
import 'package:socale/components/cards/gradient_border_card.dart';
import 'package:socale/models/MatchRoom.dart';
import 'package:socale/models/RoomListItem.dart';
import 'package:socale/screens/main/chat/chat_page.dart';
import 'package:socale/models/User.dart';
import 'package:socale/models/Match.dart';
import 'package:socale/services/chat_service.dart';
import 'package:socale/utils/match_value_to_string.dart';
import 'package:socale/utils/options/academic_interests.dart';
import 'package:socale/utils/options/hobbies.dart';

class MatchCard extends StatefulWidget {
  final Size size;
  final User user;
  final Match match;

  const MatchCard({
    Key? key,
    required this.size,
    required this.user,
    required this.match,
  }) : super(key: key);

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  onItemClick() async {
      if (mounted) {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ChatPage(room: MatchRoom(user: widget.user)),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                child: child,
              );
            },
          ),
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    List<String> academicInterests = widget.user.academicInterests;
    List<String> hobbies = widget.user.leisureInterests;

    List<String> academicCategories = [];
    List<String> hobbiesCategories = [];

    for (String interest in academicInterests) {
      if (academicInterestsOptionsList.containsKey(interest)) {
        if (!academicCategories.contains(interest)) {
          academicCategories.add(interest);
        }
      } else {
        String key = academicInterestsOptionsList.keys.where((key) => academicInterestsOptionsList[key]!.contains(interest)).first;
        if (!academicCategories.contains(key)) {
          academicCategories.add(key);
        }
      }
    }

    for (String hobby in hobbies) {
      if (hobbiesOptionsList.containsKey(hobby)) {
        if (!hobbiesCategories.contains(hobby)) {
          hobbiesCategories.add(hobby);
        }
      } else {
        String key = hobbiesOptionsList.keys.where((key) => hobbiesOptionsList[key]!.contains(hobby)).first;
        if (!hobbiesCategories.contains(key)) {
          hobbiesCategories.add(key);
        }
      }
    }

    return Padding(
      padding: EdgeInsets.only(),
      child: Stack(
        children: [
          GradientBorderCard(
            size: Size(widget.size.width, widget.size.height - 50),
            baseColor: Color(0xFF232323),
            gradientColor: matchPercentageConverter.convertPercentageToColorList(
              int.parse(widget.match.matchingPercentage),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 170),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      widget.user.anonymousUsername,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.3,
                        color: Color(0xFFFFFFFF),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      matchPercentageConverter.convertPercentageToString(int.parse(widget.match.matchingPercentage)),
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.3,
                        foreground: Paint()
                          ..shader = matchPercentageConverter.convertPercentageToGradient(
                            int.parse(widget.match.matchingPercentage),
                          ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 40, top: 20, bottom: 10, right: 40),
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
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Wrap(
                        spacing: 5,
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        children: [
                          for (String interest in academicCategories)
                            Chip(
                              label: Text(
                                interest,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 40, top: 5, bottom: 10),
                      child: Text(
                        "Also interested In",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Center(
                      child: Wrap(
                        spacing: 5,
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        children: [
                          for (String hobby in hobbiesCategories)
                            Chip(
                              label: Text(
                                hobby,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: RoundedButton(
                height: 60,
                width: 3,
                onClickEventHandler: onItemClick,
                text: 'Message',
                colors: [
                  Color(0xFFFD6C00),
                  Color(0xFFFFA133),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CircleAvatar(
              radius: 75,
              child: Image.asset('assets/images/avatars/${widget.user.avatar}'),
            ),
          )
        ],
      ),
    );
  }
}
