import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socale/resources/colors.dart';

class DefaultInputForm extends Form {
  final String? labelText;
  final String? errorMessage;

  DefaultInputForm(
      {Key? key,
      this.labelText,
      this.errorMessage,
      required List<FormField> children,
      Future<bool> Function()? onWillPop,
      void Function()? onChanged,
      AutovalidateMode? autovalidateMode})
      : super(
          key: key,
          onWillPop: onWillPop,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: children.length,
            padding: const EdgeInsets.only(top: 0, bottom: 0),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 1.25, thickness: 1.25, color: Color(0x1A000000)),
            itemBuilder: (BuildContext context, int index) {
              return children[index];
            },
          ),
        );

  @override
  FormState createState() => DefaultInputFormState();
}

class DefaultInputFormState extends FormState {
  @override
  Widget build(BuildContext context) {
    assert(this.widget is DefaultInputForm);

    DefaultInputForm widget = this.widget as DefaultInputForm;

    final child = super.build(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 5),
            child: Text(
              widget.labelText!,
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: widget.errorMessage != null ? Colors.red : Colors.transparent,
              width: 2,
            ),
            gradient: AppColors.cardGradientBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 2,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: child,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 10),
          child: AnimatedOpacity(
            opacity: widget.errorMessage != null ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: Text(
              widget.errorMessage ?? '',
              textAlign: TextAlign.start,
              style: GoogleFonts.roboto(color: Colors.red, fontSize: 12, letterSpacing: -0.3),
            ),
          ),
        )
      ],
    );
  }
}
