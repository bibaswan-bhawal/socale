import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';
import 'package:socale/resources/colors.dart';

class GroupInputField extends StatefulWidget {
  final String hintText;

  final bool isObscured;

  final String initialValue;

  final TextInputType textInputType;
  final TextInputAction textInputAction;

  final Iterable<String> autofillHints;

  final Function(String) onChanged;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const GroupInputField({
    Key? key,
    required this.hintText,
    this.isObscured = false,
    this.initialValue = "",
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.autofillHints = const [],
    required this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  State<GroupInputField> createState() => _GroupInputFieldState();
}

class _GroupInputFieldState extends State<GroupInputField> {
  late TextEditingController controller;
  bool shouldObscure = false;

  Artboard? _board;
  StateMachineController? _controller;
  SMITrigger? _trigger;

  @override
  void initState() {
    super.initState();

    rootBundle.load('assets/animations/icons/hide_show.riv').then((data) async {
      final file = RiveFile.import(data);

      final board = file.mainArtboard;
      var controller = StateMachineController.fromArtboard(board, 'logic');

      if (controller != null) {
        board.addController(controller);
        _trigger = controller.findInput<bool>('pressed') as SMITrigger;
        _controller = controller;
      }

      setState(() => _board = board);
    });

    controller = TextEditingController(text: widget.initialValue);

    if (widget.isObscured) shouldObscure = widget.isObscured;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialValue.isNotEmpty) {
        widget.onChanged(widget.initialValue);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget? suffixIconBuilder() {
    if (widget.suffixIcon != null) return widget.suffixIcon!;
    if (!widget.isObscured) return null;

    return SizedBox(
      width: 20,
      height: 20,
      child: InkResponse(
        onTap: () {
          _trigger?.fire();
          setState(() => shouldObscure = !shouldObscure);
        },
        splashFactory: InkRipple.splashFactory,
        radius: 10,
        child: _board != null ? Rive(artboard: _board!, fit: BoxFit.contain) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 14),
              child: widget.prefixIcon,
            ),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: widget.onChanged,
                style: GoogleFonts.roboto(fontSize: 14, letterSpacing: -0.3),
                cursorColor: ColorValues.socaleOrange,
                cursorRadius: Radius.circular(1),
                keyboardType: widget.textInputType,
                textInputAction: widget.textInputAction,
                autofillHints: widget.autofillHints,
                obscureText: shouldObscure,
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: widget.hintText,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 14),
              child: suffixIconBuilder(),
            ),
          ],
        ),
      );
    });
  }
}
