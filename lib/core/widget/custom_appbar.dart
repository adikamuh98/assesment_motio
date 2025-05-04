import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_fonts.dart';

class CustomAppbar extends AppBar {
  final String? titleText;
  final Widget? titleWidget;
  final Widget? trailingWidget;
  final bool isShowBackButton;
  final Color? backButtonColor;
  CustomAppbar({
    super.key,
    this.titleText,
    this.titleWidget,
    super.titleTextStyle,
    this.trailingWidget,
    this.isShowBackButton = true,
    super.backgroundColor,
    this.backButtonColor,
  }) : assert(titleText != null || titleWidget != null);

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: widget.backgroundColor ?? appColors.primary,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            if (widget.isShowBackButton)
              Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    color: widget.backButtonColor ?? appColors.white,
                    width: 0.2,
                  ),
                ),
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.keyboard_arrow_left_rounded,
                    color: widget.backButtonColor ?? appColors.white,
                  ),
                ),
              ),
            if (widget.titleText != null)
              Expanded(
                child: Text(
                  widget.titleText!,
                  style:
                      widget.titleTextStyle ?? appFonts.subtitle.bold.white.ts,
                  textAlign: TextAlign.center,
                ),
              ),
            if (widget.titleWidget != null)
              Expanded(child: widget.titleWidget!),
            if (widget.trailingWidget != null) widget.trailingWidget!,
          ],
        ),
      ),
    );
  }
}
