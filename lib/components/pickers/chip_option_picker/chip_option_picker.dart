import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/pickers/options_list_view/options_list_view.dart';
import 'package:socale/transitions/container_transform.dart';

class ChipOptionPicker<T> extends StatefulWidget {
  final String placeholder;
  final String searchHintText;
  final List<T>? data;
  final List<T> selectedData;

  final bool hasError;
  final String? errorText;

  final Function onChanged;

  const ChipOptionPicker({
    super.key,
    required this.data,
    required this.selectedData,
    required this.placeholder,
    required this.searchHintText,
    required this.onChanged,
    required this.hasError,
    this.errorText,
  });

  @override
  State<ChipOptionPicker> createState() => _ChipOptionPickerState<T>();
}

class _ChipOptionPickerState<T> extends State<ChipOptionPicker<T>> {
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
    return LayoutBuilder(
      builder: (context, constraint) {
        return GestureDetector(
          onTap: openContainerCallback,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/add.svg',
                    colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    height: 28,
                    width: 28,
                  ),
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
      },
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
    return ChipOptionListViewScreen(
      data: widget.data,
      selectedData: selectedData,
      searchHintText: widget.searchHintText,
      onClosedCallback: closeContainer,
    );
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
            transitionDuration: const Duration(milliseconds: 500),
            useRootNavigator: true,
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
