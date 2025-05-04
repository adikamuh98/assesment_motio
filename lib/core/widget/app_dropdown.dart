import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_fonts.dart';

class AppDropdown<T> extends StatelessWidget {
  final T? selectedValue;
  final List<T> items;
  final List<DropdownMenuItem<T>> Function(List<T> items) itemBuilder;
  final Function(T? value) onChanged;
  const AppDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.itemBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        items: itemBuilder.call(items),
        value: selectedValue,
        onChanged: onChanged,
        style: appFonts.caption.ts,
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 5,
          ),
          elevation: 0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: appColors.primary),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
