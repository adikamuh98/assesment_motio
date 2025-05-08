import 'package:flutter/material.dart';

import '../themes/app_button.dart';
import '../themes/app_colors.dart';
import '../themes/app_fonts.dart';

class AppAlertDialog extends StatelessWidget {
  final String text;
  final String content;
  final Widget contentIcon;
  final String cancelText;
  final String acceptText;
  final Function() onCancel;
  final Function() onAccept;
  const AppAlertDialog({
    super.key,
    required this.text,
    required this.content,
    required this.contentIcon,
    required this.cancelText,
    required this.acceptText,
    required this.onCancel,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: appColors.white,
      surfaceTintColor: appColors.white,
      title: Text(text, style: appFonts.bold.ts, textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          contentIcon,
          const SizedBox(height: 16),
          Text(content, style: appFonts.ts, textAlign: TextAlign.center),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: AppButton(
                onTap: () => onCancel.call(),
                text: cancelText,
                color: appColors.primary,
                textStyle: appFonts.bold.ts.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppButton(
                onTap: () => onAccept.call(),
                text: acceptText,
                color: appColors.disabledButton,
                textStyle: appFonts.bold.primary.ts,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
