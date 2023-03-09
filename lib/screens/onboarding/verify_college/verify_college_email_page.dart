import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/text/gradient_headline.dart';
import 'package:socale/components/text_fields/form_fields/text_input_form_field.dart';
import 'package:socale/components/text_fields/input_forms/default_input_form.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/services/email_verification_service/email_verification_service.dart';
import 'package:socale/utils/validators.dart';

class VerifyCollegeEmailPage extends ConsumerStatefulWidget {
  final String? email;

  final Function() next;
  final Function(String?) saveEmail;

  const VerifyCollegeEmailPage({super.key, required this.next, required this.saveEmail, this.email});

  @override
  ConsumerState<VerifyCollegeEmailPage> createState() => _VerifyCollegeEmailPageState();
}

class _VerifyCollegeEmailPageState extends ConsumerState<VerifyCollegeEmailPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? email;
  String? errorMessage;

  bool isLoading = false;

  saveEmail(String? value) {
    setState(() => email = value);
    widget.saveEmail(value);
  }

  Future<bool> validateForm() async {
    if (kDebugMode) print('verify_college_email_page.dart: form validating');

    final form = formKey.currentState!;
    setState(() => errorMessage = null);
    if (form.validate()) {
      if (kDebugMode) print('verify_college_email_page.dart: form valid');

      form.save();

      return true;
    } else {
      setState(() => errorMessage = 'Please enter a valid edu email');
      return false;
    }
  }

  Future<bool> verifyCollegeEmail() async {
    if (kDebugMode) print('verify_college_email_page.dart: email validating');

    EmailVerificationService service = ref.read(emailVerificationProvider);

    try {
      final response = await service.verifyCollegeEmailValid(email!);

      if (response) {
        if (kDebugMode) print('verify_college_email_page.dart: email valid');
        return true;
      }

      throw Exception();
    } catch (e) {
      if (kDebugMode) print(e);
      showSnackBar(message: 'There was problem sending your code.');
    }

    return false;
  }

  Future<bool> sendCode() async {
    if (kDebugMode) print('verify_college_email_page.dart: sending code');

    EmailVerificationService service = ref.read(emailVerificationProvider);

    try {
      final response = await service.sendCode(email!);
      if (response) return true;
      throw Exception();
    } catch (e) {
      if (kDebugMode) print(e);
      showSnackBar(message: 'There was problem sending your code.');
    }

    return false;
  }

  onSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => isLoading = true);

    if (kDebugMode) print('verify_college_email_page.dart: form submitted');

    if (!(await validateForm())) return setState(() => isLoading = false); // validate form
    if (!(await verifyCollegeEmail())) return setState(() => isLoading = false); // verify email is valid college email
    if (!(await sendCode())) return setState(() => isLoading = false); // send code to email

    setState(() => isLoading = false);
    widget.next();
  }

  showSnackBar({required String message, Duration? duration}) {
    if (mounted) ScaffoldMessenger.of(context).clearSnackBars();
    if (mounted) ScaffoldMessenger.of(context).removeCurrentSnackBar();

    final snackBar = SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      duration: duration ?? const Duration(seconds: 1),
    );
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const GradientHeadline(
          headlinePlain: 'Find your',
          headlineColored: 'college',
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: Text(
            'Socale is made for students to connect\n'
            'with their college community. To find your\n'
            'college enter your edu email.',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: (size.width * 0.034),
              color: ColorValues.textSubtitle,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
              child: Form(
                key: formKey,
                child: DefaultInputForm(
                  errorMessage: errorMessage,
                  children: [
                    TextInputFormField(
                      hintText: 'Email Address',
                      initialValue: widget.email ?? '',
                      textInputType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      prefixIcon: SvgPicture.asset(
                        'assets/icons/email.svg',
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF808080),
                          BlendMode.srcIn,
                        ),
                        width: 16,
                      ),
                      onSaved: saveEmail,
                      validator: Validators.validateEmail,
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 36, left: 36, bottom: 40),
          child: GradientButton(
            text: 'Send Code',
            isLoading: isLoading,
            onPressed: onSubmit,
            linearGradient: ColorValues.blackButtonGradient,
          ),
        ),
      ],
    );
  }
}
