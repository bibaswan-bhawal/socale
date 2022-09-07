import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/values/colors.dart';

class DropDownTextField extends StatefulWidget {
  final String label;
  final String initValue;
  final List<String> list;
  final Function onChange;
  const DropDownTextField({
    Key? key,
    required this.label,
    required this.list,
    required this.onChange,
    required this.initValue,
  }) : super(key: key);
  @override
  State<DropDownTextField> createState() => _DropDownTextFieldState();
}

class _DropDownTextFieldState extends State<DropDownTextField> {
  late OverlayEntry _overlayEntry;
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  String value = "";
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() => value = widget.initValue);
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    final size = MediaQuery.of(context).size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width - 24,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, 50.0),
          child: SizedBox(
            height: 200,
            width: size.width - 20,
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Colors.white,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 0, bottom: 0),
                itemCount: widget.list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(widget.list[index]),
                    onTap: () {
                      widget.onChange(widget.list[index]);
                      setState(() => value = widget.list[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onFocusChange() {
    if (_focusNode.hasPrimaryFocus) {
      _isFocused = true;
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context)?.insert(_overlayEntry);
    } else {
      _isFocused = false;
      _overlayEntry.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Focus(
      focusNode: _focusNode,
      child: Builder(builder: (context) {
        final FocusNode focusNode = Focus.of(context);
        final bool hasFocus = focusNode.hasFocus;

        return GestureDetector(
          onTap: () {
            if (hasFocus) {
              focusNode.unfocus();
            } else {
              focusNode.requestFocus();
            }
          },
          child: CompositedTransformTarget(
            link: _layerLink,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(_isFocused ? 0 : 10),
                  bottomRight: Radius.circular(_isFocused ? 0 : 10),
                ),
                color: Color(0xFFB7B0B0).withOpacity(0.25),
              ),
              width: size.width,
              height: 52,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        value.isNotEmpty ? value : widget.label,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: ColorValues.elementColor.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(_isFocused ? Icons.expand_less : Icons.expand_more),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
