import 'package:flutter/material.dart';
import 'package:socale/components/utils/screen_safe_area.dart';

class ScreenScaffold extends StatelessWidget {
  final Widget body;
  final Widget? background;

  const ScreenScaffold({super.key, required this.body, this.background});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          if (background != null) background!,
          ScreenSafeArea(
            body: body,
          ),
        ],
      ),
    );
  }
}
