import 'package:flutter/material.dart';
import 'package:socale/components/paginators/paginator.dart';
import 'package:socale/resources/colors.dart';

class PagePaginator extends Paginator {
  final int totalPages;

  const PagePaginator({super.key, required super.selectedPage, required this.totalPages});

  List<Widget> createDots() {
    List<Widget> dots = [];

    for (int i = 0; i < totalPages; i++) {
      dots.add(
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: selectedPage == i
                ? ColorValues.orangeButtonGradient
                : ColorValues.transparentGradient,
            border: selectedPage != i
                ? Border.all(color: const Color(0xFF000000), width: 1.5)
                : Border.all(color: const Color(0x00000000), width: 0),
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
