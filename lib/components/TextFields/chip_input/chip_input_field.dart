import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/TextFields/chip_input/chip_list.dart';
import 'package:socale/values/colors.dart';

class ChipInputField<T> extends StatefulWidget {
  final ValueChanged<List> onChanged;
  final List<String> values;
  final String textInputLabel;
  final double width;
  final List<String> list;

  ChipInputField({
    Key? key,
    required this.onChanged,
    required this.values,
    required this.textInputLabel,
    required this.width,
    required this.list,
  }) : super(key: key);

  @override
  State<ChipInputField<T>> createState() => _ChipInputFieldState<T>();
}

class _ChipInputFieldState<T> extends State<ChipInputField<T>> {
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _fieldText = TextEditingController();

  late OverlayEntry _overlayEntry;
  late List<String> _searchResults;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _searchResults = widget.list;
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
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

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: widget.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, 50.0),
          child: Container(
            constraints: BoxConstraints(maxHeight: 200),
            height: _searchResults.length * 56,
            width: widget.width,
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Colors.white,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 0, bottom: 0),
                itemCount: _searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_searchResults[index]),
                    onTap: () {
                      _fieldText.clear();
                      if (!widget.values.contains(_searchResults[index])) {
                        widget.values.add(_searchResults[index]);
                        widget.onChanged(widget.values);
                      }
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Column(
        children: [
          CompositedTransformTarget(
            link: _layerLink,
            child: Container(
              width: widget.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(_isFocused ? 0 : 10),
                  bottomLeft: Radius.circular(_isFocused ? 0 : 10),
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Color(0xFFB7B0B0).withOpacity(0.25),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 2),
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: ClampingScrollPhysics(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ChipList(
                          values: widget.values,
                          chipBuilder: (String value) {
                            return Padding(
                              padding: EdgeInsets.only(left: 0, right: 5),
                              child: Chip(
                                label: Text(
                                  value,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                backgroundColor: Color(0xFFFFA133),
                                deleteIconColor: Colors.white,
                                onDeleted: () {
                                  widget.values.remove(value);
                                  widget.onChanged(widget.values);
                                },
                              ),
                            );
                          },
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5),
                          constraints:
                              BoxConstraints(minWidth: widget.values.isEmpty ? widget.width : 200),
                          child: IntrinsicWidth(
                            child: TextField(
                              focusNode: _focusNode,
                              controller: _fieldText,
                              decoration: InputDecoration(
                                hintText: widget.textInputLabel,
                                hintStyle: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: ColorValues.elementColor.withOpacity(0.7),
                                    fontSize: 14),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() => _searchResults = widget.list
                                    .where((element) =>
                                        element.toLowerCase().contains(value.toLowerCase()))
                                    .toList());
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
