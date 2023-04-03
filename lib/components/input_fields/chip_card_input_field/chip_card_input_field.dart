import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/assets/svg_icons.dart';
import 'package:socale/components/pickers/input_picker.dart';
import 'package:socale/transitions/container_transform.dart';

class ChipCardInputField<T> extends StatefulWidget {
  final String placeholder;
  final String searchHintText;
  final List<T> selectedData;

  final bool hasError;
  final String? errorText;

  final Function onChanged;

  final InputPickerBuilder inputPicker;

  const ChipCardInputField({
    super.key,
    required this.selectedData,
    required this.placeholder,
    required this.searchHintText,
    required this.onChanged,
    required this.hasError,
    required this.inputPicker,
    this.errorText,
  });

  @override
  State<ChipCardInputField> createState() => _ChipCardInputFieldState<T>();
}

class _ChipCardInputFieldState<T> extends State<ChipCardInputField<T>> {
  late List<T> selectedData;

  @override
  void initState() {
    super.initState();

    selectedData = widget.selectedData.toList();
  }

  Chip buildChip(T option) => Chip(
        key: ValueKey(option),
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.all(4),
        label: Text(option.toString(), style: GoogleFonts.roboto(fontSize: 12)),
        onDeleted: () => setState(() {
          selectedData.removeAt(selectedData.indexOf(option));
          widget.onChanged(selectedData);
        }),
        clipBehavior: Clip.antiAlias,
      );

  Widget buildParent(context, openContainerCallback) {
    return GestureDetector(
      onTap: openContainerCallback,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: SvgIcon.asset('assets/icons/add.svg', color: Colors.black, height: 28, width: 28),
              onPressed: openContainerCallback,
            ),
          ),
          if (selectedData.isEmpty)
            Center(child: Text(widget.placeholder))
          else
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 40),
              scrollDirection: Axis.vertical,
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 8,
                runSpacing: 4,
                children: selectedData.map(buildChip).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildBackground(BuildContext context, Widget content, Animation<double> animation) {
    Color initialBorderColor = widget.hasError ? Colors.red : Colors.black;

    Animatable<Color?> borderColor = ColorTween(begin: initialBorderColor, end: Colors.transparent);
    Animatable<double> borderRadiusTween = Tween<double>(begin: 15, end: 0);
    Animatable<double> borderSize = Tween<double>(begin: 2, end: 0);

    return Container(
      decoration: BoxDecoration(
        color: animation.status == AnimationStatus.dismissed ? null : Colors.white,
        border: Border.all(
          color: borderColor.evaluate(animation)!,
          width: borderSize.evaluate(animation),
        ),
        borderRadius: BorderRadius.circular(borderRadiusTween.evaluate(animation)),
      ),
      child: content,
    );
  }

  Widget buildChild(BuildContext context, Function closeContainer) {
    InputPickerBuilder pickerBuilder = widget.inputPicker;

    pickerBuilder.onClosedCallback = closeContainer;
    pickerBuilder.selectedOptions = selectedData;

    InputPicker<T> picker = pickerBuilder.build<T>();

    return picker;
  }

  void onClosedCallback(List<T>? selectedData) {
    setState(() => this.selectedData = selectedData ?? this.selectedData);
    widget.onChanged(this.selectedData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: ContainerTransform<List<T>>(
            childBuilder: buildChild,
            parentBuilder: buildParent,
            backgroundBuilder: buildBackground,
            onClosed: onClosedCallback,
            useRootNavigator: true,
            transitionDuration: const Duration(milliseconds: 500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: widget.hasError ? 1 : 0,
            child: Text(
              widget.errorText ?? '',
              textAlign: TextAlign.start,
              style: GoogleFonts.roboto(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
