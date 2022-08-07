import 'package:flutter/material.dart';

class ChipList<T> extends StatelessWidget {
  final List<T> values;
  final Padding Function(T) chipBuilder;

  const ChipList({Key? key, required this.values, required this.chipBuilder})
      : super(key: key);

  List<Widget> _buildChipList() {
    final List<Widget> items = [];

    for (T value in values) {
      items.add(chipBuilder(value));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _buildChipList(),
    );
  }
}
