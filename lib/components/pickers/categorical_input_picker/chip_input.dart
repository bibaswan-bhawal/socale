import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/resources/colors.dart';

class ChipInput extends StatelessWidget {
  const ChipInput({
    super.key,
    required this.name,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final bool selected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: selected ? AppColors.orangeGradient : null,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? Colors.transparent : Colors.black12.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          canRequestFocus: false,
          splashColor: selected ? const Color(0xFFFFFFFF).withOpacity(0.30) : null,
          highlightColor: selected ? const Color(0xFFFFFFFF).withOpacity(0.30) : null,
          focusColor: selected ? const Color(0xFF000000).withOpacity(0.10) : null,
          hoverColor: selected ? const Color(0xFFFFFFFF).withOpacity(0.15) : null,
          borderRadius: BorderRadius.circular(20),
          splashFactory: InkRipple.splashFactory,
          child: Padding(
            padding: EdgeInsets.only(left: 12, top: 4, bottom: 4, right: selected ? 5 : 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    letterSpacing: -0.3,
                    color: selected ? Colors.white : Colors.black,
                  ),
                ),
                if (selected)
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Icon(
                      Icons.cancel,
                      size: 16,
                      color: Colors.white,
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
