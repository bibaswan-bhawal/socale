import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/assets/svg_icons.dart';
import 'package:socale/components/pickers/input_picker.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/transitions/container_transform.dart';

class GridItemInputField<T> extends StatefulWidget {
  const GridItemInputField({
    super.key,
    required this.icon,
    required this.title,
    required this.data,
    required this.initialData,
    required this.inputPicker,
    required this.onChanged,
    this.borderSize = 2,
    this.borderRadius = 15,
    this.borderGradient = AppColors.orangeGradient,
  });

  /// Center Icon
  final Widget icon;

  /// Name of input field
  final String title;

  /// Border size of card
  final double borderSize;

  /// Border radius of card
  final double borderRadius;

  /// Border gradient of card
  final LinearGradient borderGradient;

  /// List of options
  final List<T> data;

  /// List of selected options
  final List<T> initialData;

  final InputPickerBuilder inputPicker;

  final Function onChanged;

  @override
  State<GridItemInputField> createState() => _GridItemInputFieldState<T>();
}

class _GridItemInputFieldState<T> extends State<GridItemInputField<T>> {
  List<T> selectedOptions = [];

  @override
  void initState() {
    super.initState();

    selectedOptions = widget.initialData.toList();
  }

  Widget buildParent(context, openContainerCallback) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: openContainerCallback,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 8.0),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: selectedOptions.isNotEmpty ? Colors.green : Colors.black12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 6.0, top: 6.0),
                child: SvgIcon.asset('assets/icons/add.svg', color: Colors.black, width: 20, height: 20),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1E1E1),
                      borderRadius: BorderRadius.circular(constraints.maxWidth / 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget.icon,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: Container(
              height: 24,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0D1427),
                borderRadius: BorderRadius.circular(12),
              ),
              child: (selectedOptions.isEmpty)
                  ? Center(
                      child: Text(
                        'Add ${widget.title}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: size.width * (12 / 414),
                          letterSpacing: -0.3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.only(left: 6.0, right: 6.0),
                          decoration: BoxDecoration(
                            color: const Color(0x88D9D9D9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${selectedOptions.length}',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: size.width * (10 / 414),
                                letterSpacing: -0.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              widget.title,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: size.width * (12 / 414),
                                letterSpacing: -0.3,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChild(BuildContext context, Function closeContainer) {
    InputPickerBuilder pickerBuilder = widget.inputPicker;
    pickerBuilder.onClosedCallback = closeContainer;

    InputPicker<T> picker = pickerBuilder.build<T>();

    return picker;
  }

  Widget buildBackground(BuildContext context, Widget content, Animation<double> animation) {
    Animatable<double> borderRadiusTween = Tween<double>(begin: 15, end: 0);
    Animatable<double> borderSize = Tween<double>(begin: 2, end: 0);

    final innerBorderRadius = borderRadiusTween.evaluate(animation) - borderSize.evaluate(animation);

    return Container(
      decoration: BoxDecoration(
        gradient: widget.borderGradient,
        borderRadius: BorderRadius.circular(borderRadiusTween.evaluate(animation)),
      ),
      child: Container(
        margin: EdgeInsets.all(borderSize.evaluate(animation)),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradientBackground,
          borderRadius: BorderRadius.all(Radius.circular(innerBorderRadius)),
        ),
        clipBehavior: Clip.antiAlias,
        child: content,
      ),
    );
  }

  void onClosedCallback(List<T>? selectedData) {
    setState(() => this.selectedOptions = selectedData ?? this.selectedOptions);
    widget.onChanged(this.selectedOptions);
  }

  @override
  Widget build(BuildContext context) {
    return ContainerTransform<List<T>>(
      parentBuilder: buildParent,
      childBuilder: buildChild,
      backgroundBuilder: buildBackground,
      onClosed: onClosedCallback,
      useRootNavigator: true,
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}
