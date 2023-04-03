import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/components/buttons/gradient_button.dart';
import 'package:socale/components/forms/default_input_form.dart';
import 'package:socale/components/input_fields/text_input_field/text_form_field.dart';
import 'package:socale/components/text/gradient_headline.dart';
import 'package:socale/models/college/college.dart';
import 'package:socale/providers/service_providers.dart';
import 'package:socale/resources/colors.dart';
import 'package:socale/services/email_verification_service.dart';
import 'package:socale/utils/system_ui.dart';
import 'package:socale/utils/validators.dart';

class VerifyCollegeEmailPage extends ConsumerStatefulWidget {
  final String? email;
  final Duration timerDuration;

  final Function() next;
  final Function() startTimer;
  final Function(String?) saveEmail;
  final Function(College?) saveCollege;

  const VerifyCollegeEmailPage({
    super.key,
    this.email,
    required this.next,
    required this.saveEmail,
    required this.saveCollege,
    required this.timerDuration,
    required this.startTimer,
  });

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

  bool validateForm() {
    final form = formKey.currentState!;
    setState(() => errorMessage = null);
    if (form.validate()) {
      form.save();

      return true;
    } else {
      setState(() => errorMessage = 'Please enter a valid edu email');
      return false;
    }
  }

  Future<bool> verifyCollegeEmail() async {
    final service = ref.read(onboardingServiceProvider);

    try {
      College? college = await service.getCollegeByEmail(email!);

      if (college != null) {
        widget.saveCollege(college);
        return true;
      } else {
        setState(() => errorMessage = 'Socale is not available at your college yet.');
        return false;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      SystemUI.showSnackBar(context: context, message: 'There was problem sending your code.');
    }

    return false;
  }

  Future<bool> sendCode() async {
    EmailVerificationService service = ref.read(emailVerificationProvider);

    try {
      await service.sendCode(email!);
      if (mounted) SystemUI.showSnackBar(context: context, message: 'A new code was sent to $email');
      return true;
    } catch (e) {
      if (kDebugMode) print(e);
      SystemUI.showSnackBar(context: context, message: 'There was problem sending your code.');
    }

    return false;
  }

  bool shouldSendNewEmail() {
    if (widget.email != email || !(widget.timerDuration.inSeconds < 150)) return true;

    return false;
  }

  onSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() => isLoading = true);

    if (shouldSendNewEmail()) {
      if (!validateForm() || !(await verifyCollegeEmail()) || !(await sendCode())) {
        return setState(() => isLoading = false);
      }
    }

    if (mounted) {
      widget.startTimer();
      setState(() => isLoading = false);
      widget.next();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const GradientHeadline(headlinePlain: 'Find your', headlineColored: 'college'),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: Text(
            'Socale is made for students to connect\n'
            'with their college community. To find your\n'
            'college enter your edu email.',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: (size.width * 0.034),
              color: AppColors.subtitle,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
              child: DefaultInputForm(
                key: formKey,
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
        Padding(
          padding: const EdgeInsets.only(right: 36, left: 36, bottom: 40),
          child: GradientButton(
            text: 'Send Code',
            isLoading: isLoading,
            onPressed: onSubmit,
            linearGradient: AppColors.blackButtonGradient,
          ),
        ),
      ],
    );
  }
}
