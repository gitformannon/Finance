import 'dart:convert';

class ValidationHelpers {
  ValidationHelpers._();

  // helpers/validation_helpers.dart
  static bool isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+",
    );
    return emailRegExp.hasMatch(email);
  }

  static Map<String, dynamic> convertToMap(String value) {
    final Map<String, dynamic> data = jsonDecode(value);
    return data;
  }
}
