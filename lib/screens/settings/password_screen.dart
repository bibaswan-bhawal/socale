import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/primary_loading_button.dart';
import 'package:socale/components/TextFields/singleLineTextField/form_text_field.dart';
import 'package:socale/components/TextFields/singleLineTextField/form_text_field_solid.dart';
import 'package:socale/components/keyboard_safe_area.dart';
import 'package:socale/components/snackbar/auth_snackbars.dart';
import 'package:socale/components/translucent_background/bottom_translucent_card.dart';
import 'package:socale/services/auth_service.dart';
import 'package:socale/utils/constraints/constraints.dart';
import 'package:socale/utils/providers/providers.dart';
import 'package:socale/utils/validators.dart';
import 'package:socale/values/colors.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  String currentPassword = "";
  String newPassword = "";

  void onBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  void changePasswordHandler() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!isLoading) {
      setState(() => isLoading = true);
      // Validate input data and try signing in
      final form = _formKey.currentState;
      final isValid = form != null ? form.validate() : false;

      if (isValid) {
        form.save();
        final result = await authService.updatePassword(currentPassword, newPassword);
        if (!result) {
          if (mounted) authSnackBar.passwordIncorrectSnackBar(context);
        } else {
          if (mounted) {
            authSnackBar.passwordChangeSuccessfulSnackBar(context);
            Navigator.of(context).pop();
          }
        }
        setState(() => isLoading = false);
      } else {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userAsyncController);

    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF2D2D2D),
      body: Stack(
        children: [
          BottomTranslucentCard(),
          Column(
            children: [
              Container(
                height: constraints.settingsPageAppBarHeight,
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
                              "Change Password",
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
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: FormTextFieldSolid(
                          hint: "Current Password",
                          icon: 'assets/icons/lock_icons.svg',
                          obscureText: true,
                          validator: Validators.validatePassword,
                          onSave: (value) {
                            if (value != null) {
                              setState(() => currentPassword = value);
                            }
                          },
                          autoFillHints: [""],
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: FormTextFieldSolid(
                          hint: "New Password",
                          icon: 'assets/icons/lock_icons.svg',
                          obscureText: true,
                          validator: Validators.validatePassword,
                          onSave: (value) {
                            if (value != null) {
                              setState(() => newPassword = value);
                            }
                          },
                          autoFillHints: [""],
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: PrimaryLoadingButton(
                          isLoading: isLoading,
                          width: size.width,
                          height: 54,
                          colors: [Color(0xFFFD6C00), Color(0xFFFFA133)],
                          text: "Change Password",
                          onClickEventHandler: changePasswordHandler,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
