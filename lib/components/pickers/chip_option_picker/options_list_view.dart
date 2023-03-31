import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ChipOptionListViewScreen<T> extends StatefulWidget {
  final Function onClosedCallback;

  final List<T>? data;
  final List<T> selectedData;

  final String searchHintText;

  const ChipOptionListViewScreen({
    super.key,
    required this.data,
    required this.selectedData,
    required this.searchHintText,
    required this.onClosedCallback,
  });

  @override
  State<ChipOptionListViewScreen<T>> createState() => ChipOptionListViewScreenState<T>();
}

class ChipOptionListViewScreenState<T> extends State<ChipOptionListViewScreen<T>> {
  late List<T> filteredOptions;
  late List<T> selectedOptions;

  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    if (widget.data == null) return;

    selectedOptions = widget.selectedData.toList();
    filteredOptions = widget.data!.where((element) => !selectedOptions.contains(element)).toList();
    filteredOptions.sort((a, b) => (a as Comparable).compareTo(b));
  }

  void onSearch(String value) => setState(() => searchQuery = value);

  void onDeleted(index) => setState(() {
        filteredOptions.add(selectedOptions[index]);
        selectedOptions.removeAt(index);
        filteredOptions.sort((a, b) => (a as Comparable).compareTo(b));
      });

  void onSelected(index) => setState(() {
        selectedOptions.add(filteredOptions[index]);
        filteredOptions.removeAt(index);
        selectedOptions.sort((a, b) => (a as Comparable).compareTo(b));
      });

  Widget buildListView() {
    switch (widget.data) {
      case null:
        return buildLoading();
      case []:
        return Center(
          child: Text(
            'There was a problem loading all the options',
            style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        );
      default:
        if (searchQuery.isNotEmpty) {
          filteredOptions = widget.data!
              .where((element) => !selectedOptions.contains(element))
              .where((element) => element.toString().toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();
        } else {
          filteredOptions = widget.data!.where((element) => !selectedOptions.contains(element)).toList();
        }

        filteredOptions.sort((a, b) => (a as Comparable).compareTo(b));

        if (filteredOptions.isEmpty) {
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
            itemCount: filteredOptions.length,
            separatorBuilder: (context, index) => const Divider(thickness: 0.4, height: 8),
            findChildIndexCallback: (Key key) {
              int index = filteredOptions.indexOf((key as ValueKey).value);
              return index == -1 ? null : index;
            },
            itemBuilder: (context, index) {
              return ListTile(
                dense: true,
                key: ValueKey(filteredOptions[index]),
                title: Text(filteredOptions[index].toString()),
                onTap: () => onSelected(index),
              );
            },
          ),
        );
    }
  }

  Widget buildLoading() => const Center(child: CircularProgressIndicator());

  Chip buildChip(T option) => Chip(
        key: ValueKey(option),
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.all(4),
        label: Text(option.toString(), style: GoogleFonts.roboto(fontSize: 12)),
        onDeleted: () => onDeleted(selectedOptions.indexOf(option)),
        clipBehavior: Clip.antiAlias,
      );

  Future<bool> onClose() async {
    widget.onClosedCallback(returnValue: selectedOptions);
    return false;
  }

  @override
  Widget build(BuildContext context) {
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
            icon: SvgPicture.asset('assets/icons/back.svg', fit: BoxFit.contain, width: 28, height: 28),
          ),
          actions: [
            IconButton(
              onPressed: onClose,
              icon: SvgPicture.asset('assets/icons/check.svg', fit: BoxFit.contain, width: 28, height: 28),
            ),
          ],
          scrolledUnderElevation: 0,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (selectedOptions.isNotEmpty)
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 130, minWidth: size.width),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: selectedOptions.map(buildChip).toList(),
                  ),
                ),
              ),
            buildListView(),
          ],
        ),
      ),
    );
  }
}
