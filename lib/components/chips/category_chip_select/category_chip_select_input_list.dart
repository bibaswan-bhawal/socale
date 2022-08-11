import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryChipSelectInputList extends StatefulWidget {
  final List<String> list;
  final Function onChange;

  const CategoryChipSelectInputList({
    Key? key,
    required this.list,
    required this.onChange,
  }) : super(key: key);

  @override
  State<CategoryChipSelectInputList> createState() =>
      _CategoryChipSelectInputListState();
}

class _CategoryChipSelectInputListState
    extends State<CategoryChipSelectInputList> {
  List<String> options = [];
  List<String> skillsSelected = [];
  List<String> autocompleteList = [];

  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    for (var element in widget.list) {
      options.add(element);
      autocompleteList.add(element);
    }
  }

  Color backgroundColor(bool isSelected) {
    if (isSelected) return Color(0xFFFFA133);
    return Color(0xFF636363).withOpacity(0.15);
  }

  Color textColor(bool isSelected) {
    if (isSelected) return Color(0xFFFFFFFF);
    return Color(0xFF000000).withOpacity(0.70);
  }

  double chipElevation(bool isSelected) {
    if (isSelected) return 1;
    return 0.5;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 32, right: 32),
          child: RawAutocomplete<String>(
            textEditingController: textEditingController,
            focusNode: focusNode,
            fieldViewBuilder: (BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              return TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search for skills",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(style: BorderStyle.none, width: 0),
                  ),
                  fillColor: Color(0xFFB7B0B0).withOpacity(0.25),
                  filled: true,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.only(top: 14),
                ),
                controller: textEditingController,
                focusNode: focusNode,
                onFieldSubmitted: (String value) {
                  onFieldSubmitted();
                },
              );
            },
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              }
              return autocompleteList.where((String option) {
                return option
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selection) {
              setState(() => skillsSelected.addIf(
                  !skillsSelected.contains(selection), selection));
              widget.onChange(skillsSelected);
              textEditingController.clear();
            },
            optionsViewBuilder: (context, onAutoCompleteSelect, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4.0,
                  child: SizedBox(
                    width: size.width - 64,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0.0),
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String option = options.elementAt(index);
                        return ListTile(
                          title: Text(option),
                          onTap: () {
                            onAutoCompleteSelect(option);
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 35, top: 32, right: 20),
              child: Wrap(
                children: [
                  for (int i = 0; i < options.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: ActionChip(
                        elevation: chipElevation(
                          skillsSelected.contains(options[i]),
                        ),
                        label: Text(
                          options[i],
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: textColor(
                              skillsSelected.contains(options[i]),
                            ),
                          ),
                        ),
                        backgroundColor: backgroundColor(
                          skillsSelected.contains(options[i]),
                        ),
                        onPressed: () {
                          String key = options[i];

                          if (skillsSelected.contains(key)) {
                            setState(() => skillsSelected.remove(key));
                            widget.onChange(skillsSelected);
                          } else {
                            setState(() => skillsSelected.add(key));
                            widget.onChange(skillsSelected);
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
