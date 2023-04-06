import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabChip extends StatelessWidget {
  const TabChip({super.key, required this.label, required this.onTap, this.selected = false});

  final String label;
  final bool selected;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.black : Colors.black12.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          splashFactory: InkRipple.splashFactory,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 12,
                letterSpacing: -0.3,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
