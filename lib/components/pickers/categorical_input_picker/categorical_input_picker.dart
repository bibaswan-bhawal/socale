import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/assets/svg_icons.dart';
import 'package:socale/components/backgrounds/light_background.dart';
import 'package:socale/components/pickers/categorical_input_picker/chip_input.dart';
import 'package:socale/components/pickers/categorical_input_picker/tab_chip.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/models/options/categorical/categorical.dart';

class CategoricalInputPicker<T> extends StatefulWidget {
  const CategoricalInputPicker({
    super.key,
    required this.data,
    required this.selectedData,
    required this.searchHintText,
    required this.onClosedCallback,
  });

  final List<T>? data;
  final List<T> selectedData;
  final String searchHintText;

  final Function onClosedCallback;

  @override
  State<CategoricalInputPicker<T>> createState() => CategoricalInputPickerState<T>();
}

class CategoricalInputPickerState<T> extends State<CategoricalInputPicker<T>> {
  Map<String, List<Categorical>> filteredOptions = {};
  List<String> categories = [];
  List<T> selectedOptions = [];

  String searchQuery = '';

  String? selectedTab;

  @override
  void initState() {
    super.initState();

    selectedOptions = widget.selectedData.toList();
  }

  void onTabChanged(String? tab) => setState(() => selectedTab = tab);

  void onSearchChanged(String value) => setState(() => searchQuery = value);

  Map<String, List<Categorical>> createOptionsMap(List<Categorical>? options) {
    Map<String, List<Categorical>> optionsMap = {};

    if (options == null) return optionsMap;

    for (Categorical option in options) {
      optionsMap.addEntries([
        MapEntry(
          option.getCategory(),
          optionsMap[option.getCategory()] == null ? [option] : [...?optionsMap[option.getCategory()], option],
        ),
      ]);
    }

    for (List<Categorical> values in optionsMap.values) {
      values.sort();
    }

    return optionsMap;
  }

  Widget createPage() {
    if (widget.data == null) return _LoadingPage();
    if (widget.data!.isEmpty) return _ErrorPage();

    Map<String, List<Categorical>> showCategories = createOptionsMap(widget.data as List<Categorical>?);
    List<String> showCategoriesKeys = showCategories.keys.toList();
    showCategoriesKeys.sort();

    if (searchQuery.isNotEmpty) {
      List<Categorical> filteredData = widget.data!
          .where((element) => element.toString().toLowerCase().contains(searchQuery.toLowerCase()))
          .cast<Categorical>()
          .toList();

      if (filteredData.isEmpty) {
        return Center(child: Text('No results ${selectedTab == null ? '' : 'in $selectedTab'}'));
      }

      showCategories = createOptionsMap(filteredData);
      showCategoriesKeys = showCategories.keys.toList();
      showCategoriesKeys.sort();
    }

    if (selectedTab != null) {
      if (showCategories[selectedTab!] == null) return Center(child: Text('No results in $selectedTab'));

      return SingleChildScrollView(
        padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: MediaQuery.of(context).padding.bottom),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (Categorical option in showCategories[selectedTab] as List<Categorical>)
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
        ),
      );
    }

    return SingleChildScrollView(
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
    );
  }

  // return the selected items on close
  Future<bool> onClose() async {
    widget.onClosedCallback(returnValue: selectedOptions);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Categorical>> optionsMap = createOptionsMap(widget.data as List<Categorical>?);

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
              onChanged: onSearchChanged,
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
            bottom: widget.data != null && widget.data!.isNotEmpty
                ? PreferredSize(
                    preferredSize: Size(MediaQuery.of(context).size.width, 36),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _Tabs(
                        selectedOption: selectedTab,
                        options: optionsMap,
                        onTap: onTabChanged,
                      ),
                    ),
                  )
                : null,
          ),
          body: createPage(),
        ),
      ),
    );
  }
}

class _ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'There was an error\nloading all the options',
        style: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.3,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.options,
    required this.selectedOption,
    required this.onTap,
  });

  final Map<String, List<Categorical>> options;
  final String? selectedOption;

  final Function(String?) onTap;

  List<Widget> get tabs {
    List<String> categories = options.keys.toList();
    List<Widget> tabs = [];

    categories.sort();

    tabs.add(
      Padding(
        padding: const EdgeInsets.only(left: 8, right: 4),
        child: TabChip(
          label: 'All',
          onTap: () => onTap(null),
          selected: selectedOption == null,
        ),
      ),
    );

    for (String category in categories) {
      tabs.add(
        Padding(
          padding: EdgeInsets.only(left: 4, right: categories.last == category ? 8 : 4),
          child: TabChip(
            label: category,
            onTap: () => onTap(category),
            selected: selectedOption == category,
          ),
        ),
      );
    }

    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = options.keys.toList();
    List<Widget> tabs = [];

    categories.sort();

    tabs.add(
      Padding(
        padding: const EdgeInsets.only(left: 8, right: 4),
        child: TabChip(
          label: 'All',
          onTap: () => onTap(null),
          selected: selectedOption == null,
        ),
      ),
    );

    for (String category in categories) {
      tabs.add(
        Padding(
          padding: EdgeInsets.only(left: 4, right: categories.last == category ? 8 : 4),
          child: TabChip(
            label: category,
            onTap: () => onTap(category),
            selected: selectedOption == category,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: tabs,
    );
  }
}
