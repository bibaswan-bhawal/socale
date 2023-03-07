import 'package:flutter/material.dart';

abstract class Button extends StatelessWidget {
  final String? text;
  final Function() onPressed;
  final Widget? icon;

  const Button({super.key, this.text, required this.onPressed, this.icon})
      : assert((text != null) ? icon == null && text.length > 0 : true),
        assert((icon != null) ? text == null : true);
}
