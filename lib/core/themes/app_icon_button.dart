import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final double? iconSize;
  final Function() onTap;
  const AppIconButton({
    super.key,
    required this.icon,
    this.iconColor,
    this.iconSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          size: iconSize ?? 24,
          color: iconColor ?? appColors.primary,
        ),
      ),
    );
  }
}
