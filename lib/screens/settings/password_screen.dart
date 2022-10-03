import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/Buttons/primary_loading_button.dart';
import 'package:socale/components/TextFields/singleLineTextField/form_text_field.dart';
import 'package:socale/components/keyboard_safe_area.dart';
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
      // Validate input data and try signing in
      final form = _formKey.currentState;
      final isValid = form != null ? form.validate() : false;

      if (isValid) {
        form.save();
        setState(() => isLoading = true);
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
            padding: EdgeInsets.only(top: 40),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: SizedBox(
                      height: 80,
                      child: TextFormField(
                        onSaved: (value) => setState(() => currentPassword = value!),
                        validator: Validators.validatePassword,
                        decoration: InputDecoration(
                          label: Text("Current Password"),
                          labelStyle: GoogleFonts.roboto(
                            color: ColorValues.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: ColorValues.white,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: ColorValues.white,
                              width: 3,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: ColorValues.white,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: SizedBox(
                      height: 80,
                      child: TextFormField(
                        onSaved: (value) => setState(() => newPassword = value!),
                        validator: Validators.validatePassword,
                        decoration: InputDecoration(
                          label: Text("New Password"),
                          labelStyle: GoogleFonts.roboto(
                            color: ColorValues.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: ColorValues.white,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: ColorValues.white,
                              width: 3,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: ColorValues.white,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: PrimaryLoadingButton(
                      isLoading: isLoading,
                      width: size.width,
                      height: 60,
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
    );
  }
}
