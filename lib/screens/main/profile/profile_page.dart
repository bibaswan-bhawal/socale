import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/primary_button_single_color.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/models/User.dart';
import 'package:socale/screens/settings/settings_screen.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/values/colors.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late User currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final userState = ref.watch(userAsyncController);
    userState.whenData((value) => setState(() => currentUser = value));
  }

  void goToSettings() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SettingsPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userAsyncController);
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;

    return Scaffold(
      backgroundColor: Color(0xFF292B2F),
      body: KeyboardSafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 20, right: 20),
                  child: GestureDetector(
                    onTap: goToSettings,
                    child: SvgPicture.asset('assets/icons/settings_icon_24dp.svg'),
                  ),
                ),
              ),
              Column(
                children: [],
              )
            ],
          ),
        ),
      ),
    );
  }
}
