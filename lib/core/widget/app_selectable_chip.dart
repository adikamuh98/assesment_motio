import 'package:assesment_motio/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppSelectableChip extends StatelessWidget {
  final bool isSelected;
  final String label;
  final Function() onTap;
  const AppSelectableChip({
    super.key,
    required this.isSelected,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: appColors.primary),
      ),
      clipBehavior: Clip.antiAlias,
      color: isSelected ? appColors.primary : appColors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? appColors.white : appColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
