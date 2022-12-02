import 'package:flutter/material.dart';

class SnackBarMessageManager {
  late ScaffoldMessengerState scaffoldMessenger;

  SnackBarMessageManager(BuildContext? context) {
    if (context == null) {
      throw ("ScaffoldMessengerState context is null");
    }

    scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  void showSnackBarMessage(String text) {
    final snackBar = SnackBar(content: Text(text, textAlign: TextAlign.center));
    scaffoldMessenger.showSnackBar(snackBar);
  }
}
