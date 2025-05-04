import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

enum AppButtonType {
  normal,
  big,
  small,
}

class AppButton extends StatelessWidget {
  final Color? color;
  final Function()? onTap;
  final bool isDisabled;
  final String? text;
  final TextStyle? textStyle;
  final IconData? icon;
  final IconData? suffixIcon;
  final double adjustIconSize;
  final Widget? child;
  final AppButtonType type;
  final bool isFitParent;
  final Color? backgroundColor;

  const AppButton({
    super.key,
    this.color,
    this.type = AppButtonType.normal,
    this.onTap,
    this.isDisabled = false,
    this.icon,
    this.suffixIcon,
    this.adjustIconSize = 0,
    this.text,
    this.textStyle,
    this.child,
    this.isFitParent = false,
    this.backgroundColor,
  }) : assert(child != null || text != null || icon != null);

  double get borderRadius => 8;

  EdgeInsets? get padding {
    if (icon != null && text == null) {
      switch (type) {
        case AppButtonType.normal:
          return const EdgeInsets.all(8);
        case AppButtonType.big:
          return const EdgeInsets.all(10);
        case AppButtonType.small:
          return const EdgeInsets.all(8);
      }
    } else {
      switch (type) {
        case AppButtonType.normal:
          return const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 16,
          );
        case AppButtonType.big:
          return const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 8,
          );
        case AppButtonType.small:
          return const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          );
      }
    }
  }

  double get iconSize {
    switch (type) {
      case AppButtonType.small:
        return appFonts.caption.ts.fontSize! + 1 + adjustIconSize;
      default:
        return appFonts.ts.fontSize! + 1 + adjustIconSize;
    }
  }

  Color? get iconColor {
    if (isDisabled) {
      return appFonts.disabled.color;
    } else {
      return appFonts.white.color;
    }
  }

  TextStyle get ts {
    if (isDisabled) {
      switch (type) {
        case AppButtonType.small:
          return appFonts.caption.disabled.semibold.ts;
        default:
          return appFonts.disabled.semibold.ts;
      }
    } else {
      switch (type) {
        case AppButtonType.small:
          return appFonts.caption.white.semibold.ts;
        default:
          return textStyle ?? appFonts.white.semibold.ts;
      }
    }
  }

  MaterialColor? get materialColor {
    return (isDisabled)
        ? null
        : (color != null
            ? (color is MaterialColor)
                ? (color as MaterialColor)
                : null
            : appColors.primary);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          (isDisabled) ? appColors.disabledButton : color ?? appColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        onTap: () => onTap?.call(),
        borderRadius: BorderRadius.circular(borderRadius),
        hoverColor: materialColor?.hover,
        focusColor: materialColor?.hover,
        highlightColor: materialColor?.pressed,
        child: buttonChild,
      ),
    );
  }

  Widget get buttonChild {
    return Container(
      padding: padding,
      child: (child != null)
          ? child
          : Row(
              mainAxisSize: isFitParent ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: iconSize,
                    color: iconColor,
                  ),
                ],
                if (text != null && icon != null) ...[
                  const SizedBox(width: 4),
                ],
                if (text != null) ...[
                  Text(
                    text!,
                    style: ts,
                  ),
                ],
                if (text != null && suffixIcon != null) ...[
                  const SizedBox(width: 4),
                ],
                if (suffixIcon != null) ...[
                  Icon(
                    suffixIcon,
                    size: iconSize - 2,
                    color: iconColor,
                  ),
                ],
              ],
            ),
    );
  }
}
