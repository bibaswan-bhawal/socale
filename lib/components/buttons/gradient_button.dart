import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/buttons/button.dart';

class GradientButton extends Button {
  final LinearGradient linearGradient;
  final bool isLoading;

  const GradientButton({
    super.key,
    required super.text,
    required super.onPressed,
    required this.linearGradient,
    this.isLoading = false,
  });

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
                color: const Color(0xFF000000).withOpacity(0.25),
                offset: const Offset(1, 1),
                blurRadius: 4,
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            borderRadius: BorderRadius.circular(15),
            child: isLoading
                ? SizedBox(
                    height: 48,
                    width: constraints.maxWidth,
                    child: const Center(
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
                    onTap: super.onPressed,
                    splashFactory: InkRipple.splashFactory,
                    borderRadius: BorderRadius.circular(15),
                    splashColor: const Color(0xFFFFFFFF).withOpacity(0.30),
                    highlightColor: const Color(0xFFFFFFFF).withOpacity(0.30),
                    focusColor: const Color(0xFF000000).withOpacity(0.10),
                    hoverColor: const Color(0xFFFFFFFF).withOpacity(0.15),
                    child: SizedBox(
                      height: 48,
                      width: constraints.maxWidth,
                      child: Center(
                        child: Text(
                          super.text,
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
