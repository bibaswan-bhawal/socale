import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/values/colors.dart';

class PrivacyPage extends ConsumerStatefulWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends ConsumerState<PrivacyPage> {
  void onBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userAsyncController);

    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF2D2D2D),
      body: Column(
        children: [
          Container(
            height: 100,
            color: Color(0xFF363636),
            child: KeyboardSafeArea(
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => onBack(context),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: ColorValues.textOnDark,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Settings",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                            color: ColorValues.textOnDark,
                          ),
                        ),
                        Text(
                          "${userState.value!.firstName} ${userState.value!.lastName}",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.3,
                            color: ColorValues.textOnDark,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 8),
              children: [],
            ),
          )
        ],
      ),
    );
  }
}
