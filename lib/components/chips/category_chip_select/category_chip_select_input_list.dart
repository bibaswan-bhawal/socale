import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryChipSelectInputList extends StatefulWidget {
  final List<String> list;
  final Function onChange;
  final String searchText;
  final List<String> initValue;
  final bool gotData;

  const CategoryChipSelectInputList({
    Key? key,
    required this.list,
    required this.onChange,
    required this.searchText,
    required this.initValue,
    required this.gotData,
  }) : super(key: key);

  @override
  State<CategoryChipSelectInputList> createState() => _CategoryChipSelectInputListState();
}

class _CategoryChipSelectInputListState extends State<CategoryChipSelectInputList> {
  List<String> options = [];
  List<String> skillsSelected = [];
  List<String> autocompleteList = [];

  bool gotData = false;

  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    setInitValue();
    for (var element in widget.list) {
      options.add(element);
      autocompleteList.add(element);
    }
  }

  void setInitValue() {
    for (String item in widget.initValue) {
      if (!skillsSelected.contains(item)) {
        skillsSelected.add(item);
      }
    }
  }

  Color backgroundColor(bool isSelected) {
    if (isSelected) return Color(0xFFFFAE50);
    return Color(0xFFE9E8E8);
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

    if (!gotData) {
      setState(() => gotData = widget.gotData);
      setInitValue();
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 32, right: 32),
          child: RawAutocomplete<String>(
            textEditingController: textEditingController,
            focusNode: focusNode,
            fieldViewBuilder:
                (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
              return TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: widget.searchText,
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
                onFieldSubmitted: (String value) => onFieldSubmitted(),
              );
            },
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              }
              return autocompleteList.where((String option) {
                return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selection) {
              setState(() => skillsSelected.addIf(!skillsSelected.contains(selection), selection));
              widget.onChange(skillsSelected);
              textEditingController.clear();
            },
            optionsViewBuilder: (context, onAutoCompleteSelect, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Material(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFFFFFFFF),
                    elevation: 4.0,
                    child: SizedBox(
                      width: size.width - 64,
                      height: 200,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0.0),
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return ListTile(
                            title: Text(option),
                            onTap: () => onAutoCompleteSelect(option),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            width: size.width,
            child: ScrollConfiguration(
              behavior: MaterialScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
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
                              if (skillsSelected.length < 5) {
                                setState(() => skillsSelected.add(key));
                                widget.onChange(skillsSelected);
                              }
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
