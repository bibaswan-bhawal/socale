import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/assets/svg_icons.dart';
import 'package:socale/components/pickers/input_picker.dart';
import 'package:socale/models/options/major/major.dart';
import 'package:socale/utils/system_ui.dart';

class SelectMajorsScreen extends InputPicker<Major> {
  const SelectMajorsScreen({
    super.key,
    required this.selectedMajors,
    required super.onClosedCallback,
  });

  final List<Major> selectedMajors;

  @override
  State<StatefulWidget> createState() => ListInputPickerState();
}

class ListInputPickerState extends State<SelectMajorsScreen> {
  List<Major> filteredMajors = [];
  List<Major> selectedMajors = [];

  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    if (widget.data == null) return;

    selectedMajors = widget.selectedMajors.toList();
    filteredMajors = widget.data!.where((element) => !selectedMajors.contains(element)).toList();
    filteredMajors.sort((a, b) => (a as Comparable).compareTo(b));
  }

  void onSearch(String value) => setState(() => searchQuery = value);

  void onDeleted(index) => setState(() {
        filteredMajors.add(selectedMajors[index]);
        selectedMajors.removeAt(index);
        filteredMajors.sort((a, b) => (a as Comparable).compareTo(b));
      });

  void onSelected(index) => setState(() {
        selectedMajors.add(filteredMajors[index]);
        filteredMajors.removeAt(index);
        selectedMajors.sort((a, b) => (a as Comparable).compareTo(b));
      });

  Widget buildListView() {
    switch (widget.data) {
      case null:
        return buildLoading();
      case []:
        return Expanded(
          child: Center(
            child: Text(
              'There was a problem\nloading all the options',
              style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        );
      default:
        if (searchQuery.isNotEmpty) {
          filteredMajors = widget.data!
              .where((element) => !selectedMajors.contains(element))
              .where((element) => element.toString().toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();
        } else {
          filteredMajors = widget.data!.where((element) => !selectedMajors.contains(element)).toList();
        }

        filteredMajors.sort((a, b) => (a as Comparable).compareTo(b));

        if (filteredMajors.isEmpty) {
          return Expanded(
            child: Center(
              child: Text(
                'No results found',
                style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          );
        }

        return Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 8),
            itemCount: filteredMajors.length,
            separatorBuilder: (context, index) => const Divider(thickness: 0.4, height: 8),
            findChildIndexCallback: (Key key) {
              int index = filteredMajors.indexOf((key as ValueKey).value);
              return index == -1 ? null : index;
            },
            itemBuilder: (context, index) {
              return ListTile(
                dense: true,
                key: ValueKey(filteredMajors[index]),
                title: Text(filteredMajors[index].toString()),
                onTap: () => onSelected(index),
              );
            },
          ),
        );
    }
  }

  Widget buildLoading() => const Expanded(child: Center(child: CircularProgressIndicator()));

  Chip buildChip(T option) => Chip(
        key: ValueKey(option),
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.all(4),
        label: Text(option.toString(), style: GoogleFonts.roboto(fontSize: 12)),
        onDeleted: () => onDeleted(selectedMajors.indexOf(option)),
        clipBehavior: Clip.antiAlias,
      );

  Future<bool> onClose() async {
    widget.onClosedCallback(returnValue: selectedMajors);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    SystemUI.setSystemUIDark();

    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: onClose,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: widget.searchHintText,
              contentPadding: const EdgeInsets.all(0),
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
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (selectedMajors.isNotEmpty)
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 130, minWidth: size.width),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: selectedMajors.map(buildChip).toList(),
                    ),
                  ),
                ),
              buildListView(),
            ],
          ),
        ),
      ),
    );
  }
}
