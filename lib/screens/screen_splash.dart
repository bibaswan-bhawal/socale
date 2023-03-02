import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socale/components/backgrounds/launch_background.dart';
import 'package:socale/utils/size_config.dart';
import 'package:socale/utils/system_ui.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemUI.setSystemUILight();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const LaunchBackground(),
          Center(
            child: SvgPicture.asset(
              'assets/logo/white_logo.svg',
              width: size.width * 0.35,
            ),
          ),
        ],
      ),
    );
  }
}
