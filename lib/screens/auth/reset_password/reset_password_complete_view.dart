import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/text/headline.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/screens/auth/reset_password/reset_password_view.dart';

class ResetPasswordCompleteView extends ResetPasswordView {
  final String email;

  const ResetPasswordCompleteView({super.key, required this.email});

  @override
  ResetPasswordViewState createState() => _ResetPasswordCompleteViewState();
}

class _ResetPasswordCompleteViewState extends ResetPasswordViewState {
  @override
  Future<bool> onBack() async {
    Navigator.of(context).pop();
    return false;
  }

  @override
  Future<bool> onNext() async {
    Navigator.of(context).pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(flex: 1, child: Container()),
        const Headline(text: 'Successfully Changed!'),
        Expanded(
          flex: 2,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Your password for',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: (size.width * 0.034),
                      color: ColorValues.textSubtitle,
                    ),
                  ),
                  Text(
                    (widget as ResetPasswordCompleteView).email,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: (size.width * 0.038),
                      color: ColorValues.textSubtitle,
                    ),
                  ),
                  Text(
                    'has been changed successfully, you can\n'
                    'login with your new password now.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: (size.width * 0.034),
                      color: ColorValues.textSubtitle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
