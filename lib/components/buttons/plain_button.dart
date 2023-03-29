import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/buttons/button.dart';

class PlainButton extends Button {
  final bool isLoading;
  final bool wrap;

  final Widget? leadingIcon;
  final Widget? trailingIcon;

  final Color background;

  const PlainButton({
    super.key,
    required super.text,
    required super.onPressed,
    this.background = Colors.white,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.wrap = false,
  });

  Widget createInkwell({child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: background,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.25),
            offset: const Offset(1, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: super.onPressed,
          splashFactory: InkRipple.splashFactory,
          borderRadius: BorderRadius.circular(15),
          splashColor: const Color(0xFF000000).withOpacity(0.15),
          highlightColor: const Color(0xFF000000).withOpacity(0.15),
          focusColor: const Color(0xFF000000).withOpacity(0.10),
          hoverColor: const Color(0xFF000000).withOpacity(0.10),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return createInkwell(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            height: 48,
            width: !wrap ? constraints.maxWidth : null,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingIcon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: leadingIcon!,
                  ),
                Text(
                  super.text!,
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                    fontSize: 16,
                  ),
                ),
                if (trailingIcon != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: trailingIcon!,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
