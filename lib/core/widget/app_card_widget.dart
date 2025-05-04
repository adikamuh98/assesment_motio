import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class AppCardWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Function()? onTap;
  const AppCardWidget({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: appColors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
          child: child,
        ),
      ),
    );
  }
}
