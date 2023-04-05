import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/buttons/link_button.dart';
import 'package:socale/components/paginators/page_indicator.dart';
import 'package:socale/resources/colors.dart';

class PageViewController extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  final Function() back;
  final Function() next;

  final bool? showNext;
  final bool? showBack;

  final String nextText;
  final String backText;

  const PageViewController({
    super.key,
    required this.currentPage,
    required this.pageCount,
    required this.back,
    required this.next,
    this.showNext,
    this.showBack,
    required this.nextText,
    required this.backText,
  });

  @override
  Widget build(BuildContext context) {
    final double bottomViewPadding = MediaQuery.of(context).viewPadding.bottom;
    final double bottomPadding = bottomViewPadding == 0 ? 20 : 40 - bottomViewPadding;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding, left: 30, right: 30, top: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: showBack ?? true,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: LinkButton(
              text: backText,
              onPressed: back,
              wrap: true,
              width: 64,
              visualFeedback: true,
              textStyle: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: currentPage == 0 ? AppColors.secondaryOrange : Colors.black,
              ),
            ),
          ),
          Expanded(
            child: PageIndicator(
              selectedPage: currentPage,
              totalPages: pageCount,
            ),
          ),
          Visibility(
            visible: showNext ?? true,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: LinkButton(
              text: nextText,
              onPressed: next,
              wrap: true,
              width: 64,
              visualFeedback: true,
              textStyle: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: currentPage == pageCount - 1 ? AppColors.secondaryOrange : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
