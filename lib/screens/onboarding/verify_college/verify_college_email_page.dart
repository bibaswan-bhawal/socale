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
import 'package:socale/services/email_verification_service.dart';
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

  validateForm() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final form = formKey.currentState!;

    if (form.validate()) {
      form.save();

      EmailVerificationService service = ref.read(emailVerificationProvider);
      try {
        final verifyValidCollegeEmail = await service.verifyCollegeEmailValid(email!);

        if (!verifyValidCollegeEmail) {
          showSnackBar(
              message: "Looks like socale hasn't launched at your college",
              duration: const Duration(seconds: 2));
          setState(() => isLoading = false);
          return;
        }

        final response = await service.sendCode(email!);

        if (response) {
          setState(() => isLoading = false);
          widget.next();
        } else {
          showSnackBar(message: 'There was problem sending your code.');
        }
      } catch (e) {
        showSnackBar(message: 'There was problem sending your code.');
      }
    } else {
      setState(() => errorMessage = 'Please enter a valid edu email');
    }

    setState(() => isLoading = false);
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
            onPressed: validateForm,
            linearGradient: ColorValues.blackButtonGradient,
          ),
        ),
      ],
    );
  }
}
