import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    super.key,
    required this.hintText,
    this.isObscured = false,
    this.initialValue = '',
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.autofillHints = const [],
    required this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<GroupInputField> createState() => _GroupInputFieldState();
}

class _GroupInputFieldState extends State<GroupInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  bool _shouldObscure = false;

  Artboard? _board;
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
      }

      setState(() => _board = board);
    });

    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();

    if (widget.isObscured) _shouldObscure = widget.isObscured;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialValue.isNotEmpty) {
        widget.onChanged(widget.initialValue);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget? suffixIconBuilder() {
    if (widget.suffixIcon != null) return widget.suffixIcon!;
    if (!widget.isObscured) return null;

    return SizedBox(
      width: 20,
      height: 20,
      child: InkResponse(
        radius: 10,
        splashFactory: InkRipple.splashFactory,
        child: _board != null ? Rive(artboard: _board!, fit: BoxFit.contain) : null,
        onTap: () {
          _trigger?.fire();
          setState(() => _shouldObscure = !_shouldObscure);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _focusNode.requestFocus(),
        child: Container(
          width: constraints.maxWidth,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: widget.prefixIcon,
              ),
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: _controller,
                  onChanged: widget.onChanged,
                  style: GoogleFonts.roboto(fontSize: 14, letterSpacing: -0.3),
                  cursorColor: ColorValues.socaleOrange,
                  cursorRadius: const Radius.circular(1),
                  keyboardType: widget.textInputType,
                  textInputAction: widget.textInputAction,
                  autofillHints: widget.autofillHints,
                  obscureText: _shouldObscure,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: widget.hintText,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14),
                child: suffixIconBuilder(),
              ),
            ],
          ),
        ),
      );
    });
  }
}
