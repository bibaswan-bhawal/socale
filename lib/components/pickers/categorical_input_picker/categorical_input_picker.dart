import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/assets/svg_icons.dart';
import 'package:socale/components/backgrounds/light_background.dart';
import 'package:socale/components/pickers/categorical_input_picker/chip_input.dart';
import 'package:socale/components/pickers/input_picker.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/models/options/categorical/categorical.dart';

class CategoricalInputPickerBuilder<T> extends InputPickerBuilder {
  final List<T>? data;
  final String searchHintText;

  CategoricalInputPickerBuilder({
    required this.data,
    required this.searchHintText,
  });

  @override
  InputPicker<S> build<S>() {
    return CategoricalInputPicker<S>(
      data: data as List<S>?,
      selectedData: (selectedOptions ?? []) as List<S>,
      searchHintText: searchHintText,
      onClosedCallback: onClosedCallback,
    );
  }
}

class CategoricalInputPicker<T> extends InputPicker<T> {
  const CategoricalInputPicker({
    super.key,
    required this.data,
    required this.selectedData,
    required this.searchHintText,
    required super.onClosedCallback,
  });

  final List<T>? data;
  final List<T> selectedData;
  final String searchHintText;

  @override
  State<CategoricalInputPicker<T>> createState() => CategoricalInputPickerState<T>();
}

class CategoricalInputPickerState<T> extends State<CategoricalInputPicker<T>> {
  Map<String, List<Categorical>> filteredOptions = {};
  List<T> selectedOptions = [];

  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    selectedOptions = widget.selectedData.toList();

    createCategories();
  }

  List<String> get filteredCategories {
    List<String> categories = filteredOptions.keys.toList();
    categories.sort();
    return categories;
  }

  void createCategories() {
    if (widget.data == null) return;

    filteredOptions = {};

    for (Categorical option in widget.data! as List<Categorical>) {
      if (searchQuery.isNotEmpty && !option.toString().toLowerCase().contains(searchQuery.toLowerCase())) continue;

      filteredOptions.addEntries([
        MapEntry(
          option.getCategory(),
          filteredOptions[option.getCategory()] == null
              ? [option]
              : [...?filteredOptions[option.getCategory()]?.where((element) => element != option).toList(), option],
        ),
      ]);
    }

    filteredOptions = filteredOptions.map((key, value) {
      return MapEntry(key, value..sort((a, b) => (a).compareTo(b)));
    });

    var totalLength = 0;

    for (var element in filteredOptions.values) {
      totalLength += element.length;
    }

    print('filteredOptions: $totalLength');
  }

  Future<bool> onClose() async {
    widget.onClosedCallback(returnValue: selectedOptions);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onClose,
      child: ScreenScaffold(
        background: const LightBackground(),
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          scrolledUnderElevation: 3,
          backgroundColor: Colors.transparent,
          title: TextField(
            decoration: InputDecoration(
              hintText: widget.searchHintText,
              contentPadding: const EdgeInsets.all(0),
              border: InputBorder.none,
            ),
            onChanged: (value) => setState(() {
              searchQuery = value;
              createCategories();
            }),
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
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              for (String category in filteredCategories)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          letterSpacing: -0.3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (Categorical option in filteredOptions[category] as List<Categorical>)
                              ChipInput(
                                name: option.toString(),
                                selected: selectedOptions.contains(option),
                                onTap: () => setState(() {
                                  if (!selectedOptions.contains(option)) {
                                    selectedOptions.add(option as T);
                                  } else {
                                    selectedOptions.remove(option);
                                  }
                                }),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
