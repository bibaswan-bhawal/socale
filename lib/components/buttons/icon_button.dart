import 'package:flutter/material.dart';
import 'package:socale/components/buttons/button.dart';

class RippleIconButton extends Button {
  final Size size;

  const RippleIconButton({
    super.key,
    required super.onPressed,
    required super.icon,
    this.size = const Size(24, 24),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: InkResponse(
        radius: 20,
        splashFactory: InkRipple.splashFactory,
        onTap: onPressed,
        child: icon,
      ),
    );
  }
}
