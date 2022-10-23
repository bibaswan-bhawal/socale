import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socale/components/cards/gradient_border_card.dart';

class EndCard extends StatefulWidget {
  final Size size;
  const EndCard({Key? key, required this.size}) : super(key: key);

  @override
  State<EndCard> createState() => _EndCardState();
}

class _EndCardState extends State<EndCard> {
  late DateTime difference;
  Timer? countdownTimer;
  Duration myDuration = Duration(hours: 0);
  @override
  void initState() {
    super.initState();

    startTimer();
  }

  void startTimer() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  // Step 4
  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  // Step 5
  void resetTimer() {
    stopTimer();
    setState(() => myDuration = Duration(days: 5));
  }

  // Step 6
  void setCountDown() async {
    const reduceSecondsBy = 1;
    final prefs = await SharedPreferences.getInstance();
    String? lastUpdated = prefs.getString('lastUpdated');

    if (lastUpdated != null && mounted) {
      setState(() {
        myDuration = DateTime.now().difference(DateTime.parse(lastUpdated));
      });
    } else {
      setState(() {
        myDuration = Duration(hours: 0);
      });
    }

    if (mounted) {
      setState(() {
        final seconds = myDuration.inSeconds - reduceSecondsBy;
        if (seconds < 0) {
          countdownTimer!.cancel();
        } else {
          myDuration = Duration(seconds: seconds);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final days = strDigits(myDuration.inDays);
    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

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
            padding: EdgeInsets.symmetric(horizontal: widget.size.width * 0.095),
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
                    '$hours:$minutes:$seconds',
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
