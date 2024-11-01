import 'package:flutter/material.dart';

abstract class AppColors {
  static final primary = _HexColor.fromHex("#62D2F4");
}

extension _HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
