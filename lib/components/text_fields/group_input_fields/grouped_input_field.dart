import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/resources/colors.dart';

class GroupedInputField extends StatefulWidget {
  final String hintText;
  final TextInputType textInputType;
  final Widget? prefixIcon;
  final bool isObscured;

  const GroupedInputField({
    Key? key,
    required this.hintText,
    required this.textInputType,
    this.prefixIcon,
    this.isObscured = false,
  }) : super(key: key);

  @override
  State<GroupedInputField> createState() => _GroupedInputFieldState();
}

class _GroupedInputFieldState extends State<GroupedInputField> {
  bool shouldObscure = false;

  @override
  void initState() {
    super.initState();

    if (widget.isObscured) shouldObscure = widget.isObscured;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: GoogleFonts.roboto(
        fontSize: 15,
        letterSpacing: -0.3,
      ),
      cursorColor: ColorValues.socaleOrange,
      cursorRadius: Radius.circular(1),
      keyboardType: widget.textInputType,
      obscureText: shouldObscure,
      decoration: InputDecoration(
        isCollapsed: true,
        prefixIcon: Padding(
          padding: EdgeInsets.only(right: 10),
          child: widget.prefixIcon,
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 4),
          child: widget.isObscured
              ? GestureDetector(
                  onTap: () => setState(() => shouldObscure = !shouldObscure),
                  behavior: HitTestBehavior.translucent,
                  child: SvgPicture.asset(
                    shouldObscure ? 'assets/icons/show.svg' : 'assets/icons/hide.svg',
                    color: Color(0xFF808080),
                    width: 24,
                  ),
                )
              : null,
        ),
        suffixIconConstraints: BoxConstraints(maxHeight: 24),
        prefixIconConstraints: BoxConstraints(maxHeight: 24),
        contentPadding: EdgeInsets.symmetric(vertical: 14),
        border: InputBorder.none,
        hintText: widget.hintText,
      ),
    );
  }
}
