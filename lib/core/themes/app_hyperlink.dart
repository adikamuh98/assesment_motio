import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'app_fonts.dart';

class AppHyperlink extends TextSpan {
  AppHyperlink({
    required String text,
    required Function() onTap,
    TextStyle? style,
  }) : super(
          text: text,
          style: style ?? appFonts.caption.primary.ts,
          recognizer: TapGestureRecognizer()..onTap = onTap,
        );
}
