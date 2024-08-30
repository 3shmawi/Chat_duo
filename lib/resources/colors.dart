import 'package:flutter/material.dart';

abstract class AppColors {
  static final primary = _HexColor.fromHex("#6A3DE8");

  static final secondary = _HexColor.fromHex("#E5E5E5");

  static final green = _HexColor.fromHex("#34A853");
  static final yellow = _HexColor.fromHex("#FFCC66");
  static final grey = _HexColor.fromHex("#AEAEAE");
  static final white = _HexColor.fromHex("#FFFFFF");
  static final black = _HexColor.fromHex("#000000");
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
