import 'package:socale/services/onboarding_service.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null) {
      return "Please enter a valid email address.";
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value)) {
      return "Please enter a valid email address.";
    } else {
      return null;
    }
  }

  static String? validateCode(String? value) {
    if (int.tryParse(value!) != null) {
      if (onboardingService.verifyOTP(int.parse(value))) {
        return null;
      } else {
        return "Code is invalid";
      }
    }
    return "Please enter a valid code";
  }

  static String? validateUCSDEmail(String? value) {
    if (value == null) {
      return "Email cannot be blank";
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value)) {
      return "Please enter a valid email address.";
    } else {
      if (value.contains("ucsd.edu") || value.contains("acnochrome@gmail.com") || value.contains("team@socale.com")) return null;
      return "Please enter a UCSD email";
    }
  }

  static String? validatePassword(String? password) {
    if (password != null && password.length > 8) return null;
    return "Please enter a password of at least 8 characters.";
  }
}
