import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/buttons/button.dart';

class LinkButton extends Button {
  final String? prefixText;
  final TextStyle? prefixTextStyle;
  final TextStyle? textStyle;
  final bool wrap;
  final double? width;
  final bool visualFeedback;

  const LinkButton({
    super.key,
    required super.text,
    required super.onPressed,
    this.prefixTextStyle,
    this.width,
    this.textStyle,
    this.prefixText,
    this.wrap = false,
    this.visualFeedback = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: wrap ? width : constraints.maxWidth,
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
                  radius: wrap ? (width! / 1.8) : 24,
                  splashFactory: visualFeedback ? InkRipple.splashFactory : NoSplash.splashFactory,
                  highlightColor: visualFeedback ? Colors.transparent : null,
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
