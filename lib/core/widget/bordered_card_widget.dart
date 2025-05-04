import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class BorderedCardWidget extends StatelessWidget {
  final Widget child;
  final Function()? onTap;
  final Function()? onLongPress;
  const BorderedCardWidget({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appColors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: appColors.disabledButton, width: 0.5),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: child,
        ),
      ),
    );
  }
}
