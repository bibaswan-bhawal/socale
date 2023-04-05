import 'package:flutter/material.dart';
import 'package:socale/components/utils/screen_safe_area.dart';

class ScreenScaffold extends StatelessWidget {
  final Widget body;
  final Widget? background;
  final PreferredSizeWidget? appBar;

  const ScreenScaffold({
    super.key,
    required this.body,
    this.background,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (background != null) background!,
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: appBar,
          body: ScreenSafeArea(
            body: body,
          ),
        ),
      ],
    );
  }
}
