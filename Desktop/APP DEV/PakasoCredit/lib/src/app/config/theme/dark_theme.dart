import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DarkTheme {
  ThemeData darkTheme(context) => ThemeData(
    brightness: Brightness.dark,
    colorSchemeSeed: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    fontFamily: "Plus Jakarta Sans",
  );
}
