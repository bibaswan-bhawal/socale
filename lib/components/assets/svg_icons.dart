import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon {
  static Widget asset(
    name, {
    Color? color,
    double? width,
    double? height,
    BlendMode? blendMode,
    BoxFit? fit,
  }) =>
      SvgPicture.asset(
        name,
        width: width,
        height: height,
        colorFilter: ColorFilter.mode(color ?? Colors.black, blendMode ?? BlendMode.srcIn),
        fit: fit ?? BoxFit.contain,
      );
}
