class StringHelpers {
  StringHelpers._();

  static String capitalize(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  static String reverse(String input) {
    return input.split('').reversed.join();
  }

  static String capitalizeWords(String text) {
    return text.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
      return word;
    }).join(' ');
  }

  static String compressString(String text) {
    return text.length > 30 ? "${text.substring(0, 30)}.." : text;
  }

 static String removeSpace(String text) {
    return text.replaceAll(" ", "");
  }

 static Map<String, double> parseCoordinates(String coordinates) {
    List<String> parts = coordinates.split(',');
    double latitude = (parts.isNotEmpty) ? double.tryParse(parts[0]) ?? 0.0 : 0.0;
    double longitude = (parts.length > 1) ? double.tryParse(parts[1]) ?? 0.0 : 0.0;

    return {'latitude': latitude, 'longitude': longitude};
  }

  static String formatUzbekPhoneNumber(String phone) {
    // Faqat raqamlarni olib tashlaymiz
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');

    // Tekshiruv: raqam 12 ta belgidan iborat bo'lishi kerak (998XXXXXXXXX)
    if (digitsOnly.length != 12 || !digitsOnly.startsWith("998")) {
      return "Invalid number";
    }

    final code = digitsOnly.substring(3, 5);
    final part1 = digitsOnly.substring(5, 8);
    final part2 = digitsOnly.substring(8, 10);
    final part3 = digitsOnly.substring(10, 12);

    return "$code $part1 $part2 $part3";
  }

  static String onlyNumber(String value){
    return value.replaceAll(RegExp(r'[^\d]'), '');
  }

  static String extractPhoneNumber(String input) {
    // Raqamlarni ajratish va boshqa belgilardan tozalash
    String cleanedNumber = input.replaceAll(RegExp(r'[^0-9]'), '');

    // Agar raqam 12 ta raqamdan iborat bo'lsa, +998 ni olib tashlaymiz
    if (cleanedNumber.startsWith('998') && cleanedNumber.length == 12) {
      cleanedNumber = cleanedNumber.substring(3);
    }

    // Faqat 9 raqamli raqamni qaytarish
    if (cleanedNumber.length == 9) {
      return cleanedNumber;
    }

    return input;
  }
}
