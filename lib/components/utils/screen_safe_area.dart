import 'package:flutter/material.dart';

class ScreenSafeArea extends StatelessWidget {
  final Widget body;

  const ScreenSafeArea({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final displayPadding = MediaQuery.of(context).viewPadding;

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(top: displayPadding.top, bottom: displayPadding.bottom),
        height: size.height,
        width: size.width,
        child: body,
      ),
    );
  }
}
