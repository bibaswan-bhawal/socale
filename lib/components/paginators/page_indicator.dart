import 'package:flutter/material.dart';
import 'package:socale/resources/colors.dart';

class PageIndicator extends StatelessWidget {
  final int totalPages;
  final int selectedPage;

  const PageIndicator({super.key, required this.selectedPage, required this.totalPages});

  BoxDecoration calculateDecoration(int index) {
    final selectedPage = this.selectedPage.clamp(0, totalPages - 1);

    if (selectedPage == index) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: AppColors.orangeGradient,
      );
    }

    return BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: const Color(0xFF000000), width: 1.5),
    );
  }

  List<Widget> createDots() {
    List<Widget> dots = [];

    for (int i = 0; i < totalPages; i++) {
      dots.add(
        AnimatedContainer(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          height: 12,
          width: 12,
          duration: const Duration(milliseconds: 200),
          decoration: calculateDecoration(i),
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
