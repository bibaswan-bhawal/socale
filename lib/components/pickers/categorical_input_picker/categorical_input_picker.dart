import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/assets/svg_icons.dart';
import 'package:socale/components/backgrounds/light_background.dart';
import 'package:socale/components/pickers/categorical_input_picker/chip_input.dart';
import 'package:socale/components/pickers/categorical_input_picker/tab_chip.dart';
import 'package:socale/components/pickers/input_picker.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/models/options/categorical/categorical.dart';

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
  List<String> categories = [];
  List<T> selectedOptions = [];

  String searchQuery = '';

  int? selectedCategory;

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

  // Creates the list of options from the initial data and the search filter
  void createCategories() {
    if (widget.data == null) return;

    categories = [];
    filteredOptions = {};

    for (Categorical option in widget.data! as List<Categorical>) {
      // Build the list of categories for tha tabs
      if (!categories.contains(option.getCategory())) categories.add(option.getCategory());

      // Filter the options based on the search query
      if (searchQuery.isNotEmpty && !option.toString().toLowerCase().contains(searchQuery.toLowerCase())) continue;

      // Add the option to the filtered options list
      filteredOptions.addEntries([
        MapEntry(
          option.getCategory(),
          filteredOptions[option.getCategory()] == null
              ? [option]
              : [...?filteredOptions[option.getCategory()]?.where((element) => element != option).toList(), option],
        ),
      ]);
    }

    // Sort the options alphabetically
    filteredOptions = filteredOptions.map((key, value) {
      return MapEntry(key, value..sort((a, b) => (a).compareTo(b)));
    });
  }

  // Build the tabs under the app bar
  List<Widget> buildTabs() {
    List<Widget> tabs = [];

    tabs.add(
      Padding(
        padding: const EdgeInsets.only(left: 8, right: 4),
        child: TabChip(
          label: 'All',
          onTap: () => setState(() => selectedCategory = null),
          selected: selectedCategory == null,
        ),
      ),
    );

    categories.sort();

    for (String category in categories) {
      tabs.add(
        Padding(
          padding: EdgeInsets.only(left: 4, right: categories.last == category ? 8 : 4),
          child: TabChip(
            label: category,
            onTap: () => setState(() => selectedCategory = categories.indexOf(category)),
            selected: selectedCategory == categories.indexOf(category),
          ),
        ),
      );
    }

    return tabs;
  }

  // return the selected items on close
  Future<bool> onClose() async {
    widget.onClosedCallback(returnValue: selectedOptions);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Build the list of options to show based on the selected category
    Map<String, List<Categorical>> showCategories = {};

    // if category is selected show the options for that category else show the full list with headings
    if (selectedCategory != null) {
      showCategories.addEntries([
        MapEntry(
          categories[selectedCategory!],
          filteredOptions[categories[selectedCategory!]]!,
        ),
      ]);
    } else {
      showCategories = filteredOptions;
    }

    // sorted the list of categories to show alphabetically
    List<String> showCategoriesKeys = showCategories.keys.toList();
    showCategoriesKeys.sort();

    return WillPopScope(
      onWillPop: onClose,
      child: DefaultTabController(
        length: 3,
        child: ScreenScaffold(
          background: const LightBackground(),
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
            backgroundColor: Colors.transparent,
            scrolledUnderElevation: 0,
            title: TextField(
              decoration: InputDecoration(
                hintText: widget.searchHintText,
                contentPadding: const EdgeInsets.all(0),
                border: InputBorder.none,
              ),
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.3,
                color: Colors.black,
              ),
              onChanged: (value) => setState(() {
                searchQuery = value;
                selectedCategory = null;
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
            bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 36),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: buildTabs(),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: MediaQuery.of(context).padding.bottom),
            child: Column(
              children: [
                for (String category in showCategoriesKeys)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (selectedCategory == null)
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
                              for (Categorical option in showCategories[category] as List<Categorical>)
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
      ),
    );
  }
}
