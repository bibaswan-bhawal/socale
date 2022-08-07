// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:socale/utils/options/skills.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({Key? key}) : super(key: key);

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Column(
        children: [
          SizedBox(
              height: 600,
              width: size.width,
              child: Wrap(
                children: [
                  for (int i = 0; i < skillsOptionsList.length; i++)
                    Chip(
                      label: Text(skillsOptionsList.keys.elementAt(i)),
                    ),
                ],
              ))
        ],
      ),
    );
  }
}
