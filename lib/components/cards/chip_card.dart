import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socale/resources/colors.dart';

class ChipCard extends StatefulWidget {
  final String emptyMessage;

  const ChipCard({super.key, required this.emptyMessage});

  @override
  State<StatefulWidget> createState() => _ChipCardState();
}

class _ChipCardState extends State<ChipCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        height: 160,
        width: size.width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(15),
          gradient: ColorValues.groupInputBackgroundGradient,
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(15),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned(
                right: 10,
                top: 8,
                child: InkResponse(
                  onTap: () {},
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: SvgPicture.asset('assets/icons/add.svg', color: Colors.black),
                  ),
                ),
              ),
              Center(child: Text(widget.emptyMessage)),
            ],
          ),
        ),
      ),
    );
  }
}
