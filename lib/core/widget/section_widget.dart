import 'package:flutter/material.dart';

import '../themes/app_fonts.dart';

class SectionWidget extends StatelessWidget {
  final String title;
  final Widget? trailingWidget;
  final List<Widget> children;
  const SectionWidget({
    super.key,
    required this.title,
    this.trailingWidget,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            Text(
              title,
              style: appFonts.subtitle.bold.ts,
              textAlign: TextAlign.start,
            ),
            if (trailingWidget != null) ...[
              const Spacer(),
              trailingWidget!,
            ],
          ],
        ),
        const SizedBox(height: 18),
        ...children,
      ],
    );
  }
}
