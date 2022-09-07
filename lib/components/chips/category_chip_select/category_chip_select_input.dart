import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryChipSelectInput extends StatefulWidget {
  final Map<String, List<String>> map;
  final Function onChange;
  final String searchText;
  final List<String> initValue;
  final bool gotData;

  const CategoryChipSelectInput({
    Key? key,
    required this.map,
    required this.onChange,
    required this.searchText,
    required this.initValue,
    required this.gotData,
  }) : super(key: key);

  @override
  State<CategoryChipSelectInput> createState() => _CategoryChipSelectInputState();
}

class _CategoryChipSelectInputState extends State<CategoryChipSelectInput> {
  List<String> options = [];
  List<String> skillsSelected = [];
  List<String> categorySelected = [];
  List<String> categoryAdded = [];
  List<String> autocompleteList = [];

  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  bool gotData = false;

  @override
  void initState() {
    super.initState();
    setInitValue();
    widget.map.forEach((key, value) {
      options.add(key);
      for (var element in value) {
        autocompleteList.add(element);
      }
    });
  }

  void setInitValue() {
    for (String item in widget.initValue) {
      if (!widget.map.keys.contains(item)) {
        var key = widget.map.keys.firstWhere((element) => widget.map[element]!.contains(item));
        if (!categoryAdded.contains(key)) {
          categoryAdded.add(key);
        }
      }

      if (!skillsSelected.contains(item)) {
        skillsSelected.add(item);
      }
    }
  }

  Color backgroundColor(String option) {
    if (categoryAdded.contains(option) || skillsSelected.contains(option)) {
      return Color(0xFFFFAE50);
    }

    if (categorySelected.contains(option)) {
      return Color(0xFFFFB660);
    }

    if (widget.map.containsKey(option)) {
      return Color(0xFFE9E8E8);
    }

    return Color(0xFFFFD9AE);
  }

  Color textColor(String option) {
    if (skillsSelected.contains(option) || categorySelected.contains(option) || categoryAdded.contains(option)) {
      return Color(0xFFFFFFFF);
    }

    return Color(0xFF000000).withOpacity(0.70);
  }

  double chipElevation(bool isCategory, bool isSelected) {
    if (isSelected) return 1;
    if (isCategory) return 0.5;
    return 0.25;
  }

  void _onSelected(String selection) {
    if (!skillsSelected.contains(selection)) {
      setState(() => skillsSelected.add(selection));
      String cat = widget.map.keys.where((key) => widget.map[key]!.contains(selection)).first;
      setState(() => categoryAdded.addIf(!categoryAdded.contains(cat), cat));

      setState(() => options.clear());
      setState(() => categorySelected.clear());
      setState(() => categorySelected.add(cat));

      setState(() => widget.map.forEach((key, value) {
            options.add(key);
          }));

      var index = options.indexOf(cat);

      setState(
        () => widget.map[cat]?.forEach(
          (element) {
            if (index + 1 == options.length) {
              options.add(element);
            } else {
              options.insert(index + 1, element);
            }
          },
        ),
      );

      widget.onChange(skillsSelected);
      textEditingController.clear();
    }
  }

  void _onClickEventHandler(int i) {
    String key = options[i];
    bool isCategory = widget.map.containsKey(key);

    if (skillsSelected.contains(key)) {
      if (!isCategory) {
        setState(() => skillsSelected.remove(key));
        widget.onChange(skillsSelected);
        String g = widget.map.keys.firstWhere((element) => widget.map[element]!.contains(key));

        var delKey = true;

        for (String element in widget.map[g]!) {
          if (skillsSelected.contains(element)) {
            delKey = false;
          }
        }

        if (delKey) {
          setState(() => categoryAdded.remove(g));
        }
      } else {
        if (widget.map[key]!.isEmpty) {
          setState(() => skillsSelected.remove(key));
          widget.onChange(skillsSelected);
        }
      }
    } else {
      if (skillsSelected.length < 5) {
        if (!isCategory) {
          setState(() => skillsSelected.add(key));
          var k = widget.map.keys.firstWhere((element) => widget.map[element]!.contains(key));

          if (!categoryAdded.contains(k)) {
            setState(() => categoryAdded.add(k));
          }
          widget.onChange(skillsSelected);
        } else {
          if (widget.map[key]!.isEmpty) {
            setState(() => skillsSelected.add(key));
            widget.onChange(skillsSelected);
          }
        }
      }
    }

    if (isCategory && widget.map[key]!.isNotEmpty) {
      setState(() => options.clear());
      var unselect = false;

      if (categorySelected.contains(key)) {
        unselect = true;
      }

      setState(() => categorySelected.clear());

      if (!unselect) {
        setState(() => categorySelected.add(key));
      }

      setState(() => widget.map.forEach((key, value) {
            options.add(key);
          }));

      var index = options.indexOf(key);

      if (!unselect) {
        setState(
          () => widget.map[key]?.forEach(
            (element) {
              if (index + 1 == options.length) {
                options.add(element);
              } else {
                options.insert(index + 1, element);
              }
            },
          ),
        );
      }
    }

    print(skillsSelected);
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
                return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: _onSelected,
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
                      width: size.width - 70,
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
                            widget.map.containsKey(options[i]),
                            skillsSelected.contains(options[i]),
                          ),
                          label: Text(
                            options[i],
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: textColor(options[i]),
                            ),
                          ),
                          backgroundColor: backgroundColor(options[i]),
                          onPressed: () => _onClickEventHandler(i),
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
