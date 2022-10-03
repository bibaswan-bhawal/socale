import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/primary_button.dart';
import 'package:socale/components/avatar_selector/avatar_selector.dart';
import 'package:socale/components/avatar_selector_item/avatar_selector_item.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/components/translucent_background/translucent_background_dark.dart';
import 'package:socale/utils/options/avatars.dart';
import 'package:socale/values/colors.dart';

class AvatarPicker extends ConsumerStatefulWidget {
  final String initial;
  const AvatarPicker({Key? key, required this.initial}) : super(key: key);

  @override
  ConsumerState<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends ConsumerState<AvatarPicker> {
  final PageController _avatarSelector = PageController();

  File? profilePic;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      if (widget.initial.isNotEmpty) {
        _avatarSelector.jumpToPage(avatars.indexOf(widget.initial));
      }
    });
  }

  void _onBackPress() {
    Navigator.pop(context, "");
  }

  void _onClickEventHandler() {
    Navigator.pop(context, avatars[_avatarSelector.page!.toInt()]);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          TranslucentBackgroundDark(),
          KeyboardSafeArea(
            child: Stack(
              children: [
                Positioned(
                  left: 10,
                  top: 20,
                  child: IconButton(
                    onPressed: _onBackPress,
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 90, left: 30),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Choose an ',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: 'Avatar',
                                style: GoogleFonts.poppins(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()..shader = ColorValues.socaleOrangeGradient,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30, right: 80, top: 5),
                        child: Text(
                          "This will be your avatar until you decide to share your profile",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: PageView(
                                controller: _avatarSelector,
                                physics: BouncingScrollPhysics(),
                                children: [
                                  for (String avatar in avatars)
                                    AvatarSelectorItem(
                                      image: 'assets/images/avatars/$avatar',
                                      sub: avatar.replaceAll('.png', ''),
                                      isDark: true,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 150,
                            width: size.width,
                            child: AvatarSelector(
                              onChange: (value) {
                                // set current avatar
                                _avatarSelector.animateToPage(value, duration: Duration(milliseconds: 300), curve: Curves.easeInOutCirc);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: PrimaryButton(
                        width: size.width,
                        height: 60,
                        colors: [Color(0xFFFD6C00), Color(0xFFFFA133)],
                        text: "Save",
                        onClickEventHandler: _onClickEventHandler,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
