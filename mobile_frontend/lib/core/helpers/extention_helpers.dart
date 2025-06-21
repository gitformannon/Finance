extension HttpStatusCode on int? {
  bool isSuccess() => this != null && this! >= 200 && this! < 300;
}


extension StringExtension on String {
  String toShortName() {
    List<String> parts = this.split(" "); // Split the full name

    if (parts.length < 3) return this; // Return original if not enough parts

    String lastName = parts[0][0].toUpperCase() + parts[0].substring(1).toLowerCase(); // Capitalized Last Name
    String firstInitial = parts[1][0].toUpperCase(); // First letter of First Name
    String middleInitial = parts[2][0].toUpperCase(); // First letter of Middle Name

    return "$lastName $firstInitial.$middleInitial.";
  }
}

extension TimeFormatter on int {
  String toHHmm() {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    String hours = dateTime.hour.toString().padLeft(2, '0');
    String minutes = dateTime.minute.toString().padLeft(2, '0');
    return "$hours:$minutes";
  }
}
