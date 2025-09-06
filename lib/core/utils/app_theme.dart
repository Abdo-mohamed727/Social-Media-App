import 'package:flutter/material.dart';
import 'package:social_media_app/core/utils/colors.dart';

class AppTheme {
  static ThemeData lighttheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.backGround),
    scaffoldBackgroundColor: AppColors.backGround,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}
