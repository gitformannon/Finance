import 'dart:convert';

class JsonParseHelpers {
  JsonParseHelpers._();

  static Map<String, dynamic> parseJsonString(String jsonString) {
    return jsonDecode(jsonString);
  }
}
