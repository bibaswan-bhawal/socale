import 'package:flutter/material.dart';

abstract class Button extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const Button({super.key, required this.text, required this.onPressed}) : assert(text.length > 0);
}
