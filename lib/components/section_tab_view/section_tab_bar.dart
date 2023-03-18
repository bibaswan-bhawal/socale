import 'package:flutter/material.dart';
import 'package:socale/components/section_tab_view/section_tab.dart';
import 'package:socale/resources/colors.dart';

export 'package:socale/components/section_tab_view/section_tab.dart';

class SectionTabBar extends StatefulWidget {
  final TabController? controller;
  final List<SectionTab> tabs;

  const SectionTabBar({
    super.key,
    this.controller,
    required this.tabs,
  });

  @override
  State<SectionTabBar> createState() => _SectionTabBarState();
}

class _SectionTabBarState extends State<SectionTabBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 30, right: 30),
      child: TabBar(
        controller: widget.controller,
        splashFactory: NoSplash.splashFactory,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: ColorValues.socaleOrange, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        tabs: widget.tabs,
      ),
    );
  }
}
