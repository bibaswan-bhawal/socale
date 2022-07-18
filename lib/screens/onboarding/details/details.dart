import 'package:flutter/material.dart';
import 'package:socale/components/TextFields/singleLineTextField/form_text_field.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final formKey = GlobalKey<FormState>();

  String name = "", email = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          FormTextField(
            hint: "School Email",
            onSave: (value) => {},
            validator: (value) {
              return null;
            },
          ),
          FormTextField(
            hint: "Name",
            onSave: (value) => {},
            validator: (value) {
              return null;
            },
          ),
          MaterialButton(onPressed: () => {submitForm()}),
        ],
      ),
    );
  }

  submitForm() {
    final form = formKey.currentState;

    if (form != null && form.validate()) {
      // CREATE USER
    } else {
      return false;
    }
  }
}
