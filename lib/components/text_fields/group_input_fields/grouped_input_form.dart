import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:socale/components/text_fields/group_input_fields/grouped_input_field.dart';
import 'package:socale/resources/colors.dart';

class GroupedInputForm extends StatefulWidget {
  final List<GroupedInputField> children;

  const GroupedInputForm({Key? key, this.children = const []}) : super(key: key);

  @override
  State<GroupedInputForm> createState() => _GroupedInputFromState();
}

class _GroupedInputFromState extends State<GroupedInputForm> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SimpleShadow(
          offset: const Offset(1, 1),
          sigma: 2,
          color: Colors.black.withOpacity(0.25),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: ColorValues.groupInputBackgroundGradient,
            ),
            child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: widget.children[index],
                    );
                  }
                  if (index == widget.children.length - 1) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: widget.children[index],
                    );
                  }
                  return widget.children[index];
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                    thickness: 1.5,
                    color: Color(0xFFE7E7E7),
                  );
                },
                itemCount: widget.children.length),
          ),
        );
      },
    );
  }
}
