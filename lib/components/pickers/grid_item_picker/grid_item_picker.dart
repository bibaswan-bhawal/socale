import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/resources/colors.dart';

class GridItemPicker<T> extends StatefulWidget {
  const GridItemPicker({
    super.key,
    required this.title,
    required this.onTap,
    required this.selectedData,
    required this.icon,
    this.borderGradient = ColorValues.orangeGradient,
    this.borderRadius = 15,
    this.borderSize = 2,
  });

  final String title;
  final LinearGradient borderGradient;
  final double borderRadius;
  final double borderSize;

  final Widget icon;

  final List<T> selectedData;

  final Function() onTap;

  @override
  State<GridItemPicker> createState() => _GridItemPickerState<T>();
}

class _GridItemPickerState<T> extends State<GridItemPicker<T>> {
  List<T> selectedOptions = [];

  @override
  void initState() {
    super.initState();

    selectedOptions = widget.selectedData.toList();
  }

  @override
  Widget build(BuildContext context) {
    final innerBorderRadius = widget.borderRadius - widget.borderSize;

    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          gradient: widget.borderGradient,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Container(
          margin: EdgeInsets.all(widget.borderSize),
          decoration: BoxDecoration(
            gradient: ColorValues.cardGradientBackground,
            borderRadius: BorderRadius.all(Radius.circular(innerBorderRadius)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Container(),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0, top: 6.0),
                    child: SvgPicture.asset(
                      'assets/icons/add.svg',
                      colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                      height: 16,
                      width: 16,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxWidth,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1E1E1),
                          borderRadius: BorderRadius.circular(constraints.maxWidth / 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: widget.icon,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Container(
                  height: 24,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1427),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: (widget.selectedData.isEmpty)
                      ? Center(
                          child: Text(
                            'Add ${widget.title}',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: size.width * (12 / 414),
                              letterSpacing: -0.3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              margin: const EdgeInsets.only(left: 6.0, right: 6.0),
                              decoration: BoxDecoration(
                                color: const Color(0x88D9D9D9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '${widget.selectedData.length}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: size.width * (10 / 414),
                                    letterSpacing: -0.3,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  widget.title,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: size.width * (12 / 414),
                                    letterSpacing: -0.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16, height: 16),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
