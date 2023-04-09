import 'package:flutter/material.dart';
import 'package:socale/components/backgrounds/light_background.dart';
import 'package:socale/components/utils/screen_scaffold.dart';
import 'package:socale/utils/system_ui.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemUI.setSystemUILight();
    return ScreenScaffold(body: Stack(children: const [LightBackground()]));
  }
}
