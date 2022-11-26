import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/resources/colors.dart';

class GroupInputField extends StatefulWidget {
  final String hintText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final bool isObscured;
  final Function(String)? onChanged;
  final String? initialValue;

  const GroupInputField({
    Key? key,
    required this.hintText,
    this.textInputType,
    this.textInputAction,
    this.prefixIcon,
    this.isObscured = false,
    this.onChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  State<GroupInputField> createState() => _GroupInputFieldState();
}

class _GroupInputFieldState extends State<GroupInputField> {
  late TextEditingController controller;
  bool shouldObscure = false;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.initialValue ?? "");
    if (widget.isObscured) shouldObscure = widget.isObscured;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: GoogleFonts.roboto(fontSize: 15, letterSpacing: -0.3),
      onChanged: widget.onChanged,
      cursorColor: ColorValues.socaleOrange,
      cursorRadius: Radius.circular(1),
      keyboardType: widget.textInputType,
      textInputAction: widget.textInputAction,
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
