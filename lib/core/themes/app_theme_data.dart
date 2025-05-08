import 'package:assesment_motio/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppThemeData {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: appColors.primary,
    textTheme: TextTheme(),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: appColors.primary,
      secondary: appColors.primary,
      surface: Colors.white,
      error: appColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onError: Colors.white,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: appColors.primary,
    textTheme: TextTheme(),
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.dark(
      primary: appColors.primary,
      secondary: appColors.primary,
      surface: Colors.black,
      error: appColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onError: Colors.white,
    ),
  );
}
