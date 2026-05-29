import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class LightTheme {
  ThemeData lightTheme(context) => ThemeData(
    brightness: Brightness.light,
    colorSchemeSeed: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: "Plus Jakarta Sans",
  );
}
