import 'package:flutter/material.dart';

class ColorHelpers {
  ColorHelpers._();

  static Color hexToColor(String hexCode) {
    final hex = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
  static List<Color> hardColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.teal,
    Colors.pink,
    Colors.brown, 
    Colors.cyan,
  ];
}
