import 'package:assesment_motio/core/themes/app_colors.dart';
import 'package:assesment_motio/core/themes/app_fonts.dart';
import 'package:assesment_motio/main.dart';
import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showSnackbar({
    required String message,
    Color? textColor,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: appFonts.white.ts.copyWith(
          color: textColor ?? appColors.white,
          fontSize: 14,
        ),
      ),
      backgroundColor: backgroundColor ?? Colors.black,
      duration: duration,
    );

    final context = navState.currentContext!;
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void error({required String message}) {
    showSnackbar(message: message, backgroundColor: appColors.error);
  }

  static void success({required String message}) {
    showSnackbar(message: message, backgroundColor: appColors.success);
  }

  static void info({required String message}) {
    showSnackbar(message: message, backgroundColor: appColors.info);
  }

  static void warning({required String message}) {
    showSnackbar(message: message, backgroundColor: appColors.warning);
  }
}
