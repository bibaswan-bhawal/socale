import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socale/components/assets/svg_icons.dart';
import 'package:socale/components/backgrounds/light_background.dart';
import 'package:socale/components/pickers/input_picker.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/utils/system_ui.dart';

class CategoricalInputPickerBuilder<T> extends InputPickerBuilder {
  @override
  InputPicker<S> build<S>() {
    return CategoricalInputPicker<S>(
      onClosedCallback: onClosedCallback,
    );
  }
}

class CategoricalInputPicker<T> extends InputPicker<T> {
  const CategoricalInputPicker({
    super.key,
    required super.onClosedCallback,
  });

  @override
  State<CategoricalInputPicker<T>> createState() => CategoricalInputPickerState<T>();
}

class CategoricalInputPickerState<T> extends State<CategoricalInputPicker<T>> {
  @override
  void initState() {
    super.initState();
    SystemUI.setSystemUIDark();
  }

  void onClose() {
    widget.onClosedCallback(returnValue: []);
  }

  @override
  Widget build(BuildContext context) {
    SystemUI.setSystemUIDark();

    return ScreenScaffold(
      background: const LightBackground(),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        title: const TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            contentPadding: EdgeInsets.all(0),
            border: InputBorder.none,
          ),
        ),
        leading: IconButton(
          onPressed: onClose,
          icon: SvgIcon.asset('assets/icons/back.svg', width: 28, height: 28),
        ),
        actions: [
          IconButton(
            onPressed: onClose,
            icon: SvgIcon.asset('assets/icons/check.svg', width: 28, height: 28),
          ),
        ],
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Wrap(
          children: [
            for (var i = 0; i < 100; i++) Chip(label: Text('Item $i')),
          ],
        ),
      ),
    );
  }
}
