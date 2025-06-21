import 'package:flutter/services.dart' show rootBundle;

class FileHelpers{
  FileHelpers._();
 static Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }
}