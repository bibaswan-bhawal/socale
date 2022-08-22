import 'dart:math';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/rounded_button.dart';
import 'package:socale/models/Room.dart';
import 'package:socale/screens/main/chat/chat_page.dart';
import 'package:socale/screens/main/matches/card_provider.dart';
import 'package:provider/provider.dart';
import 'package:socale/models/User.dart';
import 'package:socale/models/Match.dart';
import 'package:socale/services/chat_service.dart';
import 'package:socale/utils/match_value_to_string.dart';

class MatchCard extends StatefulWidget {
  final Size size;
  final User user;
  final Match match;
  final bool isFront;

  const MatchCard({
    Key? key,
    required this.size,
    required this.isFront,
    required this.user,
    required this.match,
  }) : super(key: key);

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  getRoom(User user) async {
    Room? room = await chatService.getRoom(user.id);
    return room;
  }

  onItemClick() async {
    Room? room = await getRoom(widget.user);
    if (room == null) {
      safePrint("Could not fetch room");
      return;
    } else {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ChatPage(
            room: room,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> academicInterests = widget.user.academicInterests;
    List<String> hobbies = widget.user.leisureInterests;

    Widget buildCard() {
      return Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color(0xFF232323),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: matchPercentageConverter.convertPercentageToColorList(
                    int.parse(widget.match.matchingPercentage!),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(1),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color(0xFF232323),
                ),
              ),
            ),
          ),
          OverflowBox(
            maxHeight: widget.size.height + 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Material(
                      elevation: 4,
                      color: Color(0xFF8F9BB3),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "${widget.user.firstName} ${widget.user.lastName}",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.3,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      matchPercentageConverter.convertPercentageToString(
                        int.parse(
                          widget.match.matchingPercentage!,
                        ),
                      ),
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.3,
                        foreground: Paint()
                          ..shader = matchPercentageConverter
                              .convertPercentageToGradient(
                            int.parse(widget.match.matchingPercentage!),
                          ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25, top: 20, bottom: 10),
                  child: Text(
                    "Academic Interests",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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
                        for (String interest in academicInterests)
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
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 5, bottom: 10),
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Center(
                    child: Wrap(
                      spacing: 5,
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: [
                        for (String hobby in hobbies)
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
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
        ],
      );
    }

    Widget buildFrontCard() {
      return GestureDetector(
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.endPosition();
        },
        child: LayoutBuilder(
          builder: (BuildContext context, constraints) {
            final provider = Provider.of<CardProvider>(context);
            final position = provider.position;
            final milliseconds = provider.isDragging ? 0 : 300;

            final angle = provider.angle * pi / 180;
            final rotatedMatrix = Matrix4.identity()
              ..rotateZ(angle * 0.3)
              ..translate(position.dx, position.dy);

            return AnimatedContainer(
              transform: rotatedMatrix,
              duration: Duration(milliseconds: milliseconds),
              curve: Curves.linearToEaseOut,
              child: buildCard(),
            );
          },
        ),
      );
    }

    return widget.isFront ? buildFrontCard() : buildCard();
  }
}
