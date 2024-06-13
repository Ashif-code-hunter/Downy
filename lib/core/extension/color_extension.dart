import 'package:flutter/material.dart';

extension HexColor on Color {
  static Color fromHex(String hexColorsString) {
    hexColorsString = hexColorsString.replaceAll('#', '');
    if (hexColorsString.length == 6) {
      hexColorsString = "FF$hexColorsString";
    }
    return Color(int.parse(hexColorsString, radix: 16));
  }
}
