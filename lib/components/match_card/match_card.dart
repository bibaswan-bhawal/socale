import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/rounded_button.dart';
import 'package:socale/screens/main/matches/card_provider.dart';
import 'package:provider/provider.dart';

class MatchCard extends StatefulWidget {
  final Size size;
  final String text;
  final bool isFront;

  const MatchCard({
    Key? key,
    required this.size,
    required this.text,
    required this.isFront,
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

  @override
  Widget build(BuildContext context) {
    Widget buildCard() {
      return Material(
        elevation: widget.isFront ? 4 : 0,
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Color(0xFF232323),
        child: Stack(
          children: [
            Center(
              child: OverflowBox(
                maxHeight: widget.size.height + 70,
                child: Column(
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Material(
                        elevation: 4,
                        color: Color(0xFF8F9BB3),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        widget.text,
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "Legendary match",
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.3,
                          foreground: Paint()
                            ..shader = ui.Gradient.linear(
                              const Offset(0, 0),
                              const Offset(150, 20),
                              <Color>[
                                Color(0xFF36D1DC),
                                Color(0xFF5B86E5),
                              ],
                            ),
                        ),
                      ),
                    )
                  ],
                ),
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
                  onClickEventHandler: () {},
                  text: 'Message',
                  colors: [
                    Color(0xFFFD6C00),
                    Color(0xFFFFA133),
                  ],
                ),
              ),
            ),
          ],
        ),
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
