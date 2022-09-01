import 'package:flutter/material.dart';

class AuthSnackBar {
  void defaultErrorMessageSnack(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final errorSnackBar = SnackBar(
      content: Text(
        "Something went wrong signing in, please try again.",
        textAlign: TextAlign.center,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }

  void userNotFoundSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final errorSnackBar = SnackBar(
      content: Text(
        "We could not find your account try signing up.",
        textAlign: TextAlign.center,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }

  void userNotAuthorizedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final errorSnackBar = SnackBar(
      content: Text(
        "Sorry, your email or password was incorrect.",
        textAlign: TextAlign.center,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }

  void signingInSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final loadingSnackBar = SnackBar(
      duration: Duration(days: 365),
      content: Row(
        children: [
          Expanded(
            child: Text(
              "Signing in",
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(loadingSnackBar);
  }

  void dismissSnackBar(context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}

final authSnackBar = AuthSnackBar();
