import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/buttons/button.dart';

class LinkButton extends Button {
  final String? prefixText;
  final TextStyle? prefixTextStyle;
  final TextStyle? textStyle;

  const LinkButton({
    super.key,
    required super.text,
    required super.onPressed,
    this.prefixTextStyle,
    this.textStyle,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: 48,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  prefixText != null ? '${prefixText!} ' : '',
                  style: prefixTextStyle ??
                      GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.3,
                        color: Colors.black,
                      ),
                ),
                InkResponse(
                  radius: 0,
                  onTap: onPressed,
                  child: SizedBox(
                    height: 48,
                    child: Center(
                      child: Text(
                        text,
                        style: textStyle ??
                            GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.3,
                              color: Colors.black.withOpacity(0.5),
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
