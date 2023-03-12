import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppAssets {
  static Widget textFieldIcon(String icon) {
    return SvgPicture.asset(
      icon,
      colorFilter: const ColorFilter.mode(
        Color(0xFF808080),
        BlendMode.srcIn,
      ),
      fit: BoxFit.contain,
    );
  }
}
