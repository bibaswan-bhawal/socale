import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/cards/gradient_border_card.dart';

class EndCard extends StatefulWidget {
  final Size size;
  const EndCard({Key? key, required this.size}) : super(key: key);

  @override
  State<EndCard> createState() => _EndCardState();
}

class _EndCardState extends State<EndCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GradientBorderCard(
          size: Size(widget.size.width, widget.size.height - 50),
          baseColor: Color(0xFF232323),
          gradientColor: [
            Color(0xFF36D1DC),
            Color(0xFF5B86E5),
          ],
        ),
        Center(
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: widget.size.width * 0.095),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Looks like you went through all your matches.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    '',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
