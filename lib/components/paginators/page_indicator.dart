import 'package:flutter/material.dart';
import 'package:socale/resources/colors.dart';

class PageIndicator extends StatelessWidget {
  final int totalPages;
  final int selectedPage;

  const PageIndicator({super.key, required this.selectedPage, required this.totalPages});

  List<Widget> createDots() {
    final selectedPage = this.selectedPage.clamp(0, totalPages - 1);

    List<Widget> dots = [];

    for (int i = 0; i < totalPages; i++) {
      dots.add(
        AnimatedContainer(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          height: 12,
          width: 12,
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: selectedPage == i ? ColorValues.orangeButtonGradient : ColorValues.transparentGradient,
            border: selectedPage != i ? Border.all(color: const Color(0xFF000000), width: 1.5) : Border.all(color: const Color(0x00000000), width: 0),
          ),
        ),
      );
    }

    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: createDots(),
    );
  }
}
