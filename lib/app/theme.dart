import 'package:flutter/material.dart';

abstract class AppTheme {
  static final light = ThemeData(
    primaryColor: Colors.red,
    colorScheme: const ColorScheme.light(
      primary: Colors.red,
    ),
    primarySwatch: Colors.blue,
    inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hintStyle: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        )),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(300, 50),
      ),
    ),
  );

  static final dark = ThemeData(
    primaryColor: Colors.red,
    colorScheme: const ColorScheme.dark(
      primary: Colors.red,
    ),
    primarySwatch: Colors.grey,
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(fontSize: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      hintStyle: const TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(300, 50),
      ),
    ),
  );
}
