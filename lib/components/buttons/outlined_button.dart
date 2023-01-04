import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OutlineButton extends StatelessWidget {
  final String buttonContent;
  final bool isLoading;

  final Function() onClickEvent;

  const OutlineButton({
    Key? key,
    required this.buttonContent,
    required this.onClickEvent,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          child: isLoading
              ? Container(
                  height: 48,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                )
              : InkWell(
                  onTap: onClickEvent,
                  splashFactory: InkRipple.splashFactory,
                  borderRadius: BorderRadius.circular(15),
                  splashColor: const Color(0xFF000000).withOpacity(0.15),
                  highlightColor: const Color(0xFF000000).withOpacity(0.15),
                  focusColor: const Color(0xFF000000).withOpacity(0.10),
                  hoverColor: const Color(0xFF000000).withOpacity(0.10),
                  child: Container(
                    height: 48,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        buttonContent,
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
