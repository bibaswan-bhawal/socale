import 'package:flutter/material.dart';

class KeyboardSafeArea extends StatefulWidget {
  final Widget child;
  const KeyboardSafeArea({Key? key, required this.child}) : super(key: key);

  @override
  State<KeyboardSafeArea> createState() => _KeyboardSafeAreaState();
}

class _KeyboardSafeAreaState extends State<KeyboardSafeArea> {
  late double availableHeight;

  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mediaQueryData = MediaQuery.of(context);

    if (firstTime) {
      // work around to keep safe area height without keyboard resize
      availableHeight = size.height - mediaQueryData.padding.bottom - mediaQueryData.padding.top;
      firstTime = false;
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(top: mediaQueryData.padding.top),
        height: availableHeight,
        child: widget.child,
      ),
    );
  }
}
