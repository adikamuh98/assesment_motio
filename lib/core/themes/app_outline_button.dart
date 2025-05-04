import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

enum AppOutlineButtonType {
  normal,
  big,
  small,
}

class AppOutlineButton extends StatelessWidget {
  final Color? color;
  final Function()? onTap;
  final bool isDisabled;
  final String? text;
  final IconData? icon;
  final IconData? suffixIcon;
  final double adjustIconSize;
  final Widget? child;
  final AppOutlineButtonType type;
  final bool isFitParent;
  final Color? backgroundColor;

  const AppOutlineButton({
    super.key,
    this.color,
    this.type = AppOutlineButtonType.normal,
    this.onTap,
    this.isDisabled = false,
    this.icon,
    this.suffixIcon,
    this.adjustIconSize = 0,
    this.text,
    this.child,
    this.isFitParent = false,
    this.backgroundColor,
  }) : assert(child != null || text != null || icon != null);

  double get borderRadius => 5;

  EdgeInsets? get padding {
    if (icon != null && text == null) {
      switch (type) {
        case AppOutlineButtonType.normal:
          return const EdgeInsets.all(8);
        case AppOutlineButtonType.big:
          return const EdgeInsets.all(10);
        case AppOutlineButtonType.small:
          return const EdgeInsets.all(8);
      }
    } else {
      switch (type) {
        case AppOutlineButtonType.normal:
          return const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 16,
          );
        case AppOutlineButtonType.big:
          return const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 8,
          );
        case AppOutlineButtonType.small:
          return const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          );
      }
    }
  }

  double get iconSize {
    switch (type) {
      case AppOutlineButtonType.small:
        return appFonts.caption.ts.fontSize! + 1 + adjustIconSize;
      default:
        return appFonts.ts.fontSize! + 1 + adjustIconSize;
    }
  }

  Color? get iconColor {
    if (isDisabled) {
      return appFonts.disabled.color;
    } else {
      return appFonts.primary.color;
    }
  }

  TextStyle get textStyle {
    if (isDisabled) {
      switch (type) {
        case AppOutlineButtonType.small:
          return appFonts.caption.disabled.semibold.ts;
        default:
          return appFonts.disabled.semibold.ts;
      }
    } else {
      switch (type) {
        case AppOutlineButtonType.small:
          return appFonts.caption.semibold.ts.copyWith(
            color: color ?? appColors.primary,
          );
        default:
          return appFonts.semibold.ts.copyWith(
            color: color ?? appColors.primary,
          );
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
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: (isDisabled)
              ? appColors.disabledButton
              : color ?? appColors.primary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: backgroundColor ?? Colors.transparent,
      child: InkWell(
        onTap: () => onTap?.call(),
        borderRadius: BorderRadius.circular(borderRadius),
        // hoverColor: materialColor?.hover,
        // focusColor: materialColor?.hover,
        // highlightColor: materialColor?.pressed,
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
                    style: textStyle,
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
