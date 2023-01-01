import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientButton extends StatelessWidget {
  final LinearGradient linearGradient;
  final String buttonContent;
  final bool isLoading;

  final Function() onClickEvent;

  const GradientButton({
    Key? key,
    required this.linearGradient,
    required this.buttonContent,
    required this.onClickEvent,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            gradient: linearGradient,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF000000).withOpacity(0.25),
                offset: Offset(1, 1),
                blurRadius: 4,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            child: isLoading
                ? SizedBox(
                    height: 48,
                    width: constraints.maxWidth,
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  )
                : InkWell(
                    onTap: onClickEvent,
                    splashFactory: InkRipple.splashFactory,
                    borderRadius: BorderRadius.circular(15),
                    splashColor: Color(0xFFFFFFFF).withOpacity(0.30),
                    highlightColor: Color(0xFFFFFFFF).withOpacity(0.30),
                    focusColor: Color(0xFF000000).withOpacity(0.10),
                    hoverColor: Color(0xFFFFFFFF).withOpacity(0.15),
                    child: SizedBox(
                      height: 48,
                      width: constraints.maxWidth,
                      child: Center(
                        child: Text(
                          buttonContent,
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
