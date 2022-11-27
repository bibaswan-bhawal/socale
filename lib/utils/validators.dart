RegExp emailRegex = RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)");

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || !emailRegex.hasMatch(value)) {
      return "FORMAT_EMAIL_ERROR";
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.length < 8) {
      return ("FORMAT_PASSWORD_ERROR");
    }

    return null;
  }

  static String? validateCode(String? value) {
    if (value == null || value.isEmpty || value.length != 6 || !(int.tryParse(value) != null)) {
      return "Invalid code";
    }

    return null;
  }
}
