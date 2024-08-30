import 'package:chat_duo/resources/colors.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData light = ThemeData(
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      primaryContainer: AppColors.secondary,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
        fixedSize: const Size(400, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );

  static ThemeData dark = ThemeData(
    primaryColor: Colors.blue,
    colorScheme: const ColorScheme.dark(
      primaryContainer: Colors.white12,
      primary: Colors.blue,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: AppColors.secondary,
        fixedSize: const Size(400, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
