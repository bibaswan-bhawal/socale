import 'package:flutter/material.dart';
import 'package:socale/resources/colors.dart';

class ContainerChipSelector extends StatefulWidget {
  final String emptyMessage;

  const ContainerChipSelector({Key? key, required this.emptyMessage}) : super(key: key);

  @override
  State<ContainerChipSelector> createState() => _ContainerChipSelectorState();
}

class _ContainerChipSelectorState extends State<ContainerChipSelector> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: 200,
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.transparent, width: 2),
        gradient: ColorValues.groupInputBackgroundGradient,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 2, offset: const Offset(1, 1))],
      ),
      child: Center(
        child: Text(widget.emptyMessage),
      ),
    );
  }
}
